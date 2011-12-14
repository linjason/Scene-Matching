% builds A matrix from text file containing SU scene information (from the
% Theo script)
% Change the code on lines 13-16 depending on which scene size threshold
% you want (or if thresholded in SU Theo.rb already, so not necessary here)
% Change the mat file output directory on line 120 if necessary

d_results = dir('./results')
for fileIndex = 1:(length(d_results)-2)
    A=cell(0);
    d_results(fileIndex+2).name
    file = fopen(strcat('./results/', d_results(fileIndex+2).name), 'r');
    bound = fscanf(file, '%f', [1,6]); % scene bounds in format [xmin xmax ymin ymax zmin zmax]
    cameraParams=fscanf(file, '%f', [1,13]);%%%%%%%%%%%%%%%%%%%%%%% remove if not using camera parameters
    
    % normal scene sizes
    %if ~(bound(2)-bound(1)<800 && bound(2)-bound(1)>130 && bound(4)-bound(3)<800 && bound(4)-bound(3)>130 && bound(6)-bound(5)<200 && bound(6)-bound(5)>12)
    % small scene sizes
    if 0%~(bound(2)-bound(1)<800 && bound(2)-bound(1)>85 && bound(4)-bound(3)<800 && bound(4)-bound(3)>85 && bound(6)-bound(5)<200 && bound(6)-bound(5)>12)
       continue;
    end
    index = 1;
    i = 0;
    k = 0;
    compIndex = 0;
    %clf;
    while(~strcmp(fgetl(file),'New Instance')) % look for 'New Instance', which indicates a new component instance
        if (feof(file))
            break;
        end
    end
    if (feof(file))
        clear A
        continue; % no component instances in text file, continue and do not create mat file for this scene
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
    A{compIndex}{1} = bound; % A{end}{1} is scene bounds
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
    A{compIndex}{2} = walls; % A{end}{2} is wall locations
    A{compIndex}{3} = cameraParams;%%%%%%%%%%%%%%%% remove if not using camera parameters
    
    % now go back to beginning of file and get component tags
    frewind(file);
    bound = fscanf(file, '%f', [1,6]);
    line = fgetl(file);
    compIndex2=0;
    toDel=0;
    while(isempty(findstr('New Instanc', line)))
        if (findstr('compName', line))
            line = fgetl(file);
            continue;
        elseif (~isempty(findstr('grouName', line)) || ~isempty(findstr('defiName', line)))
            compIndex2 = compIndex2 + 1;
            A{compIndex2}{size(A{compIndex2},2)+1}=line(11:end);
            if isequal(line(11:end),'Susan'), display('delete'), toDel=compIndex2; end % remove person called 'Susan'
        end
        line = fgetl(file);
    end
    if compIndex2+1~=size(A,2)
        disp('error!!!!!!!~~~~!') % error if the number of components does not equal the number of name tags
    end
    if toDel~=0, A(toDel)=[]; end % delete 'Susan'
    fclose('all');
    [path, name, ext] = fileparts(d_results(fileIndex+2).name);
    save(strcat('./results_mat/', strcat(name, '.mat')), 'A');
    clear A;
end
