allKeys=keys(mapOfCompToVarshaCategory);
l=0;
bb=zeros(0,2);
numCouches=0;
closestSides=zeros(0);
distsToBedsTwoNearestEdges=cell(0);
distsToBedsTwoNearestEdges{1,1}=zeros(0,4);
distsToBedsTwoNearestEdges{2,1}=zeros(0,4);


for i=1:length(allKeys)
    if isequal('help',allKeys{i}), continue, end
    value=mapOfCompToVarshaCategory(allKeys{i});
    ptr=pointerFromAtoC(allKeys{i});
    if length(find(abs(cell2mat(value(:,2)))==1))>=1
        bedArray=cell2mat(ptr(find(abs(cell2mat(value(:,2)))==1),1));
        for j=1:length(bedArray)
            if C{bedArray(j)}{4}(2)-C{bedArray(j)}{3}(2)>C{bedArray(j)}{4}(1)-C{bedArray(j)}{3}(1)
                xShorter=1;
            else
                xShorter=0;
            end
            if ~isempty(find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}))) && min(C{bedArray(j)}{6})<20
                closestSide= find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}));
                if numel(closestSide)>=2
                    continue
                end
            else
                continue
            end
            if (xShorter&&(closestSide==3||closestSide==4)) ||  (~xShorter&&(closestSide==1||closestSide==2))
                closestSides(end+1)=1;
                if (~xShorter&&(closestSide==2||closestSide==1))||(xShorter&&(closestSide==3||closestSide==4))
                    for k=1:size(value,1)
                        if isnan(value{k,2}) || ptr{k,1}==bedArray(j), continue, end
                        otherObjInx=ptr{k,1};
                        bedIdx=bedArray(j);
                        if distNearestPixels(bedIdx,otherObjInx,C)>40,continue,end%20, continue, end
                        otherObjMid=(C{otherObjInx}{4}+C{otherObjInx}{3})/2;
                        distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) otherObjMid(1)- C{bedIdx}{4}(1) otherObjMid(2)- C{bedIdx}{3}(2) otherObjMid(2)- C{bedIdx}{4}(2)];
                        %distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) -(otherObjMid(2)- C{bedIdx}{4}(2)) otherObjMid(2)- C{bedIdx}{3}(2) -(otherObjMid(1)- C{bedIdx}{4}(1))];
                        l=l+1;
                        absDists=abs(distsToEdges);
                        for z=[1 3]
                            minIdx=find(absDists(z:z+1)==min(absDists(z:z+1)),1);
                            distsToBedsTwoNearestEdges{1,1}(l,z)=minIdx+z-1;
                            distsToBedsTwoNearestEdges{1,1}(l,z+1)=distsToEdges(minIdx+z-1);
                        end
                        distsToBedsTwoNearestEdges{1,1}(l,5)=otherObjInx;
                        distsToBedsTwoNearestEdges{1,1}(l,6)=value{k,2};
                        distsToBedsTwoNearestEdges{1,1}(l,7)=closestSide;
                    end
                end
            else
                allKeys{i};
                closestSides(end+1)=2;
            end
        end
    end
end




l=0;
bb=zeros(0,2);
numCouches=0;
closestSides=zeros(0);
for i=1:length(allKeys)
    if isequal('help',allKeys{i}), continue, end
    value=mapOfCompToVarshaCategory(allKeys{i});
    ptr=pointerFromAtoC(allKeys{i});
    if length(find(abs(cell2mat(value(:,2)))==2))>=1
        bedArray=cell2mat(ptr(find(abs(cell2mat(value(:,2)))==2),1));
        for j=1:length(bedArray)
                closestSide=couchDirs(bedArray(j));%couchDirection(bedArray(j),compsHeightViewsAllBDLR23HT);%
                if closestSide~=0
                    numCouches=numCouches+1;
                    for k=1:size(value,1)
                         if isnan(value{k,2}) || ptr{k,1}==bedArray(j), continue, end
                        otherObjInx=ptr{k,1};
                        bedIdx=bedArray(j);
                        if distNearestPixels(bedIdx,otherObjInx,C)>80, continue, end
                        otherObjMid=(C{otherObjInx}{4}+C{otherObjInx}{3})/2;
                        distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) otherObjMid(1)- C{bedIdx}{4}(1) otherObjMid(2)- C{bedIdx}{3}(2) otherObjMid(2)- C{bedIdx}{4}(2)];
                        %distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) -(otherObjMid(2)- C{bedIdx}{4}(2)) otherObjMid(2)- C{bedIdx}{3}(2) -(otherObjMid(1)- C{bedIdx}{4}(1))];
                        l=l+1;
                        absDists=abs(distsToEdges);
                        for z=[1 3]
                            minIdx=find(absDists(z:z+1)==min(absDists(z:z+1)),1);
                            distsToBedsTwoNearestEdges{2,1}(l,z)=minIdx+z-1;
                            distsToBedsTwoNearestEdges{2,1}(l,z+1)=distsToEdges(minIdx+z-1);
                        end
                        distsToBedsTwoNearestEdges{2,1}(l,5)=otherObjInx;
                        distsToBedsTwoNearestEdges{2,1}(l,6)=value{k,2};
                        distsToBedsTwoNearestEdges{2,1}(l,7)=closestSide;
                   end
                end
       end
    end
