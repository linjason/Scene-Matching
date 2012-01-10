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
#include <iostream>
#include <cmath>
#include <ctime>
// for openGL
#include <GL/glut.h>
#include <GL/glext.h>

// for openCV
#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <dirent.h>

using namespace std;
using namespace cv;

// GLUT CALLBACK functions
void doStuff();
void displayCB();
void reshapeCB(int w, int h);

// other function prototypes
void initGL();
int  initGLUT(int argc, char **argv);
bool initSharedMem();
void clearSharedMem();
void setCamera(float camera[9]);
void drawNormalMask();
void drawBinaryMask();
void computeFaceNormal(GLfloat* v1, GLfloat* v2, GLfloat* v3, GLfloat* crossP);
void initSceneDumpDir();
void initCameraParamsAndClutterMask();
void findSceneBounds(float* minBound, float* maxBound);

// global variables
//void *font = GLUT_BITMAP_8_BY_13;
bool mouseLeftDown;
bool mouseRightDown;
bool mouseMiddleDown;
float cameraAngleX;
float cameraAngleY;
float cameraDistance;
int maxVertices;
int maxIndices;

// function pointer to OpenGL extensions
// TODO(jasonlin1): Is this line of code needed for anything?
// PFNGLDRAWRANGEELEMENTSPROC glDrawRangeElements = 0;

// camera params read in from file
float fov_vertical;   // fov of SU scene
float aspect_ratio;   // aspect ratio of uiuc image, only used when reading in photomatched scenes, otherwise aspect ratio is that of clutter mask
float* cameraParams;  // camera parameters read in from file

// directory of SKP scene dump files to read in and render
#define SCENE_DUMP_DIR ("skp/")
DIR *dir; // the directory
struct dirent *ent;// the file entry

int currWidth; // size of the clutter mask, rendered scene size is supposed to be this size too
int currHeight;

Mat m; // the clutter mask to compare scenes to, in OpenCV Mat format

// variables for reading in text file and storing vertices/edges info
GLfloat*** vertices;
GLubyte*** edges;
int* numFacesForComp;
int** numVerticesForFace;
int** numEdgesForFace;
int numComps;
FILE *f;


// variables used to render texture (original uiuc image) on top of scene (from Google, not used now)
GLubyte* bitmap;
int bitmap_w;
int bitmap_h;
int bitmap_w_used;
int bitmap_h_used;
int bitmap_bpp;

