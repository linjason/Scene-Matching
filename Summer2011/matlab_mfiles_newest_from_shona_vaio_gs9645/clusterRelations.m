clusters=cell(0);
for i=1:max(cluster_labels)
    i;
    nm=convertion(find(cluster_labels==i));
    for j=1:length(nm)
        clusters{i}{j}=nm(j);
    end
end
sizes=cell(0);

for i=1:length(clusters)
    sizes{i}=zeros(0,3);
    indicesForCluster=cell2mat(clusters{i});
    for k=1:length(indicesForCluster)
        ind=indicesForCluster(k);
        sizes{i}(end+1,:)=C{ind}{4}-C{ind}{3};
    end
end
% histogram of all the heights for each cluster
% figure
% for i=1:length(clusters)
%     subplot(7,10,i),hist(sizes{i}(:,3),50)
% end
% image of x,y sides for each cluster
% figure
% for i=1:length(clusters)
%     sideImage=zeros(20,20);
%     for j=1:size(sizes{i},1)
%         xSide=min(sizes{i}(j,1), sizes{i}(j,2));
%         ySide=max(sizes{i}(j,1), sizes{i}(j,2));
%         if ceil(xSide/6)>20 || ceil(ySide/6)>20
%             i
%             continue;
%         end
%         sideImage(ceil(xSide/6),ceil(ySide/6))= sideImage(ceil(xSide/6),ceil(ySide/6))+1;
%      end
%     subplot(7,10,i),imagesc(sideImage);
% end

% closest distances to walls
% figure
% for i=1:length(clusters)
%     dists=zeros(0);
%     for j=1:length(clusters{i})
%     dists(end+1)=min(C{clusters{i}{j}}{6});
%     end
%     subplot(7,10,i),hist(dists,100);
% end

% object distances between clusters
% k=0;
% distRelationsBetweenCluster=zeros(0,3);
% for i=1:length(convertion)
%     for j=1:length(convertion)
%         oneObject=convertion(i);
%         otherObject=convertion(j);
%         oneSize=C{oneObject}{4}-C{oneObject}{3};
%         otherSize=C{otherObject}{4}-C{otherObject}{3};
%         oneMidPoint=(C{oneObject}{4}+C{oneObject}{3})/2;
%         %oneMidPointY
%         otherMidPoint=(C{otherObject}{4}+C{otherObject}{3})/2;
%         %otherMidPointY
%         if isequal(C{oneObject}{1},C{otherObject}{1})
%             distRelationsBetweenCluster(end+1,1)=min(cluster_labels(i),cluster_labels(j));
%             distRelationsBetweenCluster(end,2)=max(cluster_labels(i),cluster_labels(j));
%             distRelationsBetweenCluster(end,3)=min([C{oneObject}{4}(1)-C{otherObject}{4}(1),    C{oneObject}{3}(1)-C{otherObject}{3}(1), C{oneObject}{3}(2)-C{otherObject}{3}(2), C{oneObject}{4}(2)-C{otherObject}{4}(2) ] );
%             %distRelationsBetweenCluster(end,3)=min((abs(oneMidPoint(1)-otherMidPoint(1))-abs(oneMidPoint(1)-oneSize(1))-abs(otherMidPoint(1)-otherSize(1))  ), abs(oneMidPoint(2)-otherMidPoint(2)) -abs(oneMidPoint(2)-oneSize(2))-abs(otherMidPoint(2)-otherSize(2)) );
%         end
%     end
% end
% newD=sortrows(distRelationsBetweenCluster);
figure(10),clf;
k=0;
cand=[3 4 9 14 18 22 31 35 38 43 48 50 53 67 69 70]
for ii=1:length(cand)
    for jj=ii+1:length(cand)
        i=cand(ii);
        j=cand(jj);
        aa=find(newD(:,1)==i);
        %figure(10),clf;
        distData=newD(aa(find(newD(find(newD(:,1)==i),2)==j)),3);
        if (length(distData)>20)
            k=k+1;
            [i j k]
          subplot(6,5,k),hist(distData(distData<50),50);
          
        end
        
       %pause 
    end
end