end

% l=0;
% coordsForOtherObjs=zeros(0,2);
% for i=1:size(distsToBedsTwoNearestEdges,1)
%     xCoord=Inf;
%     yCoord=Inf;
%     for j=[1 3]
%         if distsToBedsTwoNearestEdges(i,7)==3
%             if distsToBedsTwoNearestEdges(i,j)==1
%                 xCoord=distsToBedsTwoNearestEdges(i,j+1)+110;
%             elseif distsToBedsTwoNearestEdges(i,j)==2
%                 xCoord=distsToBedsTwoNearestEdges(i,j+1)+200;
%             elseif distsToBedsTwoNearestEdges(i,j)==3
%                 yCoord=distsToBedsTwoNearestEdges(i,j+1)+110;
%             elseif distsToBedsTwoNearestEdges(i,j)==4
%                 yCoord=distsToBedsTwoNearestEdges(i,j+1)+200;
%             end
%         elseif distsToBedsTwoNearestEdges(i,7)==4
%             if distsToBedsTwoNearestEdges(i,j)==1
%                 xCoord=-distsToBedsTwoNearestEdges(i,j+1)+200;
%             elseif distsToBedsTwoNearestEdges(i,j)==2
%                 xCoord=-distsToBedsTwoNearestEdges(i,j+1)+110;
%             elseif distsToBedsTwoNearestEdges(i,j)==3
%                 yCoord=-distsToBedsTwoNearestEdges(i,j+1)+200;
%             elseif distsToBedsTwoNearestEdges(i,j)==4
%                 yCoord=-distsToBedsTwoNearestEdges(i,j+1)+110;
%             end
%         elseif distsToBedsTwoNearestEdges(i,7)==2
%             if distsToBedsTwoNearestEdges(i,j)==1
%                 yCoord=-distsToBedsTwoNearestEdges(i,j+1)+200;
%             elseif distsToBedsTwoNearestEdges(i,j)==2
%                 yCoord=-distsToBedsTwoNearestEdges(i,j+1)+110;
%             elseif distsToBedsTwoNearestEdges(i,j)==3
%                 xCoord=distsToBedsTwoNearestEdges(i,j+1)+110;
%             elseif distsToBedsTwoNearestEdges(i,j)==4
%                 xCoord=distsToBedsTwoNearestEdges(i,j+1)+200;
%             end
%         elseif distsToBedsTwoNearestEdges(i,7)==1
%             if distsToBedsTwoNearestEdges(i,j)==1
%                 yCoord=distsToBedsTwoNearestEdges(i,j+1)+110;
%             elseif distsToBedsTwoNearestEdges(i,j)==2
%                 yCoord=distsToBedsTwoNearestEdges(i,j+1)+200;
%             elseif distsToBedsTwoNearestEdges(i,j)==3
%                 xCoord=-distsToBedsTwoNearestEdges(i,j+1)+200;
%             elseif distsToBedsTwoNearestEdges(i,j)==4
%                 xCoord=-distsToBedsTwoNearestEdges(i,j+1)+110;
%             end
%
%         end
%     end
%     if ismember(Inf,[xCoord yCoord])
%         continue
%     else
%         l=l+1;
%         coordsForOtherObjs(l,1)=xCoord;
%         coordsForOtherObjs(l,2)=yCoord;
%         coordsForOtherObjs(l,3)=distsToBedsTwoNearestEdges(i,6);
%         coordsForOtherObjs(l,4)=distsToBedsTwoNearestEdges(i,5);
%     end
%
% end
% outputImg=zeros(150,150);
% outputImgs=cell(18,0);
% for i=1:18, outputImgs{i}=zeros(150,150); end
% for i=1:size(coordsForOtherObjs,1)
%     if ceil(coordsForOtherObjs(i,1))>300 || ceil(coordsForOtherObjs(i,2))>300 ||ceil(coordsForOtherObjs(i,1))<1|| ceil(coordsForOtherObjs(i,2))<1, continue, end
%     outputImgs{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))=outputImgs{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))+1;
%     %outputImg(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))=abs(coordsForOtherObjs(i,3));
%     outputImg(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))=outputImg(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))+1;
% end


