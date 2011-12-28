% converts mat files' A matrix information into text file dump used
% by opengl cpp to render the SU scene
skpMatFilesDir='../../../../results_ALL/';
d_results = dir(skpMatFilesDir);
parfor fileIndex = 3:(length(d_results))
    B=load(fullfile(skpMatFilesDir,d_results(fileIndex).name));
    A=B.A;
    d_results(fileIndex).name
    [pathstr, name, ext] = fileparts(d_results(fileIndex).name);
    f=fopen(fullfile('../../../../results_ALL_forOpenGLCppRendering',strcat(name,'.txt')),'w');% dump file to be read into opengl cpp

    % no camera info required since camera info is provided by the uiuc
    % image (Camera info needed, however, when dumping photomatched scenes)
    %fprintf(f,'%4.5f\n',1.333);% aspect ratio
    %fprintf(f,'%4.5f\n',30);% FOV vertical
    %fprintf(f,'%4.5f\n',A{end}{end}(end-2:end));
    %fprintf(f,'%4.5f\n',A{end}{end}(3:5));
    fprintf(f,'%d\n',length(A)-1);
    for compsIndex=1:length(A)-1;
        fprintf(f,'%d\n',(length(A{compsIndex})-1)/2);
        for facesIndex = 1:2:size(A{compsIndex},2)-1
            pointsTrans = A{compsIndex}{facesIndex};
            polygons = abs(A{compsIndex}{facesIndex+1})';
            fprintf(f,'%d\n',size(pointsTrans,1)*3);
            for i=1:size(pointsTrans,1)
                fprintf(f,'%4.5f\n',pointsTrans(i,1));
                fprintf(f,'%4.5f\n',pointsTrans(i,2));
                fprintf(f,'%4.5f\n',pointsTrans(i,3));
            end
            fprintf(f,'C\n');
            fprintf(f,'%d\n',size(polygons,1)*3);
            for i=1:size(polygons,1)
                fprintf(f,'%d\n',polygons(i,:));
            end
            fprintf(f,'C\n');
        end
        fseek(f,-1,0);
        if compsIndex==length(A)-1
            fprintf(f,'Z');
        else
            fprintf(f,'Z\n');
        end
    end
    fclose(f);
    A=0;%clear A
end