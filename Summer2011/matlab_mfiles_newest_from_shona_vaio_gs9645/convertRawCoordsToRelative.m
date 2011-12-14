function coordsForOtherObjs=convertRawCoordsToRelative(distsToBedsTwoNearestEdges,distComps,distCompsWallCenter,thisRefBedClosSd, xMin,xMax,yMin,yMax,C)
% 1 for along wall and 2 for center
l=0;
% minPoint=C{thisBedIdxInC}{3};
% maxPoint=C{thisBedIdxInC}{4};
% yMin=minPoint(2)+yOffset;yMax=maxPoint(2)+yOffset;xMin=minPoint(1)+xOffset;xMax=maxPoint(1)+xOffset;
for i=1:size(distsToBedsTwoNearestEdges{distComps,distCompsWallCenter},1)
    xCoord=Inf;
    yCoord=Inf;
    for j=[1 3]
        if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==thisRefBedClosSd
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMin;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMax;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMin;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMax;
            end
        elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==4&&thisRefBedClosSd==3||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==3&&thisRefBedClosSd==4 ...
                ||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==1&&thisRefBedClosSd==2||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==2&&thisRefBedClosSd==1
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMax;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMin;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMax;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMin;
            end
        elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==2&&thisRefBedClosSd==3||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==1&&thisRefBedClosSd==4 ...
                ||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==4&&thisRefBedClosSd==2||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==3&&thisRefBedClosSd==1
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMax;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                yCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMin;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMin;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                xCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMax;
            end
        elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==1&&thisRefBedClosSd==3||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==2&&thisRefBedClosSd==4 ...
                ||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==3&&thisRefBedClosSd==2||distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,7)==4&&thisRefBedClosSd==1
            if distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==1
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMin;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==2
                yCoord=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+yMax;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==3
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMax;
            elseif distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j)==4
                xCoord=-distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,j+1)+xMin;
            end
        end
    end
    if xCoord==Inf || yCoord==Inf
        continue
    else
        l=l+1;
        coordsForOtherObjs(l,1)=xCoord;
        coordsForOtherObjs(l,2)=yCoord;
        coordsForOtherObjs(l,3)=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,6);
        coordsForOtherObjs(l,4)=distsToBedsTwoNearestEdges{distComps,distCompsWallCenter}(i,5);
    end
end