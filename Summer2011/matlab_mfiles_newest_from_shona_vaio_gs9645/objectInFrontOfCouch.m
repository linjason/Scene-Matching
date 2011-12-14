couchTableDistances=zeros(0,3);
couchTableDistancesForScenesWithOnlyOneCouch=zeros(0);
k=0;

for j=1:length(couches)
%         if ~ismember(C{couches(j)}{1},couchesInSameSceneClustersNames)
%             isSceneWithOnlyOneCouch=1;
%             numScenesWithOnlyOneCouch=numScenesWithOnlyOneCouch+1;
%         else
%             isSceneWithOnlyOneCouch=0;
%         end
        foundTableForOneCouchScene=0;
    couchSceneName=C{couches(j)}{1};
    for i=max(1,couches(j)-220):min(couches(j)+220,length(C))
        value=mapOfCompToVarshaCategory(C{i}{1});
        if ~isequal(couchSceneName,C{i}{1}) || ~isempty(strfind(lower(C{i}{7}),'table')) || ismember(abs(value{C{i}{2},2}),[1:16])
            continue;
        end
        
        oneCenterX=(C{i}{4}(1)+C{i}{3}(1))/2;
        oneCenterY=(C{i}{4}(2)+C{i}{3}(2))/2;
        otherCenterX=(C{couches(j)}{4}(1)+C{couches(j)}{3}(1))/2;
        otherCenterY=(C{couches(j)}{4}(2)+C{couches(j)}{3}(2))/2;
        tableMinX=C{i}{3}(1);
        tableMinY=C{i}{3}(2);
        tableMaxX=C{i}{4}(1);
        tableMaxY=C{i}{4}(2);
        tableSizes=C{i}{4}-C{i}{3};
        couchMinX=C{couches(j)}{3}(1);
        couchMinY=C{couches(j)}{3}(2);
        couchMaxX=C{couches(j)}{4}(1);
        couchMaxY=C{couches(j)}{4}(2);
        if isequal(C{i}{1},C{couches(j)}{1}) && abs(oneCenterX-otherCenterX)+abs(oneCenterY-otherCenterY)<150
            if couchDir(j)==0||tableSizes(3)<13||tableSizes(3)>37||tableSizes(2)<12||tableSizes(1)<12||C{i}{3}(3)-C{i}{5}>10||tableSizes(2)>76||tableSizes(1)>76
                continue;
            elseif couchDir(j)==1 && tableMinX-couchMaxX>0 && oneCenterY>couchMinY-8 && oneCenterY<couchMaxY+8
                k=k+1;
                if isSceneWithOnlyOneCouch
                    foundTableForOneCouchScene=1;
                    couchTableDistancesForScenesWithOnlyOneCouch(end+1)=tableMinX-couchMaxX;
                end
                couchTableDistances(end+1,1)=tableMinX-couchMaxX;
                couchTableDistances(end,2)=i;
                couchTableDistances(end,3)=couches(j);
            elseif couchDir(j)==2 && couchMinX-tableMaxX>0 && oneCenterY>couchMinY-8 && oneCenterY<couchMaxY+8
                k=k+1;
                if isSceneWithOnlyOneCouch
                    foundTableForOneCouchScene=1;
                    couchTableDistancesForScenesWithOnlyOneCouch(end+1)=couchMinX-tableMaxX;
                end
                couchTableDistances(end+1,1)=couchMinX-tableMaxX;
                couchTableDistances(end,2)=i;
                couchTableDistances(end,3)=couches(j);
            elseif couchDir(j)==3 && tableMinY-couchMaxY>0 && oneCenterX>couchMinX-8 && oneCenterX<couchMaxX+8
                k=k+1;
                if isSceneWithOnlyOneCouch
                    foundTableForOneCouchScene=1;
                    couchTableDistancesForScenesWithOnlyOneCouch(end+1)=tableMinY-couchMaxY;
                end
                couchTableDistances(end+1,1)=tableMinY-couchMaxY;
                couchTableDistances(end,2)=i;
                couchTableDistances(end,3)=couches(j);
            elseif couchDir(j)==4 && couchMinY-tableMaxY>0 && oneCenterX>couchMinX-8 && oneCenterX<couchMaxX+8
                k=k+1;
                if isSceneWithOnlyOneCouch
                    foundTableForOneCouchScene=1;
                    couchTableDistancesForScenesWithOnlyOneCouch(end+1)=couchMinY-tableMaxY;
                end
                couchTableDistances(end+1,1)=couchMinY-tableMaxY;
                couchTableDistances(end,2)=i;
                couchTableDistances(end,3)=couches(j);
            end
        end
    end
%     if ~foundTableForOneCouchScene && isSceneWithOnlyOneCouch
%         C{couches(j)};
%     end
end