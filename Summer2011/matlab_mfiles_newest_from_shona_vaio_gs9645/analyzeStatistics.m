i = 0;
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
        i = i + 1;
        heightZ(i) = maxZ - minZ;
        X(i) = maxX-minX;
        Y(i) = maxY-minY;
    end
end
sortedCM=sortrows([X' Y' heightZ'],3)*2.54;
for i=1:10
    C{i}=zeros(0,3);
end
for i=1:size(sortedCM,1)
    C{round(sortedCM(i,3)/30)}=[C{round(sortedCM(i,3)/30)} ;sortedCM(i,:)]
end
%for i=1:10
%ax=subplot(2,5,i),scatter(C{i}(:,1),C{i}(:,2))
%axis(ax,'square')
%end
  a=zeros(10,10,10);
for i=1:size(sortedCM,1)
    a(round(sortedCM(i, 1)/36),round(sortedCM(i, 2)/36), round(sortedCM(i,3)/30))= a(round(sortedCM(i, 1)/36),round(sortedCM(i, 2)/36), round(sortedCM(i,3)/30))+1;
end
for i = 1:10
    a(:,:,i)=a(:,:,i)+a(:,:,i)';
    for j=1:10
        a(j,j,i)=a(j,j,i)/2;
    end
   subplot(2,5,i),imagesc(a(:,:,i)) 
end