function coordsForOtherObjs=getDistForThisRandObj(distsToBedsTwoNearestEdges, CIdx, randObjCat,distToWalls,xMin,xMax,yMin,yMax,C)

% determine category and wall/center
closestSide=0;
if ~isempty(find(distToWalls==min(distToWalls))) && min(distToWalls)<20 && numel(find(distToWalls==min(distToWalls)))==1
    closestSide=find(distToWalls==min(distToWalls));
end

if closestSide==0
    distCompsWallCenter=2;
    closestSide=1;
else
    distCompsWallCenter=1;
end

thisRefBedClosSd=closestSide;
distComps=randObjCat;
thisBedIdxInC=CIdx;

%%% currently don't have dists for bed and couch in center, 
if (distComps==1 || distComps==2) && distCompsWallCenter==2
coordsForOtherObjs=0;
else
coordsForOtherObjs=convertRawCoordsToRelative(distsToBedsTwoNearestEdges,distComps,distCompsWallCenter,thisRefBedClosSd, xMin,xMax,yMin,yMax,C);
end
% fit raw distribution to specific object, location and orientation
