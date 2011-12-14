% the cell array must already be initialized
%function readInValues(compNum, A)
colors = hsv(20);
drawnow, figure(11)
for compsIndex = 33%compNum%1:size(A, 2) - 1
    colorIndex = mod(compsIndex-1, 20)+1;
    for facesIndex = 1:2:size(A{compsIndex},2)-1
        pointsTrans = A{compsIndex}{facesIndex};
        polygons = A{compsIndex}{facesIndex+1};
        patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', colors(colorIndex,:));
    end
end

boundsWallsIndex = size(A, 2);
bounds = A{boundsWallsIndex}{1};

for wallIndex = 1:2:size(A{boundsWallsIndex}{2},1) - 1
    onePoint = A{boundsWallsIndex}{2}(wallIndex, :);
    otherPoint = A{boundsWallsIndex}{2}(wallIndex + 1, :);
    drawEdge3d([onePoint otherPoint]);
end
