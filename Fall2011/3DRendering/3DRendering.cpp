///////////////////////////////////////////////////////////////////////////////
//  AUTHOR: Song Ho Ahn (song.ahn@gmail.com)
// CREATED: 2005-10-04
// UPDATED: 2005-10-28
//
// modified and adapted by Jason Lin <jasonli1@andrew.cmu.edu>
// reads from a text file dumped from Google Sketchup and renders in OpenGL the same scene with same camera parameters
///////////////////////////////////////////////////////////////////////////////
#include <stdlib.h>
#include <cstdio>
#include <GL/glut.h>
#include <GL/glext.h>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <fstream>
#include <string>
#include <windows.h>
//#include <dirent.h>

using std::stringstream;
using std::cout;
using std::endl;
using std::ends;
using namespace std;

// GLUT CALLBACK functions
void doStuff();
void displayCB();
void reshapeCB(int w, int h);

void initGL();
int  initGLUT(int argc, char **argv);
bool initSharedMem();
void clearSharedMem();
void setCamera(float camera[9]);
void draw3();
void computeFaceNormal(GLfloat* v1, GLfloat* v2, GLfloat* v3, GLfloat* crossP);

// global variables
void *font = GLUT_BITMAP_8_BY_13;
bool mouseLeftDown;
bool mouseRightDown;
bool mouseMiddleDown;
float mouseX, mouseY;
float cameraAngleX;
float cameraAngleY;
float cameraDistance;
int drawMode = 0;
int maxVertices;
int maxIndices;

// function pointer to OpenGL extensions
PFNGLDRAWRANGEELEMENTSPROC glDrawRangeElements = 0; 

// camera params read in from file
float fov_vertical;   // fov of SU scene
float aspect_ratio;   // aspect ratio of uiuc image

// variables for reading in text file and storing vertices/edges info
GLfloat*** vertices;
GLubyte*** edges;
int* numFacesForComp;
int** numVerticesForFace;
int** numEdgesForFace;
int numComps;
FILE *f;

GLubyte* bitmap;
int bitmap_w;
int bitmap_h;
int bitmap_w_used;
int bitmap_h_used;
int bitmap_bpp;

// read in vertices and edges information from text file generated from MATLAB (SU vertices/edges format)
// the file contains the number of components in the scene, the number of faces in each component, the vertices of each
// face and the edges of each face, separated by character delimiters
// polygon info stored using two 3D arrays, first dim is components, second dim is vertices/edges, third dim is  
// coordinates of vertices/which edges to draw for each face(triangles)
void readInValues()
{
	int compIndex=0;
	fscanf(f,"%d",&numComps);// scan in number of components for this scene
	vertices=(GLfloat***)malloc(sizeof(GLfloat**)*(numComps));// 3d array of vertices
	edges=(GLubyte***)malloc(sizeof(GLubyte**)*(numComps));// 3d array of edges
	numFacesForComp=(int*)malloc(sizeof(int)*numComps);// number of faces this component has
	numVerticesForFace=(int**)malloc(sizeof(int*)*numComps);// number of vertices the faces have
	numEdgesForFace=(int**)malloc(sizeof(int*)*numComps);// number of edges the faces have
	while (!feof(f))
	{
		char delim[10];// for scanning in delimiter
		int	numFaces;
		fscanf(f,"%d",&numFaces);// number of faces for component compIndex, read in from file
		if (numFaces==0)// this component has no faces(empty), so decrease the number of valid components
		{
			fscanf(f,"%s",delim);
			numComps--;
			continue;
		}
		numFacesForComp[compIndex]=numFaces;// number of faces from component compIndex
		vertices[compIndex]=(GLfloat**)malloc(sizeof(GLfloat*)*(numFaces));// vertices subarray for this comp
		edges[compIndex]=(GLubyte**)malloc(sizeof(GLubyte*)*(numFaces));// edges subarray for this comp
		numVerticesForFace[compIndex]=(int*)malloc(sizeof(int)*(numFaces));// number of vertices for the faces of this comp
		numEdgesForFace[compIndex]=(int*)malloc(sizeof(int)*(numFaces));// number of edges for the faces of this comp
		int faceIndex=0;
		while (1)
		{
			int numVertices,numEdges;
			float fl;int in;
			// scan in the vertices
			// read in number of vertices for face faceIndex of component compIndex
			//  (this info needed so I know the size of the vertices subarray)
			if (fscanf(f,"%d",&numVertices)<=0)
				break;
			numVerticesForFace[compIndex][faceIndex]=(numVertices);
			// stores all the vertices for face faceIndex of component compIndex, in format x1,y1,z1, x2,y2,z2....
			// obtained from SU's mesh.points
			vertices[compIndex][faceIndex]=(GLfloat*)malloc(sizeof(GLfloat)*(numVertices));
			// read in all the vertices for face faceIndex of component compIndex
			int j=0;
			while(fscanf(f,"%f",&fl)==1)
			{
				vertices[compIndex][faceIndex][j]=static_cast<GLfloat>(fl);
				j++;	
			}
			fscanf(f,"%c",delim);// scan in delimiter signalling end of vertices for this face
			// now scan in the edges
			if (fscanf(f,"%d",&numEdges)<=0)// number of edges for face faceIndex of component compIndex, read in from file
				break;
			numEdgesForFace[compIndex][faceIndex]=(numEdges);
			// stores all the edges for face faceIndex of component compIndex (obtained from SU's mesh.polygons)
			edges[compIndex][faceIndex]=(GLubyte*)malloc(sizeof(GLubyte)*(numEdges+1));
			j=0;
			// read in all the edges for face faceIndex of component compIndex
			while(fscanf(f,"%d",&in)==1)
			{
				edges[compIndex][faceIndex][j]=static_cast<GLubyte>(in-1);// MATLAB indices start from 1, C++ from 0
				j++;
			}
			fscanf(f,"%s",delim);// scan in delimiter signalling end of edges for this face, or signalling end of this component
			// the delimiter "CZ" means end of this component, so break out of the loop, increment compIndex
			// and proceed to read in the vertices and edges of the next component
			// otherwise, increment faceIndex and continue with next face
			if (strcmp(delim,"CZ")==0)
				break;
			faceIndex++;// next face
		}
		compIndex++;// next component
	}
}

