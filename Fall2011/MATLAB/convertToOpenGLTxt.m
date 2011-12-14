f=fopen('D:/a.txt','w');
fprintf(f,'%4.5f\n',1.333);% aspect ratio
fprintf(f,'%4.5f\n',30);% FOV vertical
fprintf(f,'%4.5f\n',A{end}{end}(end-2:end));
fprintf(f,'%4.5f\n',A{end}{end}(3:5));
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