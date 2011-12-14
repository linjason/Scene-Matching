% returns the direction the couch is facing, based on height maps (couches are symmetric on one axis, and the side with lower
% height is the direction it is facing)
% inputs: i is the component number in the C array
% compsHeightViewsAllBDLR23HT is an array of all the height maps

function couchDir=couchDirection(i, compsHeightViewsAllBDLR23HT)
couchHeightMap=compsHeightViewsAllBDLR23HT{i};
couchHeightMap1=couchHeightMap(1:round(end/2),:);
couchHeightMap2=couchHeightMap(round(end/2)+1:end,:);
couchHeightMap3=couchHeightMap(:,1:round(end/2));
couchHeightMap4=couchHeightMap(:,round(end/2)+1:end);
couchDir=0;
if abs(sum(sum(couchHeightMap1))-sum(sum(couchHeightMap2)))>0.14*(sum(sum(couchHeightMap1))+sum(sum(couchHeightMap2)))/2
    if sum(sum(couchHeightMap1))>sum(sum(couchHeightMap2))
        couchDir=1;
    else
        couchDir=2;
    end
elseif abs(sum(sum(couchHeightMap3))-sum(sum(couchHeightMap4)))>0.14*(sum(sum(couchHeightMap3))+sum(sum(couchHeightMap4)))/2
    if sum(sum(couchHeightMap3))>sum(sum(couchHeightMap4))
        couchDir=3;
    else
        couchDir=4;
    end
end