allKeys=keys(mapOfCompToVarshaCategory);
scenesToPredict=21:40%length(allKeys);%288%[229 245 288 251];
compColors = hsv(18);
closestSides=zeros(0);
parfor sceneNum=1:length(scenesToPredict)
    sceneValues=mapOfCompToVarshaCategory(allKeys{scenesToPredict(sceneNum)});
    ptr=pointerFromAtoC(allKeys{scenesToPredict(sceneNum)});
    if size(ptr,1)>20 || length(find(cell2mat(sceneValues(:,2))~=17&cell2mat(sceneValues(:,2))~=0))<=1, continue, end
    % check that at least one bed is aligned correctly
    
    %%%
    %   if length(bedArray)>=2, continue, end
    validBedArray=zeros(0,2);
    % find valid beds
    bedArray=cell2mat(ptr(abs(cell2mat(sceneValues(:,2)))==1,1));
    for j=1:length(bedArray)
        if C{bedArray(j)}{4}(2)-C{bedArray(j)}{3}(2)>C{bedArray(j)}{4}(1)-C{bedArray(j)}{3}(1)
            xShorter=1;
        else
            xShorter=0;
        end
        if ~isempty(find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}), 1)) && min(C{bedArray(j)}{6})<20
            closestSide= find(C{bedArray(j)}{6}==min(C{bedArray(j)}{6}));
            if numel(closestSide)>=2
                continue
            end
        else
            continue
        end
        %if (xShorter&&(closestSide==3||closestSide==4)) ||  (~xShorter&&(closestSide==1||closestSide==2))
        if (~xShorter&&(closestSide==2||closestSide==1))||(xShorter&&(closestSide==3||closestSide==4))
            validBedArray(end+1,1)=bedArray(j);% index in C
            validBedArray(end,2)=closestSide;
            validBedArray(end,3)=1;% a valid reference bed
            validBedArray(end,4)=1;
        end
    end
    % find valid couches
    bedArray=cell2mat(ptr(abs(cell2mat(sceneValues(:,2)))==2,1));
    for j=1:length(bedArray)
        closestSide=couchDirs(bedArray(j));%couchDirection(bedArray(j),compsHeightViewsAllBDLR23HT);%
        if closestSide~=0
            validBedArray(end+1,1)=bedArray(j);% index in C
            validBedArray(end,2)=closestSide;
            validBedArray(end,3)=2;% a valid reference couch
            validBedArray(end,4)=1;
        end
    end
    
    % other support objects
    for supportCompType=[3:9]
    bedArray=cell2mat(ptr(abs(cell2mat(sceneValues(:,2)))==supportCompType,1));
    for j=1:length(bedArray)
        distToWalls=C{bedArray(j)}{6};
        %closestSide=0;
if ~isempty(find(distToWalls==min(distToWalls), 1)) && min(distToWalls)<20 && numel(find(distToWalls==min(distToWalls)))==1
    closestSide=find(distToWalls==min(distToWalls));
     distCompsWallCenter=1;
else
     closestSide=1;
      distCompsWallCenter=2;
