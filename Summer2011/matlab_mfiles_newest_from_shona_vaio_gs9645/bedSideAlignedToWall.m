% allKeys=keys(mapOfCompToVarshaCategory);
% existanceOfOtherObjects=cell(0);
%
% for compNumber=1:15
%     numOfOneBedScenes=0;
%     existanceOfOtherObjects{compNumber}=zeros(0,16);
%     for i=1:length(allKeys)
%         value=mapOfCompToVarshaCategory(allKeys{i});
%         if ~isequal('help',allKeys{i})
%             i;
%             length(find(abs(cell2mat(value(:,2)))==1));
%             %numberOfBedsInScenes(end+1)=length(find(abs(cell2mat(value(:,2)))==1));
%         else
%             continue
%         end
%         ptr=pointerFromAtoC(allKeys{i});
%         % only one bed in scene
%         if size(ptr,1)<=3
%             continue
%         end
%         if length(find(abs(cell2mat(value(:,2)))==compNumber))>=1
%             numOfOneBedScenes=numOfOneBedScenes+1;
%             for j=1:15
%                 if length(cell2mat(ptr(find(abs(cell2mat(value(:,2)))==j),1)))>=1
%                     otherObjs=cell2mat(ptr(find(abs(cell2mat(value(:,2)))==compNumber),1));
%                     for k=1:length(otherObjs)
%                         if length(find(distNearestPixels(cell2mat(ptr(find(abs(cell2mat(value(:,2)))==j),1)),otherObjs(k),C)<50))>=1
%                             existanceOfOtherObjects{compNumber}(numOfOneBedScenes,j)=1;
%                         end
%                     end
%                 else
%                     if j==8||j==9
%                         allKeys{i};
%                     end
%                 end
%             end
%         end
%     end
% end
% keyboard


%%% couch distributions
l=0;
bb=zeros(0,2);
numCouches=0;
closestSides=zeros(0);
distsToBedsTwoNearestEdges=zeros(0,4);
for i=1:length(allKeys)
    if isequal('help',allKeys{i}), continue, end
    value=mapOfCompToVarshaCategory(allKeys{i});
    ptr=pointerFromAtoC(allKeys{i});
    if length(find(abs(cell2mat(value(:,2)))==2))>=1
        bedArray=cell2mat(ptr(find(abs(cell2mat(value(:,2)))==2),1));
        for j=1:length(bedArray)
                closestSide=couchDirection(bedArray(j),compsHeightViewsAllBDLR23HT);%
                if closestSide~=0
                    numCouches=numCouches+1;
                    for k=1:size(value,1)
                        if value{k,2}==bedArray(j) || isnan(value{k,2}), continue, end
                        otherObjInx=ptr{k,1};
                        bedIdx=bedArray(j);
                        if distNearestPixels(bedIdx,otherObjInx,C)>80, continue, end
                        otherObjMid=(C{otherObjInx}{4}+C{otherObjInx}{3})/2;
                        distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) otherObjMid(1)- C{bedIdx}{4}(1) otherObjMid(2)- C{bedIdx}{3}(2) otherObjMid(2)- C{bedIdx}{4}(2)];
                        %distsToEdges= [otherObjMid(1)- C{bedIdx}{3}(1) -(otherObjMid(2)- C{bedIdx}{4}(2)) otherObjMid(2)- C{bedIdx}{3}(2) -(otherObjMid(1)- C{bedIdx}{4}(1))];
                        l=l+1;
                        absDists=abs(distsToEdges);
                        for z=[1 3]
                            minIdx=find(absDists==min(absDists),1);
                            distsToBedsTwoNearestEdges{2}(l,z)=minIdx;
                            distsToBedsTwoNearestEdges{2}(l,z+1)=distsToEdges(minIdx);
                            absDists(minIdx)=Inf;
                       end
                        distsToBedsTwoNearestEdges{2}(l,5)=otherObjInx;
                        distsToBedsTwoNearestEdges{2}(l,6)=value{k,2};
                        distsToBedsTwoNearestEdges{2}(l,7)=closestSide;
                   end
                end
       end
    end
