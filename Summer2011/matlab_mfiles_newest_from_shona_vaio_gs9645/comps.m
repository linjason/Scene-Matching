file = fopen('ec1aaebc24478834ddb95d416f69f874.txt', 'r');
index = 2;
%figure(index), clf
while (~feof(file))
    minmax = fscanf(file, '%f %f %f %f %f %f', [1 ,6]);
    matrix = fscanf(file, '%f %f %f %f %f %f', [1 ,16]);
    
    matrix = reshape(matrix, 4, 4);
    minTrans = transformPoint3d(minmax(1:2:end), matrix);
    maxTrans = transformPoint3d(minmax(2:2:end), matrix);
    
    figure(index), hold on
    drawBox3d(reshape([minTrans;maxTrans], 1, 6));
end
fclose(file);