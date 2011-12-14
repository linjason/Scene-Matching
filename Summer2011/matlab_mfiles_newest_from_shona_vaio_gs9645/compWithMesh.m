file = fopen('compsWithMesh.txt', 'r');
index = 3;
figure(index),


while (~feof(file))
    points = fscanf(file, '%f %f %f %f %f %f', [3 ,inf]);
    %onePoint = points(1:3);
    %otherPoint = points(4:6);
    
    fscanf(file, '%[a]', 1);
    polygons = fscanf(file, '%f %f %f %f %f %f', [3 ,inf]);
    fscanf(file, '%[a]', 1);
    
   
    
    figure(index), hold on
    drawMesh(abs(points'), abs(polygons'))
    %if (onePoint.
    %drawEdge3d([onePointTrans otherPointTrans]);
end
fclose('all');
