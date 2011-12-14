allKeys=keys(mapOfCompToVarshaCategory);
l=0;
closestSides=zeros(0);
%distsToBedsTwoNearestEdges=zeros(0,4);
a=zeros(16,2);
for distComps=3:16
    for distCompsWallCenter=    1:2
        l=0;
        for i=1:length(allKeys)
            if isequal('help',allKeys{i}), continue, end
            value=mapOfCompToVarshaCategory(allKeys{i});
            ptr=pointerFromAtoC(allKeys{i});
            if length(find(abs(cell2mat(value(:,2)))==distComps))>=1
                bedArray=cell2mat(ptr(find(abs(cell2mat(value(:,2)))==distComps),1));
                for j=1:length(bedArray)
                    if distCompsWallCenter==1
                        % use for tables against wall
                        if ~isempty(find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}))) && min(C{bedArray(j)}{6})<20
                            closestSide=find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}));
                            if numel(closestSide)>=2
                                continue
                            end
                        else
                            continue
                        end
                        a(distComps,distCompsWallCenter)=a(distComps,distCompsWallCenter)+1;
                    else
                        %use for tables not against any wall
                        if ~isempty(find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}))) && min(C{bedArray(j)}{6})<20
                            continue
                        end
                        closestSide=1;
                        a(distComps,distCompsWallCenter)=a(distComps,distCompsWallCenter)+1;
                    end
                    if 1%(xShorter&&(closestSide==3||closestSide==4)) ||  (~xShorter&&(closestSide==1||closestSide==2))
                        closestSides(end+1)=1;
                        if 1%(~xShorter&&(closestSide==2||closestSide==1))||(xShorter&&(closestSide==3||closestSide==4))
                            %closestSide=couchDirection(bedArray(j),compsHeightViewsAllBDLR23HT);%
                            %if closestSide~=0
                             for k=1:size(value,1)
                                if isnan(value{k,2}) || ptr{k,1}==bedArray(j), continue, end
                                otherObjInx=ptr{k,1};
                                bedIdx=bedArray(j);
                                if distNearestPixels(bedIdx,otherObjInx,C)>80,continue,end%20, continue, end
                                otherObjMid=(C{otherObjInx}{4}+C{otherObjInx}{3})/2;
                                distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) otherObjMid(1)- C{bedIdx}{4}(1) otherObjMid(2)- C{bedIdx}{3}(2) otherObjMid(2)- C{bedIdx}{4}(2)];
                                %distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) -(otherObjMid(2)- C{bedIdx}{4}(2)) otherObjMid(2)- C{bedIdx}{3}(2) -(otherObjMid(1)- C{bedIdx}{4}(1))];
                                l=l+1;
                                absDists=abs(distsToEdges);
                                for z=[1 3]
                                    minIdx=find(absDists(z:z+1)==min(absDists(z:z+1)),1);
                                    distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(l,z)=minIdx+z-1;
                                    distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(l,z+1)=distsToEdges(minIdx+z-1);
                                end
                                distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(l,5)=otherObjInx;
                                distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(l,6)=value{k,2};
                                distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(l,7)=closestSide;
                            end
                        end
                    else
                        allKeys{i};
                        closestSides(end+1)=2;
                    end
                end
            end
        end
    end
end

l=0;
coordsForOtherObjs=zeros(0,2);
for i=1:size(distsToBedsTwoNearestEdges{distComps,distCompsWallCenter},1)
    xCoord=Inf;
    yCoord=Inf;
    for j=[1 3]
        if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==3
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            end
        elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==4
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            end
        elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==2
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            end
        elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==1
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+130;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+155;
            end
        end
    end
    if ismember(Inf,[xCoord yCoord])
        continue
    else
        l=l+1;
        coordsForOtherObjs(l,1)=xCoord;
        coordsForOtherObjs(l,2)=yCoord;
        coordsForOtherObjs(l,3)=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,6);
    end
 end
outputImg=zeros(170,170);
outputImgs=cell(18,0);
for i=1:18, outputImgs{i}=zeros(170,170); end
for i=1:size(coordsForOtherObjs,1)
    if ceil(coordsForOtherObjs(i,1))>340 || ceil(coordsForOtherObjs(i,2))>340 ||ceil(coordsForOtherObjs(i,1))<1|| ceil(coordsForOtherObjs(i,2))<1, continue, end
    outputImgs{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))=outputImgs{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))+1;
    %outputImg(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))=abs(coordsForOtherObjs(i,3));
    %outputImg(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))=outputImg(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))+1;
end