// read in vertices and edges information from text file generated from MATLAB (SU vertices/edges format)
// the file contains the number of components in the scene, the number of faces in each component, the vertices of each
// face and the edges of each face, separated by character delimiters
// polygon info stored using two 3D arrays, first dim is components, second dim is faces, third dim is
// coordinates of vertices/which edges to draw for each face
void readInValues() {
  int compIndex=0;
  fscanf(f,"%d",&numComps);// scan in number of components for this scene
  vertices=(GLfloat***)malloc(sizeof(GLfloat**)*(numComps));// 3d array of vertices
  edges=(GLubyte***)malloc(sizeof(GLubyte**)*(numComps));// 3d array of edges
  numFacesForComp=(int*)malloc(sizeof(int)*numComps);// number of faces this component has
  numVerticesForFace=(int**)malloc(sizeof(int*)*numComps);// number of vertices the faces have
  numEdgesForFace=(int**)malloc(sizeof(int*)*numComps);// number of edges the faces have
  while (!feof(f)) {
    char delim[10];// for scanning in delimiter
    int	numFaces;
    fscanf(f,"%d",&numFaces);// number of faces for component compIndex, read in from file
    if (numFaces==0) { // this component has no faces(empty), so decrease the number of valid components
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
    while (1) {
      int numVertices,numEdges;
      float fl;
      int in;
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
      while (fscanf(f,"%f",&fl)==1) {
        vertices[compIndex][faceIndex][j]=static_cast<GLfloat>(fl);
        j++;
      }
      fscanf(f,"%c",delim);// scan in delimiter signalling end of vertices for this face
      // now scan in the edges
      if (fscanf(f,"%d",&numEdges)<=0)// number of edges for face faceIndex of component compIndex, read in from file
        break;
      numEdgesForFace[compIndex][faceIndex]=(numEdges);
      // stores all the edges for face faceIndex of component compIndex (obtained from SU's mesh.polygons)
      edges[compIndex][faceIndex]=(GLubyte*)malloc(sizeof(GLubyte)*(numEdges));
      j=0;
      // read in all the edges for face faceIndex of component compIndex
      while (fscanf(f,"%d",&in)==1) {
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

/**
 * ADD COMMENT
 */
void drawNormalMask() {
  // enable and specify pointers to vertex arrays
  glEnableClientState(GL_VERTEX_ARRAY);
  glPushMatrix();

  for (int i=0; i<numComps; i++) { // for each scene component
    for (int j=0; j<numFacesForComp[i]; j++) { // for each face in the scene component
      // surface normals
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

/**
 * ADD COMMENT
 */
void drawBinaryMask() {
  // enable and specify pointers to vertex arrays
  glEnableClientState(GL_VERTEX_ARRAY);
  glPushMatrix();

  for (int i=0; i<numComps; i++) { // for each scene component
    for (int j=0; j<numFacesForComp[i]; j++) { // for each face in the scene component
      // binary mask
      // draw faces in white
      glVertexPointer(3, GL_FLOAT, 0, vertices[i][j]);// give OpenGL the vertices for this face
      glColor3f(1.0f, 1.0f, 1.0f);// white
      // give OpenGL the edges for this face, and also the number of edges for this face
      glDrawElements(GL_TRIANGLES, numEdgesForFace[i][j], GL_UNSIGNED_BYTE, edges[i][j]);
      // draw face boundaries in white
      glColor3f(1.0f, 1.0f, 1.0f);// white
      glDrawElements(GL_LINES, numEdgesForFace[i][j], GL_UNSIGNED_BYTE, edges[i][j]);

    }
  }
  glPopMatrix();
  glDisableClientState(GL_VERTEX_ARRAY);  // disable vertex arrays
}

/**
 * ADD COMMENT
 */
void computeFaceNormal(GLfloat* v1, GLfloat* v2, GLfloat* v3, GLfloat* crossP) {
  GLfloat edge1[3]={v1[0]-v2[0],v1[1]-v2[1],v1[2]-v2[2]};
  GLfloat edge2[3]={v1[0]-v3[0],v1[1]-v3[1],v1[2]-v3[2]};
  crossP[0]=abs(edge1[1]*edge2[2]-edge1[2]*edge2[1]);
  crossP[1]=abs(edge1[2]*edge2[0]-edge1[0]*edge2[2]);
  crossP[2]=abs(edge1[0]*edge2[1]-edge1[1]*edge2[0]);
  GLfloat crossPMag=sqrt(crossP[0]*crossP[0]+crossP[1]*crossP[1]+crossP[2]*crossP[2]);
  for (int i=0; i<3; i++)
    crossP[i]/=crossPMag;
}

/**
 * ADD COMMENT
 */
int main(int argc, char **argv) {
  int t=clock();
  cout<<"time:"<<t<<endl;
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
  //glDrawRangeElements = (PFNGLDRAWRANGEELEMENTSPROC)wglGetProcAddress("glDrawRangeElements");

  // the last GLUT call (LOOP)
  // window will be shown and display callback is triggered by events
  // NOTE: this call never return main().

  cout<<"entering main\n";

  initSceneDumpDir();
  initCameraParamsAndClutterMask();
  glutMainLoop(); /* Start GLUT event-processing loop */

  return 0;
}

///////////////////////////////////////////////////////////////////////////////
// initialize GLUT for windowing
///////////////////////////////////////////////////////////////////////////////
int initGLUT(int argc, char **argv) {
  // read in camera parameters from file

  // GLUT stuff for windowing
  // initialization openGL window.
  // it is called before any other GLUT routine
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL);   // display mode
  glutInitWindowSize(600, 600);               // window size
  glutInitWindowPosition(200, 200);           // window location

  // finally, create a window with openGL context
  // Window will not displayed until glutMainLoop() is called
  // it returns a unique ID
  int handle = glutCreateWindow(argv[0]);     // param is the title of window

  // register GLUT callback functions

  // the event loop should be in the following order: doStuff(read in and initialize values and parameters), reshape, display, then doStuff...
  // I do not have absolute control over the sequence of events but the sequence has been correct in my tests
  // I cannot combine the three functions into the display callback because I can't change camera params, screen sizes etc in the display function *******NEED TO VERIFY IF THIS IS TRUE****
  glutDisplayFunc(displayCB);
  glutReshapeFunc(reshapeCB);
  glutIdleFunc(doStuff);

  return handle;
}

///////////////////////////////////////////////////////////////////////////////
// initialize OpenGL
// disable unused features
///////////////////////////////////////////////////////////////////////////////
void initGL() {
  glShadeModel(GL_FLAT);                    // shading mathod: GL_SMOOTH or GL_FLAT
  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);      // 4-byte pixel alignment
  glPixelStorei(GL_PACK_ALIGNMENT, 1);     // 1-byte pixel alignment

  // enable /disable features
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_TEXTURE_2D);
  glEnable(GL_COLOR_MATERIAL);
  glPolygonMode(GL_BACK, GL_FILL);
  glFrontFace(GL_CW);

  glClearColor(0, 0, 0, 0);                   // background color
  glClearDepth(1.0f);                         // 0 is near, 1 is far
  glDepthFunc(GL_LEQUAL);
}

///////////////////////////////////////////////////////////////////////////////
// initialize global variables
///////////////////////////////////////////////////////////////////////////////
bool initSharedMem() {
  mouseLeftDown = mouseRightDown = mouseMiddleDown = false;
  return true;
}

///////////////////////////////////////////////////////////////////////////////
// clean up shared memory
///////////////////////////////////////////////////////////////////////////////
// TODO(jasonlin1): Are there any issues with memory leaks that you know of?
//     Do we need to free memory at some point?
void clearSharedMem() {
}

///////////////////////////////////////////////////////////////////////////////
// set camera position and lookat direction
///////////////////////////////////////////////////////////////////////////////
void setCamera(float camera[9]) {
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  gluLookAt(camera[0], camera[1], camera[2],
            camera[3], camera[4], camera[5],
            camera[6], camera[7], camera[8]);
}

//=============================================================================
// CALLBACKS
//=============================================================================
// TODO(jasonlin1): Change this to a informative function name.
void doStuff() {
  cout<<"doStuff ";
  // iterate through all the SKP scenes in the directory until no more scenes, then sleep
  do {
    ent = readdir(dir);
    if (ent==NULL) {
      int t=clock();
      cout<<"time:"<<t<<endl;
      //TODO(jasonlin1): The Sleep function was undefined on my system
      //    Is it necessary for anything?
      //Sleep(10000000);
    }
  } while (ent->d_type!=DT_REG);

  // construct the file name of the scene dump text file and open it
  char fileName[50]=SCENE_DUMP_DIR;
  strcat(fileName,ent->d_name);
  cout<<fileName<<endl;
  f=fopen(fileName,"r");

  // read in vertices info from MATLAB dump
  readInValues();
  fclose(f);

  // TODO(satkin): Deal with camera parameter issues.
  // construct camera params from params about this uiuc image that is read in
  // *****************you'll need to change this because your camera params are different from mine
  setCamera(cameraParams);

  // find the min and max bounds for the scene, may be useful in obtaining camera params
  float* minBound=new float[3];
  float* maxBound=new float[3];
  findSceneBounds(minBound, maxBound);
  //cout<<minBound[0]<<" "<<minBound[1]<<" "<<minBound[2]<<" "<<maxBound[0]<<" "<<maxBound[1]<<" "<<maxBound[2]<<endl;

  currWidth=m.cols;
  currHeight=m.rows;
  glutReshapeWindow(m.cols,m.rows);
  reshapeCB(m.cols,m.rows);
  glutPostRedisplay();
}

void displayCB() {
  cout<<"display ";
  // clear buffer
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

  drawNormalMask();        // with glDrawElements()

  glutSwapBuffers(); // display the buffer we just drew

  // make sure that the current window size is the same as the clutter mask
  currWidth =m.cols;
  currHeight = m.rows;
  glutReshapeWindow(m.cols,m.rows);

  //TODO(satkin): For some reason the assert doesn't work, commenting out for now.
  //assert(currWidth==glutGet(GLUT_WINDOW_WIDTH));
  //assert(currHeight==glutGet(GLUT_WINDOW_HEIGHT));

  // read the SKP scene from the buffer
  unsigned char *pixelData=(unsigned char*)malloc(currWidth*currHeight);
  glReadBuffer(GL_FRONT);
  glReadPixels(0,0,currWidth,currHeight,GL_RED,GL_UNSIGNED_BYTE,pixelData);

  // output the SKP rendered scene information, DEBUGGING ONLY
  /*char* outFileName=(char*)malloc(50);
    strcpy(outFileName,"D:/");
    strcat(outFileName,ent->d_name);
    FILE * out = fopen(outFileName,"w");
    for (int i=0;i<currWidth*currHeight;i++)
    {
    fprintf(out,"%d\n",pixelData[i]);
    }
    fclose(out);*/

  // convert 1D array pixelData to 2D, rows going from top of image to bottom, the same as the clutter mask openCV Mat m
  // glReadPixels returns pixels starting from lower left corner of rendered image, going horizontally then up, so we need to
  // reverse row ordering to go from top to bottom
  int pixelDataIdx=0;
  uchar** pixelData2D=new uchar*[currHeight];
  for (int i=0; i<currHeight; i++)
    pixelData2D[i]=new uchar[currWidth];
  for (int i=currHeight-1; i>=0; i--) { // fill in 2D array from bottom to top
    for (int j=0; j<currWidth; j++) {
      pixelData2D[i][j]=pixelData[pixelDataIdx];
      pixelDataIdx++;
    }
  }

  // compare the SKP scene with the clutter mask (global variable m) **************scoring needs to be enhanced
  double SSD=0;
  for (int i = 0; i < m.rows; i++) {
    const uchar* mi = m.ptr(i);
    for (int j = 0; j < m.cols; j++) {
      //fprintf(out,"%d\n",mi[j]);
      SSD+=std::abs((double)((mi[j])-pixelData2D[i][j]));
    }
  }

  cout.precision(10);
  cout<<"....done, score is "<<SSD<<'\n';
}

void reshapeCB(int w, int h) {
  cout<<"reshape: "<<w<<"*"<<h<<" ";
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

//////////////////////////////////////////////////////HELPER FUNCTIONS
void initSceneDumpDir() {
  /* open directory stream */
  dir = opendir(SCENE_DUMP_DIR);
  if (dir==NULL) {
    closedir (dir);
    cout<<"FATAL ERROR IN INITSCENEDUMPDIR, DIR IS NULL"<<endl;
  }
}

void initCameraParamsAndClutterMask() {
  cout<<"initCameraParamsAndClutterMask"<<endl;
  // init camera params for the UIUC image we want to match
  FILE* cameraParamsFile=fopen("cameraParams.txt","r");

  fscanf(cameraParamsFile,"%f",&aspect_ratio);
  fscanf(cameraParamsFile,"%f",&fov_vertical);

  cameraParams=new float[9];
  int k=0;
  for (k=0; k<9; k++) {
    fscanf(cameraParamsFile,"%f",&(cameraParams[k]));
  }
  fclose(cameraParamsFile);


  // init the clutter mask of the UIUC image
  //m=imread("D:/clutter_mask.png",-1);
  m=imread("clutter_mask.png",-1);
  CV_Assert(m.type() == CV_8UC1);
  if (m.data==NULL)
    cout<<"Error reading in clutter mask"<<endl;

  // DEBUGGING
  //cout<<m.rows<<" "<<m.cols<<" "<<m.channels()<<" ";
  /*FILE* out=fopen("D:/e.txt","w");
    for(int i = 0; i < m.rows; i++) {
    const uchar* mi = m.ptr(i);
    for(int j = 0; j < m.cols; j++){
    fprintf(out,"%d\n",mi[j]);
    }
    }
    fclose(out);*/
}

// finds the smallest and largest x, y and z values of the current scene's vertices
void findSceneBounds(float* minBound, float* maxBound) {
  for (int i=0; i<3; i++) {
    minBound[i]=FLT_MAX;
    maxBound[i]=-FLT_MAX;
  }
  for (int i=0; i<numComps; i++) {
    for (int j=0; j<numFacesForComp[i]; j++) {
      for (int k=0; k<numVerticesForFace[i][j]; k++) {
        if (vertices[i][j][k]<minBound[k%3])
          minBound[k%3]=vertices[i][j][k];
        if (vertices[i][j][k]>maxBound[k%3])
          maxBound[k%3]=vertices[i][j][k];
      }
    }
  }
  //cout<<minBound[0]<<" "<<minBound[1]<<" "<<minBound[2]<<" "<<maxBound[0]<<" "<<maxBound[1]<<" "<<maxBound[2]<<endl;
}