void draw3()
{
	// enable and specify pointers to vertex arrays
	glEnableClientState(GL_VERTEX_ARRAY);
	glPushMatrix();
	int i=0,j;
	for (i=0;i<numComps;i++){// for each scene component
		for (j=0;j<numFacesForComp[i];j++)// for each face in the scene component
		{
			/*
			// draw faces in red
			glVertexPointer(3, GL_FLOAT, 0, vertices[i][j]);// give OpenGL the vertices for this face
			glColor3f(1.0f, 0.0f, 0.0f);// red
			// give OpenGL the edges for this face, and also the number of edges for this face
			glDrawElements(GL_TRIANGLES, numEdgesForFace[i][j], GL_UNSIGNED_BYTE, edges[i][j]);
			// draw face boundaries in black
			glColor3f(0.0f, 0.0f, 0.0f);// black
			glDrawElements(GL_LINES, numEdgesForFace[i][j], GL_UNSIGNED_BYTE, edges[i][j]);
			*/

			glVertexPointer(3, GL_FLOAT, 0, vertices[i][j]);// give OpenGL the vertices for this face
			GLfloat v1[3]={vertices[i][j][0],vertices[i][j][1],vertices[i][j][2]};
			GLfloat v2[3]={vertices[i][j][3],vertices[i][j][4],vertices[i][j][5]};
			GLfloat v3[3]={vertices[i][j][6],vertices[i][j][7],vertices[i][j][8]};
			GLfloat* crossP = (GLfloat*)malloc(3*sizeof(GLfloat));
			computeFaceNormal(v1,v2,v3,crossP);
			glColor3f(crossP[0],crossP[1],crossP[2]);
			// give OpenGL the edges for this face, and also the number of edges for this face
			glDrawElements(GL_TRIANGLES, numEdgesForFace[i][j], GL_UNSIGNED_BYTE, edges[i][j]);
			// draw face boundaries in black
			//glColor3f(0.0f, 0.0f, 0.0f);// black
			//glDrawElements(GL_LINES, numEdgesForFace[i][j], GL_UNSIGNED_BYTE, edges[i][j]);
		}
	}
	glPopMatrix();
	glDisableClientState(GL_VERTEX_ARRAY);  // disable vertex arrays
}

void computeFaceNormal(GLfloat* v1, GLfloat* v2, GLfloat* v3, GLfloat* crossP)
{
	GLfloat edge1[3]={v1[0]-v2[0],v1[1]-v2[1],v1[2]-v2[2]};
	GLfloat edge2[3]={v1[0]-v3[0],v1[1]-v3[1],v1[2]-v3[2]};
	crossP[0]=abs(edge1[1]*edge2[2]-edge1[2]*edge2[1]);
	crossP[1]=abs(edge1[2]*edge2[0]-edge1[0]*edge2[2]);
	crossP[2]=abs(edge1[0]*edge2[1]-edge1[1]*edge2[0]);
	GLfloat crossPMag=sqrt(crossP[0]*crossP[0]+crossP[1]*crossP[1]+crossP[2]*crossP[2]);
	for (int i=0;i<3;i++)
		crossP[i]/=crossPMag;
}

