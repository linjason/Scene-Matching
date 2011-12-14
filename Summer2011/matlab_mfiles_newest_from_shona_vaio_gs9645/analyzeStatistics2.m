i=0;
for compIndex = 1:size(B, 2)%828:size(B, 2)
    compIndex;
    
    if (~isempty(B{compIndex}{3}))
        %i = i + 1;
        minZ = B{compIndex}{3}(3);
        %minZs(i) = minZ-B{compIndex}{5};
        minY = B{compIndex}{3}(2);
        minX = B{compIndex}{3}(1);
    end
    if (~isempty(B{compIndex}{4}))
        maxZ = B{compIndex}{4}(3);
        %maxZs(i) = maxZ-B{compIndex}{5};
        maxY = B{compIndex}{4}(2);
        maxX = B{compIndex}{4}(1);
    end
    %area(i) = (maxX-minX)*(maxY-minY);
    if (minZ-B{compIndex}{5}<4 && maxZ - minZ<120 && maxX-minX<140 && maxY-minY<140 && maxZ - minZ>10 && maxX-minX>10 && maxY-minY>10)
        heightZ2 = maxZ - minZ;
        X2 = maxX-minX;
        Y2 = maxY-minY;
        heightZ2=heightZ2*2.54;
        X2=X2*2.54;
        Y2=Y2*2.54;
        if X2<225&&X2>190&&Y2>85&&Y2<165&&heightZ2<130&&heightZ2>75
            clear A;
            load(strcat('./results_mat/',B{compIndex}{1} ))
            readInValues(B{compIndex}{2},A)
            i=i+1
            B{compIndex}{1}
            pause
            clf
           clear A
        end
        if Y2<225&&Y2>190&&X2>85&&X2<165&&heightZ2<130&&heightZ2>75
              clear A;
            load(strcat('./results_mat/',B{compIndex}{1} ))
            readInValues(B{compIndex}{2},A)
              i=i+1
            B{compIndex}{1}
            pause
            clf
           clear A
        end
    end
end
