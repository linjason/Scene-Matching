function score=sizeScores(oneC, otherC, C)

thisObjSize=C{oneC}{4}-C{oneC}{3};
thisObjSizeSortXY=sort(thisObjSize(1:2));

tempObjSize=C{otherC}{4}-C{otherC}{3};
tempObjSizeSortXY=sort(tempObjSize(1:2));

score=(1-abs((tempObjSizeSortXY(1)-thisObjSizeSortXY(1))/max(tempObjSizeSortXY(1),thisObjSizeSortXY(1))))...
    *(1-abs((tempObjSizeSortXY(2)-thisObjSizeSortXY(2))/max(tempObjSizeSortXY(2),thisObjSizeSortXY(2))));