/*
void initTexture() {
// Rather than decompressing our jpeg, I've written it to a simple raw file as
// power of 2 sized stream of bytes.
FILE* fp = fopen("D:/uiuc043.raw", "rb");
// These should be power of 2 dimensions
fread(&bitmap_w, sizeof(int), 1, fp);
fread(&bitmap_h, sizeof(int), 1, fp);
// These are the actual sizes we use.
fread(&bitmap_w_used, sizeof(int), 1, fp);
fread(&bitmap_h_used, sizeof(int), 1, fp);
fread(&bitmap_bpp, sizeof(int), 1, fp);
// And the bytes as a big rgb array.
int size = bitmap_w * bitmap_h * bitmap_bpp;
bitmap = new BYTE[size];
fread(bitmap, sizeof(BYTE), size, fp);
fclose(fp);
}
*/

///////////////////////////////////////////////////////////////////////////////
int main(int argc, char **argv)
{
	initSharedMem();

	// init GLUT and GL
	initGLUT(argc, argv);
	initGL();

	//initTexture(); // for overlaying the jpeg on top
	fov_vertical=0.0f;

	// check max of elements vertices and elements indices that your video card supports
	// Use these values to determine the range of glDrawRangeElements()
	// The constants are defined in glext.h
	glGetIntegerv(GL_MAX_ELEMENTS_VERTICES, &maxVertices);
	glGetIntegerv(GL_MAX_ELEMENTS_INDICES, &maxIndices);

	// get function pointer to glDrawRangeElements
	glDrawRangeElements = (PFNGLDRAWRANGEELEMENTSPROC)wglGetProcAddress("glDrawRangeElements");

	// the last GLUT call (LOOP)
	// window will be shown and display callback is triggered by events
	// NOTE: this call never return main().

	/*DIR *dir;
	struct dirent *ent;
	dir = opendir ("c:\\src\\");
	if (dir != NULL) {

	// print all the files and directories within directory 
	while ((ent = readdir (dir)) != NULL) {
	printf ("%s\n", ent->d_name);
	}
	closedir (dir);
	} else {
	//could not open directory 
	perror ("");
	return EXIT_FAILURE;
	}*/
	cout<<"entering main\n";
	glutMainLoop(); /* Start GLUT event-processing loop */

	return 0;
}

///////////////////////////////////////////////////////////////////////////////
// initialize GLUT for windowing
///////////////////////////////////////////////////////////////////////////////
int initGLUT(int argc, char **argv)
{
	// read in camera parameters from file

	// GLUT stuff for windowing
	// initialization openGL window.
	// it is called before any other GLUT routine
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL);   // display mode
	glutInitWindowSize(600, 600);               // window size
	glutInitWindowPosition(100, 100);           // window location

	// finally, create a window with openGL context
	// Window will not displayed until glutMainLoop() is called
	// it returns a unique ID
	int handle = glutCreateWindow(argv[0]);     // param is the title of window

	// register GLUT callback functions
	glutDisplayFunc(displayCB);
	glutReshapeFunc(reshapeCB);
	glutIdleFunc(doStuff);

	return handle;
}

///////////////////////////////////////////////////////////////////////////////
// initialize OpenGL
// disable unused features
///////////////////////////////////////////////////////////////////////////////
void initGL()
{
	glShadeModel(GL_FLAT);                    // shading mathod: GL_SMOOTH or GL_FLAT
	glPixelStorei(GL_UNPACK_ALIGNMENT, 4);      // 4-byte pixel alignment
	glPixelStorei(GL_PACK_ALIGNMENT, 1); 

	// enable /disable features
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_COLOR_MATERIAL);
	glPolygonMode(GL_BACK, GL_FILL);
	glFrontFace(GL_CW);

	glClearColor(1, 1, 1, 0);                   // background color
	glClearDepth(1.0f);                         // 0 is near, 1 is far
	glDepthFunc(GL_LEQUAL);

	// read in camera params, eye and target from file


}

