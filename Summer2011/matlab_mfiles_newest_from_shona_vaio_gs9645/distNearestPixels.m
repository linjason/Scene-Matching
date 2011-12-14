% returns the distance between the two closest pixels of two objects
% input: component indices from the C array, and the C array

function minPixDist=distNearestPixels(oneObj, otherObj, C)
if length(oneObj)>=2 && length(otherObj)==1
    otherObj=repmat(otherObj,size(oneObj));
elseif length(otherObj)>=2 && length(oneObj)==1
    oneObj=repmat(oneObj,size(otherObj));
end
    
    minPixDist=zeros(length(oneObj),1);
    for ii=1:length(oneObj)
potDistances=zeros(0);

oneObjMinX=C{oneObj(ii)}{3}(1);
oneObjMaxX=C{oneObj(ii)}{4}(1);
oneObjMinY=C{oneObj(ii)}{3}(2);
oneObjMaxY=C{oneObj(ii)}{4}(2);
otherObjMinX=C{otherObj(ii)}{3}(1);
otherObjMaxX=C{otherObj(ii)}{4}(1);
otherObjMinY=C{otherObj(ii)}{3}(2);
otherObjMaxY=C{otherObj(ii)}{4}(2);

oneObjCorners=[oneObjMinX oneObjMinY;oneObjMinX oneObjMaxY;oneObjMaxX oneObjMinY;oneObjMaxX oneObjMaxY];
otherObjCorners=[otherObjMinX otherObjMinY;otherObjMinX otherObjMaxY;otherObjMaxX otherObjMinY;otherObjMaxX otherObjMaxY];

oneObj;
otherObj;
for kk=1:4
    for ll=1:4
        potDistances(end+1)=((oneObjCorners(ll,1)-otherObjCorners(kk,1))^2+(oneObjCorners(ll,2)-otherObjCorners(kk,2))^2)^.5;
    end
end

if otherObjMinX>oneObjMaxX&&otherObjMaxY>oneObjMinY&&otherObjMinY<oneObjMaxY
    potDistances(end+1)=otherObjMinX-oneObjMaxX;
end
if otherObjMaxX<oneObjMinX&&otherObjMaxY>oneObjMinY&&otherObjMinY<oneObjMaxY
    potDistances(end+1)=oneObjMinX-otherObjMaxX;
end
if otherObjMinY>oneObjMaxY&&otherObjMaxX>oneObjMinX&&otherObjMinX<oneObjMaxX
    potDistances(end+1)=otherObjMinY-oneObjMaxY;
end
if otherObjMaxY<oneObjMinY&&otherObjMaxX>oneObjMinX&&otherObjMinX<oneObjMaxX
    potDistances(end+1)=oneObjMinY-otherObjMaxY;
end
minPixDist(ii)=min(potDistances);
end
end

