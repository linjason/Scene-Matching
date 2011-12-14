function allDists=readInWallsFromMat_fun(A, CIdx, C)
d_results = dir('./results_mat');
i = 0;

%for fileIndex = 1%:(length(d_results)-2)
    %clear A
    %d_results(fileIndex+2).name
    %load(wallsSceneName);
    points=[A{size(A, 2)}{2}(1:2:end, :),A{size(A, 2)}{2}(2:2:end, :)];
    walls = zeros(0, 6);
    for j = 1:size(points,1)
        if(points(j, 3)==points(j, 6))
            walls= [walls;points(j, :)];
        end
    end
    walls(:,3)=[];
    walls(:,5)=[];
    walls = unique(walls, 'rows');
    j=0;
    while(1)
        j=j+1;
        if j==size(walls,1)+1
            break;
        else
            reverse = [walls(j, 3:4) walls(j, 1:2)];
            for k=1:size(walls,1)
                if (walls(k, :)==reverse)
                    walls(k, :)=[];
                    break
                end
            end
        end
    end
    %for j=1:size(walls,1)
    %    line([walls(j,1) walls(j,3)],[walls(j,2) walls(j,4)])
    %end
    hor=zeros(0, 4);
    ver=zeros(0, 4);
    for j=1:size(walls,1)
        if(abs(walls(j,1)-walls(j,3))<0.001)
            ver = [ver;walls(j,:)] ;
        elseif (abs(walls(j,2)-walls(j,4))<0.001)
            hor = [hor;walls(j,:)];
        else
            j;
        end
    end
    % get min, max for each component
    %for compIndex = 25%1:size(A,2) - 1
        %compIndex;
%         points = cell2mat(A{compIndex}(1:2:end-1)');
%         if (isempty(points))
%             continue;
%         end
%         i = i + 1;
        
        minPoint = C{CIdx}{3};%min(points);
        maxPoint = C{CIdx}{4};%max(points);
        minX=minPoint(1);
        minY=minPoint(2);
        maxX=maxPoint(1);
        maxY=maxPoint(2);
        distToWallBelow = 888888;distToWallAbove=888888;distToWallLeft=888888;distToWallRight=888888;
        % take care of horizontal walls
        for j=1:size(hor,1)
            wallLeft = min(hor(j,1),hor(j,3));
            wallRight = max (hor(j,1),hor(j,3));
            if (hor(j, 2)<minY && (wallRight>=minX&&wallLeft<=maxX ))
                if minY-hor(j,2)<distToWallBelow
                    distToWallBelow = minY-hor(j,2);
                end
            elseif (hor(j, 2)>maxY&& (wallRight>=minX&&wallLeft<=maxX ))
                if hor(j,2)-maxY<distToWallAbove
                    distToWallAbove=      hor(j,2)-maxY;
                end
            end
        end
        % take care of vertical walls
        for j=1:size(ver,1)
            wallBelow = min(ver(j,2),ver(j,4));
            wallAbove = max (ver(j,2),ver(j,4));
            if (ver(j, 1)<minX && (wallAbove>=minY&&wallBelow<=maxY ))
                if minX-ver(j,1)<distToWallLeft
                    distToWallLeft=minX-ver(j,1);
                end
            elseif (ver(j, 1)>maxX&& (wallAbove>=minY&&wallBelow<=maxY ))
                if  ver(j,1)-maxX<distToWallRight
                    distToWallRight=ver(j,1)-maxX;
                end
            end
        end
%         if(~isequal(B{i}{1}, d_results(fileIndex+2).name) || ~isequal(B{i}{2},compIndex))
%             disp('aer888888888888888888888888888888888888888')
%         end
        if(distToWallAbove==888888)
            distToWallAbove=NaN;
        end
         if(distToWallBelow==888888)
            distToWallBelow=NaN;
         end
         if(distToWallLeft==888888)
            distToWallLeft=NaN;
         end
         if(distToWallRight==888888)
            distToWallRight=NaN;
        end
       allDists=[distToWallLeft distToWallRight distToWallBelow distToWallAbove];
  %end
