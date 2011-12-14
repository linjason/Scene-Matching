file = fopen('compsWithFaces.txt', 'r');
index = 3;
figure(index),


while (~feof(file))
    points = fscanf(file, '%f %f %f %f %f %f', [1 ,6])
    onePoint = points(1:3);
    otherPoint = points(4:6);
    
    fscanf(file, '%f', 1);
    matrix = fscanf(file, '%f %f %f %f %f %f', [1 ,16])
    fscanf(file, '%f', 1);
    
    matrix = reshape(matrix, 4, 4);
    onePointTrans = transformPoint3d(onePoint(1:1:end), matrix);
    otherPointTrans = transformPoint3d(otherPoint(1:1:end), matrix);
    
    figure(index), hold on
    %if (onePoint.
    drawEdge3d([onePointTrans otherPointTrans]);
end
fclose(file);
