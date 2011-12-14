file = fopen('walls.txt', 'r');
index = 1;
figure(index),
while (~feof(file))
    onePoint = fscanf(file, '%f %f %f %f %f %f', [1 ,3])
    otherPoint = fscanf(file, '%f %f %f %f %f %f', [1 ,3])
 
    figure(index), hold on
    drawEdge3d([onePoint otherPoint]);
    %pause(1)
end
fclose(file);