% bedIndices=beds;
% couchIndices=couches;
% nightstandIndices=allNewNightstands;


% % %distance between bed and nightstands
% k=0;
% bedIndices=taggedGroups{1};
% nightstandIndices=taggedGroups{8};
% distRelationsBetweenTagged=zeros(0,4);
% for i=1:length(bedIndices)
%     for j=1:length(nightstandIndices)
%         if isequal(C{bedIndices(i)}{1},C{nightstandIndices(j)}{1})
%             k=k+1
%             oneObject=bedIndices(i);
%             otherObject=nightstandIndices(j);
%             distRelationsBetweenTagged(end+1,1)=min([abs(C{oneObject}{4}(1)-C{otherObject}{4}(1)),abs(C{oneObject}{3}(1)-C{otherObject}{3}(1)),abs(C{oneObject}{3}(2)-C{otherObject}{3}(2)),abs(C{oneObject}{4}(2)-C{otherObject}{4}(2))] );
%             distRelationsBetweenTagged(end,2)=oneObject;
%             distRelationsBetweenTagged(end,3)=otherObject;
%             distRelationsBetweenTagged(end,4)=min([abs(C{oneObject}{4}(1)-C{otherObject}{3}(1)),abs(C{oneObject}{4}(2)-C{otherObject}{3}(2)),abs(C{otherObject}{4}(1)-C{oneObject}{3}(1)),abs(C{otherObject}{4}(2)-C{oneObject}{3}(2))]);
%         end
%      end
% end


% taggedGroups=cell(0);
% taggedGroups{1}=bedIndices;
% taggedGroups{2}=couchIndices;
% taggedGroups{3}=allNewCabinets;
% taggedGroups{4}=allNewChairs;
% taggedGroups{5}=allNewDesks;
% taggedGroups{6}=allNewDrawers;
% taggedGroups{7}=allNewDressers;
% taggedGroups{8}=allNewNightstands;
% taggedGroups{9}=allNewTables;
% m=0;

%remove duplicates
for i=1:length(taggedGroups)
    tempGroup=taggedGroups{i};
    toRemove=zeros(0);  
    for j=1:length(tempGroup)
        for k=j+1:length(tempGroup)
            if isequal(C{tempGroup(j)}{1}, C{tempGroup(k)}{1}) && isequal(C{tempGroup(j)}{2}, C{tempGroup(k)}{2})
                toRemove(end+1)=k;
                %toRemove(end,2)=j;
                
                m=m+1;
            end
        end
    end
    size(toRemove)
    taggedGroups{i}(toRemove)=[];   
end



% size distribution, height histograms, distToWalls histograms
% figure
% axis square
% for i=1:length(taggedGroups)
%     sideImage=zeros(50,50);
%     for j=1:length(taggedGroups{i})
%         objectIndex=taggedGroups{i}(j);
%         objectSize=C{objectIndex}{4}-C{objectIndex}{3};
%         xSide=min(objectSize(1),objectSize(2));
%         ySide=max(objectSize(1),objectSize(2));
%         if ceil(xSide/2)>50 || ceil(ySide/2)>50
%             i
%             continue;
%         end
%         sideImage(ceil(xSide/2),ceil(ySide/2))= sideImage(ceil(xSide/2),ceil(ySide/2))+1;
%      end
%     subplot(1,1,1),imagesc(sideImage);
%     axis square
%     pause
% end
% for i=1:length(taggedGroups)
%     heights=zeros(0);
%     distToWalls=zeros(0);
%     for j=1:length(taggedGroups{i})
%         objectIndex=taggedGroups{i}(j);
%         objectSize=C{objectIndex}{4}-C{objectIndex}{3};
%         heights(end+1)=objectSize(3);
%         distToWalls(end+1)=min(C{objectIndex}{6});
%     end
%     subplot(3,9,9+i),hist(heights,60)
%     subplot(3,9,9*2+i),hist(distToWalls(distToWalls<100),60)
% end
% 
% 
% subplot(3,9,1),ylabel('x and y sizes (each block is 6 inches)')
% subplot(3,9,1+9),ylabel('z (height) histogram')
% subplot(3,9,1+18),ylabel('distance of object to closest wall')
% subplot(3,9,1+9),title('bed')
% subplot(3,9,2+9),title('couch')
% subplot(3,9,3+9),title('cabinet')
% subplot(3,9,4+9),title('chair')
% subplot(3,9,5+9),title('desk')
% subplot(3,9,6+9),title('drawer')
% subplot(3,9,7+9),title('dresser')
% subplot(3,9,8+9),title('nightstand')
% subplot(3,9,9+9),title('table')