end
         validBedArray(end+1,1)=bedArray(j);% index in C
            validBedArray(end,2)=closestSide;
            validBedArray(end,3)=supportCompType;% a valid reference table
            validBedArray(end,4)=distCompsWallCenter;
    end
    end
    
    
    
    if length(validBedArray)<=1, continue, end
    %validScenes(end+1)=sceneNum;
    %continue
    closestSides(sceneNum)=closestSide;
    %continue
    AA=load(strcat('./results_mat/',allKeys{scenesToPredict(sceneNum)}));
    A=AA.A
    sceneImage=zeros(uint16(A{end}{1}(2)-A{end}{1}(1)+60),uint16(A{end}{1}(4)-A{end}{1}(3)+60));
    sceneImageCNum=zeros(uint16(A{end}{1}(2)-A{end}{1}(1)+60),uint16(A{end}{1}(4)-A{end}{1}(3)+60));
    xOffset=20-A{end}{1}(1);
    yOffset=20-A{end}{1}(3);
    %%% draw scene
    %figure
    for compIndex=1:length(A)-1
        points = cell2mat(A{compIndex}(1:2:end-1)');
        if (isempty(points)) || C{ptr{compIndex,1}}{3}(3)-C{ptr{compIndex,1}}{5}>12 
            continue;
        end
        compNumberInC=ptr{compIndex,1};
        %if ~ismember(compNumberInC,validBedArray(:,1)), continue, end
        minPoint = min(points);
        maxPoint = max(points);
        minPointR=round(minPoint);
        maxPointR=round(maxPoint);
        compSize=maxPoint-minPoint;
        if compSize(1)>90 || compSize(2)>90, continue, end
        %         fill([minPoint(1) ;maxPoint(1); maxPoint(1); minPoint(1)], ...
        %             [minPoint(2); minPoint(2) ; maxPoint(2) ; maxPoint(2)], compColors(abs(sceneValues{compIndex,2})+1,:))
        %         hold on
        if abs(sceneValues{compIndex,2})~=0
            imageColor=abs(sceneValues{compIndex,2});
        else
            imageColor=18;
        end
        sceneImage(int16([minPointR(1):maxPointR(1)]+xOffset) ,int16([minPointR(2):maxPointR(2)]+yOffset))=imageColor; % 1 for bed, 2 for couch, etc.
        sceneImageCNum(int16([minPointR(1):maxPointR(1)]+xOffset) ,int16([minPointR(2):maxPointR(2)]+yOffset))=compNumberInC;
        % fillPolygon3d(minPoint,maxPoint)
        % line([minPoint(1) minPoint(1)], [minPoint(2) maxPoint(2)], [0 0]);
        % line([minPoint(1) maxPoint(1)], [minPoint(2) minPoint(2)], [0 0]);
        % line([maxPoint(1) minPoint(1)], [maxPoint(2) maxPoint(2)], [0 0]);
        % line([maxPoint(1) maxPoint(1)], [maxPoint(2) minPoint(2)], [0 0]);
    end
    
    % draw walls
    boundsWallsIndex = size(A, 2);
    bounds = A{boundsWallsIndex}{1};
    for wallIndex = 1:2:size(A{boundsWallsIndex}{2},1) - 1
        onePoint = A{boundsWallsIndex}{2}(wallIndex, :);
        otherPoint = A{boundsWallsIndex}{2}(wallIndex + 1, :);
        %line([onePoint(1) otherPoint(1)], [onePoint(2) otherPoint(2)], [0 0], 'color', 'black');
        %line([onePoint(1) otherPoint(1)], [onePoint(2) otherPoint(2)], [0 0], 'color', 'white');
        %drawEdge3d([onePoint otherPoint]);
    end
    
    %%% build distribution map for each reference object
    
    
    sceneDistValues=cell(18,0); % number of each object category in each position
    sceneDistValuesCorrespIdx=cell(0); % corresponding index in C for each object
    
    % initialize cell arrays
    for i=1:18, sceneDistValues{i}=zeros(uint16(A{end}{1}(2)-A{end}{1}(1)+60),uint16(A{end}{1}(4)-A{end}{1}(3)+60)); end
    for i=1:18, sceneDistValuesCorrespIdx{i}=cell(uint16(A{end}{1}(2)-A{end}{1}(1)+60),uint16(A{end}{1}(4)-A{end}{1}(3)+60)); end
    l=0;
    coordsForOtherObjs=zeros(0,4);
    for q=1:size(validBedArray,1)
        
        distComps=validBedArray(q,3); % which category this reference object is (bed, couch, etc.)
        thisBedIdxInC=validBedArray(q,1); % index in C for this reference object
        thisBedIdx=find(abs(cell2mat(ptr(:,1)))==thisBedIdxInC);
        
        thisRefBedClosSd=validBedArray(q,2); % the closest side (direction) of this reference object
        distCompsWallCenter=validBedArray(q,4);
        
        minPoint=C{thisBedIdxInC}{3};
        maxPoint=C{thisBedIdxInC}{4};
        yMin=minPoint(2)+yOffset;yMax=maxPoint(2)+yOffset;xMin=minPoint(1)+xOffset;xMax=maxPoint(1)+xOffset;
        
        coordsForOtherObjs=[coordsForOtherObjs; convertRawCoordsToRelative(distsToBedsTwoNearestEdges,distComps,distCompsWallCenter,thisRefBedClosSd, xMin,xMax,yMin,yMax,C)];
        %keyboard
    end
    %%%for i=1:18, sceneDistValues{i}=zeros(A{end}{1}(4)-A{end}{1}(3)+40,A{end}{1}(2)-A{end}{1}(1)+40); end
    for i=1:size(coordsForOtherObjs,1)
        %if coordsForOtherObjs(i,3)~=8, continue, end
        if ceil(coordsForOtherObjs(i,1))>size(sceneImage,1) || ceil(coordsForOtherObjs(i,2))>size(sceneImage,2) ||ceil(coordsForOtherObjs(i,1))<1|| ceil(coordsForOtherObjs(i,2))<1, continue, end
        sceneImage(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))=sceneImage(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))+1;
        sceneDistValues{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))=...
            sceneDistValues{abs(coordsForOtherObjs(i,3))+1}(ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2)))+1;
        sceneDistValuesCorrespIdx{abs(coordsForOtherObjs(i,3))+1}{ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2))}(end+1)= coordsForOtherObjs(i,4);
        %%%  [sceneDistValuesCorrespIdx{abs(coordsForOtherObjs(i,3))+1}{ceil(coordsForOtherObjs(i,1)),ceil(coordsForOtherObjs(i,2))} coordsForOtherObjs(i,4)];
    end
    
    
    %%% list most out of place objects, scored by size and location
    outOfPlaceRankings=zeros(0,2);
    for j=1:size(sceneValues,1)
        if isnan(sceneValues{j,2}) || C{ptr{j,1}}{3}(3)-C{ptr{j,1}}{5}>12, continue, end
        thisObjIdxInC=ptr{j,1};
        thisObjCat=abs(sceneValues{j,2})+1;
        thisObjMid=round((C{thisObjIdxInC}{3}+C{thisObjIdxInC}{4})/2);
        areaToLook=sceneDistValues{thisObjCat}(uint16((thisObjMid(1)-10:thisObjMid(1)+10)+xOffset),uint16((thisObjMid(2)-10:thisObjMid(2)+10)+yOffset));
        scoreOfSizes=0;
        for k=uint16((thisObjMid(1)-10:thisObjMid(1)+10)+xOffset)
            for l=uint16((thisObjMid(2)-10:thisObjMid(2)+10)+yOffset)
                if ~isempty(sceneDistValuesCorrespIdx{thisObjCat}{k,l})
                    for m=1:length(sceneDistValuesCorrespIdx{thisObjCat}{k,l})
                        tempObjIdxInC=sceneDistValuesCorrespIdx{thisObjCat}{k,l}(m);
                        scoreOfSizes=scoreOfSizes+sizeScores(tempObjIdxInC,thisObjIdxInC,C);
                    end
                    %length(sceneDistValuesCorrespIdx{thisObjCat}{k,l});
                end
            end
        end
        outOfPlaceRankings(end+1,1)=sum(areaToLook(:)); % score based on num of objects
        outOfPlaceRankings(end,2)=j;
        outOfPlaceRankings(end,3)=scoreOfSizes; % score based on size score of all objects
    end
    outOfPlaceRankingsSorted=sortrows(outOfPlaceRankings);
    figure,imagesc(sceneImage)
    
    % display most out of place objects on figure
    for j=1:size(outOfPlaceRankings,1)
        thisObjMid=(C{ptr{outOfPlaceRankingsSorted(j,2),1}}{3}+C{ptr{outOfPlaceRankingsSorted(j,2),1}}{4})/2;
        text(thisObjMid(2)+yOffset,thisObjMid(1)+xOffset,sprintf('%d %d',sceneValues{outOfPlaceRankingsSorted(j,2),2},j))
    end
    
    %%% list objects most likely to be added
    newAdded=zeros(0,4);
    newAdded2=zeros(0,5);
    newAddedRankings=zeros(0.0);
    for j=1:2:size(coordsForOtherObjs,1)
        j;
        doContinue=0;
        %randObjToAdd=coordsForOtherObjs(ceil(rand*size(coordsForOtherObjs,1)),:);
        randObjToAdd=coordsForOtherObjs(j,:);
        if randObjToAdd(3)==0 || randObjToAdd(3)==17, continue, end
        randObjIdxInC=randObjToAdd(4);
        randObjMid=round([randObjToAdd(1) randObjToAdd(2)]);
        randObjCat=abs(randObjToAdd(3))+1;
        randObjSize=C{randObjIdxInC}{4}-C{randObjIdxInC}{3};
        % dont add objects one foot higher than ground
        if C{randObjIdxInC}{3}(3)-C{randObjIdxInC}{5}>12, continue, end
        % dont add on top of reference object
        if (randObjToAdd(2)>yMin && randObjToAdd(2)<yMax) && (randObjToAdd(1)>xMin && randObjToAdd(1)<xMax), continue, end
        
        % if a good match already there, then leave it
        areaToLook=uint16((randObjMid(1)-10:randObjMid(1)+10));uint16((randObjMid(2)-10:randObjMid(2)+10));
        
        presentComps=unique(sceneImageCNum(uint16((max(randObjMid(1)-6,1):min(randObjMid(1)+6,size(sceneImage,1)))),uint16((max(1,randObjMid(2)-6):min(randObjMid(2)+6,size(sceneImage,2))))));
        %         for k=1:length(presentComps)
        %             if presentComps(k)==0, continue, end
        %             if 1%value{C{presentComps(k)}{2},2}~=1000,
        %                 doContinue=1; continue, end% leave if anything except 0 there
        %
        %         end
        % if bad match, then suggest replacement
        %if doContinue==1, disp('44'), continue, end
        
        % how well this rand object fits here by the num of same category
        % here
        
        
        numOfSameCatObjNear=sum(sum(sceneDistValues{randObjCat}(uint16((max(randObjMid(1)-6,1):min(randObjMid(1)+6,size(sceneImage,1)))),...
            uint16((max(1,randObjMid(2)-6):min(randObjMid(2)+6,size(sceneImage,2)))))))   /sum(sum(sceneDistValues{randObjCat}(:)));
        
        
        % how well this rand object fits here by looking at the
        % distribution of this object around this place
        distAroundRandObjScore=0;
        xMin=randObjMid(1)-randObjSize(1)/2;
        xMax=randObjMid(1)+randObjSize(1)/2;
        yMin=randObjMid(2)-randObjSize(2)/2;
        yMax=randObjMid(2)+randObjSize(2)/2;
        distToWalls=readInWallsFromMat_fun(A,randObjIdxInC,C);
        coordsForOtherObjs2=getDistForThisRandObj(distsToBedsTwoNearestEdges,randObjIdxInC,abs(randObjToAdd(3)),distToWalls,xMin,xMax,yMin,yMax,C);
        if coordsForOtherObjs2==0, continue, end % no dist available
        distForThisRandObj=cell(18,1);
        for i=1:18, distForThisRandObj{i}=zeros(uint16(A{end}{1}(2)-A{end}{1}(1)+60),uint16(A{end}{1}(4)-A{end}{1}(3)+60)); end
        for k=1:size(coordsForOtherObjs2,1)
            if ceil(coordsForOtherObjs2(k,1))>size(sceneImage,1) || ceil(coordsForOtherObjs2(k,2))>size(sceneImage,2) ||ceil(coordsForOtherObjs2(k,1))<1|| ceil(coordsForOtherObjs2(k,2))<1, continue, end
            %disp('44444444444444444444444444444444444444444444444')
            distForThisRandObj{abs(coordsForOtherObjs2(k,3))+1}(ceil(coordsForOtherObjs2(k,1)),ceil(coordsForOtherObjs2(k,2)))=...
                distForThisRandObj{abs(coordsForOtherObjs2(k,3))+1}(ceil(coordsForOtherObjs2(k,1)),ceil(coordsForOtherObjs2(k,2)))+1;
        end
        
        allDistSum=sum(sum(cell2mat(distForThisRandObj(1:17))));
        if allDistSum<150, [allDistSum randObjCat], continue, end
        %for k=1:18 %%%%% May only compare 2~10
        for l=1:size(sceneValues,1)%getDistForThisRandObj{k}
            %%%%% for now, only care about which objects are present, worry
            %%%%% about which aren't later
            thisObjCat=sceneValues{l,2};
            if isnan(sceneValues{l,2}) || C{ptr{l,1}}{3}(3)-C{ptr{l,1}}{5}>12 || sceneValues{l,2}==17 || sceneValues{l,2}==0, continue, end
            thisObjMid=(C{ptr{l,1}}{3}+C{ptr{l,1}}{4})/2;
            
            areaToLook=distForThisRandObj{abs(thisObjCat)+1}(uint16((max(thisObjMid(1)-10+xOffset,0):min(thisObjMid(1)+10+xOffset,size(sceneImage,1)))),uint16((max(0,thisObjMid(2)-10+yOffset):min(size(sceneImage,2),thisObjMid(2)+10+yOffset))));
            if areaToLook==0, continue, end
            newAdded2(end+1,:)=[randObjIdxInC l thisObjCat sum(areaToLook(:)) allDistSum];
            distAroundRandObjScore=distAroundRandObjScore+sum(areaToLook(:))/allDistSum;  % score by # of sceneValue obj matches, not num of distribution points matvhed
        end
        %end
        
        newAdded(end+1,1:4)=randObjToAdd(:); % xmid, ymid, catNum, CIdx
        newAdded(end,5)=numOfSameCatObjNear;
        newAdded(end,6)=distAroundRandObjScore;
         newAdded(end,7)=numOfSameCatObjNear*distAroundRandObjScore;
         
        %keyboard
    end
    newAddedSorted=sortrows(newAdded,-7);
    % 
    for j=1:25%size(newAddedSorted,1)
        randObjToAdd=newAddedSorted(j,:);
        text(randObjToAdd(2),randObjToAdd(1),sprintf('a:%s %d',num2str(randObjToAdd(3)),j),'color','r');
    end
    print(strcat(allKeys{scenesToPredict(sceneNum)},'.png'),'-dpng');
    close
end