end

l=0;
coordsForOtherObjs=zeros(0,2);
for i=1:size(distsToBedsTwoNearestEdges,1)
    xCoord=Inf;
    yCoord=Inf;
    for j=[1 3]
        if distsToBedsTwoNearestEdges(i,7)==3
            if distsToBedsTwoNearestEdges(i,j)==1
                xCoord=-distsToBedsTwoNearestEdges(i,j+1)+290;
            elseif distsToBedsTwoNearestEdges(i,j)==2
                xCoord=-distsToBedsTwoNearestEdges(i,j+1)+190;
            elseif distsToBedsTwoNearestEdges(i,j)==3
                yCoord=-distsToBedsTwoNearestEdges(i,j+1)+290;
            elseif distsToBedsTwoNearestEdges(i,j)==4
                yCoord=-distsToBedsTwoNearestEdges(i,j+1)+190;
            end
        elseif distsToBedsTwoNearestEdges(i,7)==4
            if distsToBedsTwoNearestEdges(i,j)==1
                xCoord=distsToBedsTwoNearestEdges(i,j+1)+190;
            elseif distsToBedsTwoNearestEdges(i,j)==2
                xCoord=distsToBedsTwoNearestEdges(i,j+1)+290;
            elseif distsToBedsTwoNearestEdges(i,j)==3
                yCoord=distsToBedsTwoNearestEdges(i,j+1)+190;
            elseif distsToBedsTwoNearestEdges(i,j)==4
                yCoord=distsToBedsTwoNearestEdges(i,j+1)+290;
            end
        elseif distsToBedsTwoNearestEdges(i,7)==2
            if distsToBedsTwoNearestEdges(i,j)==1
                yCoord=distsToBedsTwoNearestEdges(i,j+1)+190;
            elseif distsToBedsTwoNearestEdges(i,j)==2
                yCoord=distsToBedsTwoNearestEdges(i,j+1)+290;
            elseif distsToBedsTwoNearestEdges(i,j)==3
                xCoord=-distsToBedsTwoNearestEdges(i,j+1)+290;
            elseif distsToBedsTwoNearestEdges(i,j)==4
                xCoord=-distsToBedsTwoNearestEdges(i,j+1)+190;
            end
        elseif distsToBedsTwoNearestEdges(i,7)==1
            if distsToBedsTwoNearestEdges(i,j)==1
                yCoord=-distsToBedsTwoNearestEdges(i,j+1)+290;
            elseif distsToBedsTwoNearestEdges(i,j)==2
                yCoord=-distsToBedsTwoNearestEdges(i,j+1)+190;
            elseif distsToBedsTwoNearestEdges(i,j)==3
                xCoord=distsToBedsTwoNearestEdges(i,j+1)+190;
            elseif distsToBedsTwoNearestEdges(i,j)==4
                xCoord=distsToBedsTwoNearestEdges(i,j+1)+290;
            end
         end
    end
    if ismember(Inf,[xCoord yCoord])
        continue
    else
        l=l+1;
        coordsForOtherObjs(l,1)=xCoord;
        coordsForOtherObjs(l,2)=yCoord;
        coordsForOtherObjs(l,3)=distsToBedsTwoNearestEdges(i,6);
    end
end
outputImg=zeros(450/2,450/2);
outputImgs=cell(18,0);
for i=1:18, outputImgs{i}=zeros(450/2,450/2); end
for i=1:size(coordsForOtherObjs,1)
    outputImgs{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))=outputImgs{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))+1;
    %outputImg(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))=abs(coordsForOtherObjs(i,3));
    outputImg(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))=outputImg(ceil(coordsForOtherObjs(i,1)/2),ceil(coordsForOtherObjs(i,2)/2))+1;
end


