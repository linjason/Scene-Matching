d_results = dir('./results')
for fileIndex = 1:(length(d_results)-2)
    fileIndex
    d_results(fileIndex+2).name
    file = fopen(strcat('./results/', d_results(fileIndex+2).name), 'r');
    clear A
    %file = fopen('C:\3DWarehouse\Matlab\2289a4495ec4f16087aebcc48d3aedc2.txt', 'r');
    index = 1;
    i = 0;
    k = 0;
    compIndex = 0;
    %clf;
    disp('start')
    while(~strcmp(fgetl(file),'New Instance'))
        if (feof(file))
            break;
        end
    end
    if (feof(file))
        clear A
        continue;
    else
        compIndex = compIndex + 1;
        i = mod(i, 20) + 1;
        k=0;
    end
    while (isempty(fscanf(file,'%[done]',1)))
        colors = hsv(20);
        if (~isempty(fscanf(file, '%[New Instance]\n', 1)))
            compIndex = compIndex + 1;
            i = mod(i, 20) + 1;
            k=0;
        end
        % use new 3D affine transform matrix for the following faces
        % or else use old matrix from previous iteration
        if(~isempty(fscanf(file, '%[Transformation]\n', 1)))
            matrix = fscanf(file, '%f %f %f %f %f %f', 16);
        end
        
        % variable number of 3D vertices (x1, y1, z1, x2, y2, z2 ... xn, yn, zn)
        points = fscanf(file, '%f %f %f %f %f %f', [3 ,inf]);
        fscanf(file, '%[a]', 1); % delimiter to signal end of points
        
        % variable number of polygons for the above vertices (all triangles)
        polygons = fscanf(file, '%f %f %f %f %f %f', [3 ,inf]);
        fscanf(file, '%[a]', 1); % delimiter to signal end of polygons
        if (isempty(polygons))
            continue;
        end
        points = points';
        matrix = reshape(matrix, 4, 4);
        pointsTrans = zeros(size(points,1), 3);
        for j = 1:size(points,1) % transform all the vertices using matrix
            pointsTrans(j, :) = transformPoint3d(points(j, :), matrix);
        end
        A{compIndex}{2*k+1} = pointsTrans;
        A{compIndex}{2*k+2} = polygons;
        k = k + 1;
        %   patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', colors(i,:));
        %if (fscanf(file, '%[done]', 4))
        %    disp('saw done!!');
        %end
    end
    %drawnow;
    compIndex = compIndex + 1;
    bound = fscanf(file, '%f', [1,6])
    A{compIndex}{1} = bound;
    walls = zeros(0, 3);
    wallIndex = 1;
    while (~feof(file))
        onePoint = fscanf(file, '%f %f %f %f %f %f', [1 ,3]);
        otherPoint = fscanf(file, '%f %f %f %f %f %f', [1 ,3]);
        if (isempty(onePoint))
            break;
        end
        walls(wallIndex, :) = onePoint;
        walls(wallIndex + 1, :) = otherPoint;
        wallIndex = wallIndex + 2;
        %figure(index), hold on
        %drawEdge3d([onePoint otherPoint]);
    end
    A{compIndex}{2} = walls;
    fclose('all');
    [path, name, ext] = fileparts(d_results(fileIndex+2).name);
    save(strcat('./results_mat/', strcat(name, '.mat')), 'A');
    clear A;
end
