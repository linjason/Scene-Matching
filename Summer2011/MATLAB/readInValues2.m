d_results = dir('./results_mat');
for fileIndex = 151%:(length(d_results)-2)
    clf
    fileIndex;
    %load(strcat('./results_mat/', d_results(fileIndex+2).name));
    d_results(fileIndex+2).name;
    colors = hsv(20);
    drawnow, figure(fileIndex+2)
    for compsIndex = 25%:size(A, 2) - 1
        colorIndex = mod(compsIndex-1, 20)+1;
        for facesIndex = 1:2:size(A{compsIndex},2)-1
            pointsTrans = A{compsIndex}{facesIndex};
            polygons = A{compsIndex}{facesIndex+1};
            patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', colors(colorIndex,:));
        end
        A{compsIndex}{size(A{compsIndex},2)};
    end
    boundsWallsIndex = size(A, 2);
    bounds = A{boundsWallsIndex}{1};
    for wallIndex = 1:2:size(A{boundsWallsIndex}{2},1) - 1
        onePoint = A{boundsWallsIndex}{2}(wallIndex, :);
        otherPoint = A{boundsWallsIndex}{2}(wallIndex + 1, :);
        drawEdge3d([onePoint otherPoint]);
    end
    M(fileIndex)=getFrame;
    %   imwrite(M, strcat('./results_movie/',d_results(fileIndex+2).name));
    %clf
    %clear A;
end