///////////////////////////////////////////////////////////////////////////////
// initialize global variables
///////////////////////////////////////////////////////////////////////////////
bool initSharedMem()
{
	mouseLeftDown = mouseRightDown = mouseMiddleDown = false;
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// clean up shared memory
///////////////////////////////////////////////////////////////////////////////
void clearSharedMem()
{
}

///////////////////////////////////////////////////////////////////////////////
// set camera position and lookat direction
///////////////////////////////////////////////////////////////////////////////
/*
void setCamera(float posX, float posY, float posZ, float targetX, float targetY, float targetZ)
{
glMatrixMode(GL_MODELVIEW);
glLoadIdentity();
gluLookAt(posX, posY, posZ, targetX, targetY, targetZ, 0, 0, 1); // eye(x,y,z), focal(x,y,z), up(x,y,z)
}
*/

void setCamera(float camera[9])
{
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(camera[0], camera[1], camera[2],
		camera[3], camera[4], camera[5],
		camera[6], camera[7], camera[8]);
}

//=============================================================================
// CALLBACKS
//=============================================================================
int i=0;
void doStuff()
{
	cout<<"doStuff\n";
	//Sleep(8000);
	i++;
	//if (i>20)
	//	exit(1);
	if (i%2==0)
		f=fopen("D:/a.txt","r");
	else
		f=fopen("D:/uiuc043.txt","r");
	fscanf(f,"%f",&aspect_ratio);
	fscanf(f,"%f",&fov_vertical);

	float cameraParams[9];
	int k=0;
	for (k=0;k<9;k++)
	{
		fscanf(f,"%f",&(cameraParams[k]));
	}
	setCamera(cameraParams);
	if (i%2==0)
		glutReshapeWindow(600*(aspect_ratio),600);
	else
		glutReshapeWindow(1200*(aspect_ratio),1200);
	
	// cameraParams[0,1,2] - eye(x,y,z), cameraParams[3,4,5] - target(x,y,z)
	//setCamera(cameraParams[0],cameraParams[1],cameraParams[2],
	//cameraParams[3],cameraParams[4],cameraParams[5]);
	// read in vertices info from MATLAB dump
	readInValues();
	fclose(f);

}
/*
void displayCB()
{
// clear buffer
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

// save the initial ModelView matrix before modifying ModelView matrix
glPushMatrix();

// transform camera
glTranslatef(0, 0, cameraDistance);
glRotatef(cameraAngleX, 1, 0, 0);   // pitch
glRotatef(cameraAngleY, 0, 1, 0);   // heading

draw3();        // with glDrawElements()

glPopMatrix();

glutSwapBuffers();


FILE * out = fopen("D:/d.txt","w");
unsigned char *pixelData=(unsigned char*)malloc(799*600*aspect_ratio*3);
memset(pixelData,123,1000);
glReadBuffer(GL_FRONT);
glReadPixels(0,0,799,600,GL_RGB,GL_UNSIGNED_BYTE,pixelData);
for (int i =0;i<600*799*3+10;i++)
{
fprintf(out,"%d\n",pixelData[i]);
}
}
*/

void displayCB()
{
	cout<<"display\n";
	/*
	// Draw a full screen texture.
	glEnable(GL_TEXTURE_2D);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, bitmap_w, bitmap_h, 0, GL_BGR, GL_UNSIGNED_BYTE, bitmap);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
	glLoadIdentity();
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();

	glDepthMask(GL_FALSE);
	double t_width = (double)bitmap_w_used / (double)bitmap_w;
	double t_height = (double)bitmap_h_used / (double)bitmap_h;
	glColor3d(0, 1, 0);
	glBegin(GL_QUADS);
	glTexCoord2d(0, 0);
	glVertex2d(-1, 1);
	glTexCoord2d(t_width, 0);
	glVertex2d(1, 1);
	glTexCoord2d(t_width, t_height);
	glVertex2d(1, -1);
	glTexCoord2d(0, t_height);
	glVertex2d(-1, -1);
	glEnd();
	glDepthMask(GL_TRUE);

	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
	glDisable(GL_TEXTURE_2D);
	*/	
	// clear buffer
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

	draw3();        // with glDrawElements()

	glutSwapBuffers();
}

void reshapeCB(int w, int h)
{
	cout<<"reshape"<<w<<h<<"\n";
	// set viewport to be the entire window
	glViewport(0, 0, (GLsizei)w, (GLsizei)h);

	// set perspective viewing frustum
	float aspectRatio = (float)w / h;
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	//glFrustum(-aspectRatio, aspectRatio, -1, 1, 1, 100);
	gluPerspective(fov_vertical, (float)(w)/h, 1.0f, 1000.0f); // FOV, AspectRatio, NearClip, FarClip

	// switch to modelview matrix in order to set scene
	glMatrixMode(GL_MODELVIEW);
}

