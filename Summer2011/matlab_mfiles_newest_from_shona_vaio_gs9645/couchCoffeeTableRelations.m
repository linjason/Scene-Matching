% tables=taggedGroups{9};    %allNewTables;
% couches=taggedGroups{2};
% k=0;
% couchesInSameScene=zeros(0,2);
% couchesInSameSceneClusters=cell(0);
% couchesInSameSceneClustersNames=cell(0);
% remove=0;
% for i=1:length(couches)
%     for j=i+1:length(couches)
%         if isequal(C{couches(i)}{1},C{couches(j)}{1})
%             k=k+1
%             couchesInSameScene(end+1,1)=couches(i);
%             couchesInSameScene(end,2)=couches(j);
%         end
%     end
% end
% for i=1:size(couchesInSameScene,1)
%     indexForClusterName=find((ismember(couchesInSameSceneClustersNames,C{couchesInSameScene(i,1)}{1}))==1);
%     if isempty(indexForClusterName)
%         couchesInSameSceneClustersNames{end+1}=C{couchesInSameScene(i,1)}{1};
%         couchesInSameSceneClusters{end+1}=couchesInSameScene(i,1:2);
%     else
%         couchesInSameSceneClusters{indexForClusterName}=unique([couchesInSameSceneClusters{indexForClusterName} couchesInSameScene(i,1:2) ]);
%     end
% end
% % remove duplicate couches 
% for i=1:length(couchesInSameSceneClusters)
%     compIndices=zeros(0);
%     for j=1:length(couchesInSameSceneClusters{i})
%         compIndices(j)=C{ couchesInSameSceneClusters{i}(j)}{2};
%     end
%     uniqueCompIndices=unique(compIndices);
%     for j=1:length(uniqueCompIndices)
%         if length(find(compIndices==uniqueCompIndices(j)))>=2
%             couchesInSameSceneClusters{i}
%             couchesInSameSceneClusters{i}(find(compIndices==uniqueCompIndices(j),length(find(compIndices==uniqueCompIndices(j)))-1,'last'))=[]
%             remove=remove+1
%             couchesInSameSceneClusters{i}
%             compIndices(find(compIndices==uniqueCompIndices(j),length(find(compIndices==uniqueCompIndices(j)))-1,'last'))=[]
%         end
%     end
% end


% l=0;
% m=0;
% n=0;
% o=0;
% threeCouches=0;
% tableBetween3Couch=0;
% tableBetweenCouch=0;
% tableBetweenCouch2=0;
% for i=1:length(couchesInSameSceneClusters)
%     if length(couchesInSameSceneClusters{i})==2
%         m=m+1;
%     end
%     sort([couchDirection(find(couches==couchesInSameSceneClusters{i}(1),1)) couchDirection(find(couches==couchesInSameSceneClusters{i}(2),1))]);
%     if length(couchesInSameSceneClusters{i})==2 && isequal(sort([couchDirection(find(couches==couchesInSameSceneClusters{i}(1),1)) couchDirection(find(couches==couchesInSameSceneClusters{i}(2),1))]),[1 2])
%         l=l+1;
%         if C{couchesInSameSceneClusters{i}(1)}{3}(1)<C{couchesInSameSceneClusters{i}(2)}{3}(1)
%             leftCouch=couchesInSameSceneClusters{i}(1);
%             rightCouch=couchesInSameSceneClusters{i}(2);
%         else
%             leftCouch=couchesInSameSceneClusters{i}(2);
%             rightCouch=couchesInSameSceneClusters{i}(1);
%         end
%         for j=1:length(tables)
%             tableMidX=(C{tables(j)}{4}(1)+C{tables(j)}{3}(1))/2;
%             if isequal(C{tables(j)}{1}, C{couchesInSameSceneClusters{i}(2)}{1})&& tableMidX<C{rightCouch}{3}(1) && tableMidX>C{leftCouch}{4}(1)
%                 tableBetweenCouch=tableBetweenCouch+1;
%                 couchesInSameSceneClusters{i}(1);
%                 couchesInSameSceneClusters{i}(2);
%                 break;
%             end
%         end
%     elseif length(couchesInSameSceneClusters{i})==2 && isequal(sort([couchDirection(find(couches==couchesInSameSceneClusters{i}(1),1)) couchDirection(find(couches==couchesInSameSceneClusters{i}(2),1))]),[3 4])
%         l=l+1;
%         couchesInSameSceneClusters{i}(1);
%         couchesInSameSceneClusters{i}(2);
%         if C{couchesInSameSceneClusters{i}(1)}{3}(2)<C{couchesInSameSceneClusters{i}(2)}{3}(2)
%             bottomCouch=couchesInSameSceneClusters{i}(1);
%             topCouch=couchesInSameSceneClusters{i}(2);
%         else
%             topCouch=couchesInSameSceneClusters{i}(1);
%             bottomCouch=couchesInSameSceneClusters{i}(2);
%         end
%         for j=1:length(tables)
%             tableMidY=(C{tables(j)}{4}(2)+C{tables(j)}{3}(2))/2;
%             if isequal(C{tables(j)}{1}, C{couchesInSameSceneClusters{i}(2)}{1}) && tableMidY<C{topCouch}{3}(2) && tableMidY>C{bottomCouch}{4}(2)
%                 tableBetweenCouch=tableBetweenCouch+1;
%                 break;
%             end
%         end
%     elseif length(couchesInSameSceneClusters{i})==2 &&couchDirection(find(couches==couchesInSameSceneClusters{i}(1),1))~=0&&couchDirection(find(couches==couchesInSameSceneClusters{i}(2),1))~=0
%         n=n+1;
%         twoCouches=sort([couchDirection(find(couches==couchesInSameSceneClusters{i}(1),1)) couchDirection(find(couches==couchesInSameSceneClusters{i}(2),1))]);
%         oneCouch=twoCouches(1);
%         otherCouch=twoCouches(2);
%         for j=1:length(tables)
%             tableMidY=(C{tables(j)}{4}(2)+C{tables(j)}{3}(2))/2;
%             tableMidX=(C{tables(j)}{4}(1)+C{tables(j)}{3}(1))/2;
%             if isequal(C{tables(j)}{1}, C{couchesInSameSceneClusters{i}(2)}{1}) && tableMidY<C{oneCouch}{4}(2) &&tableMidY>C{oneCouch}{3}(2)&&tableMidX>C{oneCouch}{3}(1)&&tableMidX<C{oneCouch}{4}(1)
%                 tableBetweenCouch2=tableBetweenCouch2+1;
%                 break;
%             end
%         end
%     elseif length(couchesInSameSceneClusters{i})==3 && ~ismember(0,couchDirection(find(ismember(couches,couchesInSameSceneClusters{i}))))
%         firstCouchMid=(C{couchesInSameSceneClusters{i}(1)}{3}+C{couchesInSameSceneClusters{i}(1)}{4})/2;
%         secondCouchMid=(C{couchesInSameSceneClusters{i}(2)}{3}+C{couchesInSameSceneClusters{i}(2)}{4})/2;
%         thirdCouchMid=(C{couchesInSameSceneClusters{i}(3)}{3}+C{couchesInSameSceneClusters{i}(3)}{4})/2;
%         i;
%         o=o+1;
%         distances=[abs(firstCouchMid(1)-secondCouchMid(1))+abs(firstCouchMid(2)-secondCouchMid(2)) abs(firstCouchMid(1)-thirdCouchMid(1))+abs(firstCouchMid(2)-thirdCouchMid(2)) abs(secondCouchMid(1)-thirdCouchMid(1))+abs(thirdCouchMid(2)-secondCouchMid(2))];
%         if length(find(distances<210))>=2
%             threeCouches=threeCouches+1;
%             aa=0;
%             for j=1:length(tables)
%                 tableMidY=(C{tables(j)}{4}(2)+C{tables(j)}{3}(2))/2;
%                 tableMidX=(C{tables(j)}{4}(1)+C{tables(j)}{3}(1))/2;
%                 threeCouchMax=max([C{couchesInSameSceneClusters{i}(1)}{4};C{couchesInSameSceneClusters{i}(3)}{4};C{couchesInSameSceneClusters{i}(2)}{4}]);
%                 threeCouchMin=min([C{couchesInSameSceneClusters{i}(1)}{3};C{couchesInSameSceneClusters{i}(3)}{3};C{couchesInSameSceneClusters{i}(2)}{3}]);
%                 threeCouchMaxX=threeCouchMax(1);
%                 threeCouchMaxY=threeCouchMax(2);
%                 threeCouchMinX=threeCouchMin(1);
%                 threeCouchMinY=threeCouchMin(2);
%                 
%                 if isequal(C{tables(j)}{1}, C{couchesInSameSceneClusters{i}(3)}{1})&&tableMidY<threeCouchMaxY&&tableMidY>threeCouchMinY&&tableMidX<threeCouchMaxX&&tableMidX>threeCouchMinX
%                     tableBetween3Couch=tableBetween3Couch+1;
%                     aa=1;
%                     break;
%                 end
%             end
%             if aa==0
%                 i
%             end
%             
%         end
%     end
%     if length(couchesInSameSceneClusters{i})==1&&~ismember(0,couchDirection(find(ismember(couches,couchesInSameSceneClusters{i}))))
%         i
%     end
% end

%distance between coffee table and couch
% numScenesWithOnlyOneCouch=0;
% couchTableDistances=zeros(0,3);
% couchTableDistancesForScenesWithOnlyOneCouch=zeros(0);
% k=0;
% for j=1:length(couches)
%     if ~ismember(C{couches(j)}{1},couchesInSameSceneClustersNames)
%         isSceneWithOnlyOneCouch=1;
%         numScenesWithOnlyOneCouch=numScenesWithOnlyOneCouch+1;
%     else
%         isSceneWithOnlyOneCouch=0;
%     end
%     foundTableForOneCouchScene=0;
%     for i=1:length(tables)
%         oneCenterX=(C{tables(i)}{4}(1)+C{tables(i)}{3}(1))/2;
%         oneCenterY=(C{tables(i)}{4}(2)+C{tables(i)}{3}(2))/2;
%         otherCenterX=(C{couches(j)}{4}(1)+C{couches(j)}{3}(1))/2;
%         otherCenterY=(C{couches(j)}{4}(2)+C{couches(j)}{3}(2))/2;
%         tableMinX=C{tables(i)}{3}(1);
%         tableMinY=C{tables(i)}{3}(2);
%         tableMaxX=C{tables(i)}{4}(1);
%         tableMaxY=C{tables(i)}{4}(2);
%         couchMinX=C{couches(j)}{3}(1);
%         couchMinY=C{couches(j)}{3}(2);
%         couchMaxX=C{couches(j)}{4}(1);
%         couchMaxY=C{couches(j)}{4}(2);
%         if isequal(C{tables(i)}{1},C{couches(j)}{1}) && abs(oneCenterX-otherCenterX)+abs(oneCenterY-otherCenterY)<150
%             if couchDirection(j)==0
%                 continue;
%             elseif couchDirection(j)==1 && tableMinX-couchMaxX>0 && oneCenterY>couchMinY-8 && oneCenterY<couchMaxY+8 && tableMinX-couchMaxX<60
%                 k=k+1;
%                 if isSceneWithOnlyOneCouch
%                     foundTableForOneCouchScene=1;
%                     couchTableDistancesForScenesWithOnlyOneCouch(end+1)=tableMinX-couchMaxX;
%                 end
%                 couchTableDistances(end+1,1)=tableMinX-couchMaxX;
%                 couchTableDistances(end,2)=i;
%                 couchTableDistances(end,3)=j;
%             elseif couchDirection(j)==2 && couchMinX-tableMaxX>0 && oneCenterY>couchMinY-8 && oneCenterY<couchMaxY+8 && couchMinX-tableMaxX<60
%                 k=k+1;
%                 if isSceneWithOnlyOneCouch
%                     foundTableForOneCouchScene=1;
%                     couchTableDistancesForScenesWithOnlyOneCouch(end+1)=couchMinX-tableMaxX;
%                 end
%                 couchTableDistances(end+1,1)=couchMinX-tableMaxX;
%                 couchTableDistances(end,2)=i;
%                 couchTableDistances(end,3)=j;
%             elseif couchDirection(j)==3 && tableMinY-couchMaxY>0 && oneCenterX>couchMinX-8 && oneCenterX<couchMaxX+8 && tableMinY-couchMaxY<60
%                 k=k+1;
%                 if isSceneWithOnlyOneCouch
%                     foundTableForOneCouchScene=1;
%                     couchTableDistancesForScenesWithOnlyOneCouch(end+1)=tableMinY-couchMaxY;
%                 end
%                 couchTableDistances(end+1,1)=tableMinY-couchMaxY;
%                 couchTableDistances(end,2)=i;
%                 couchTableDistances(end,3)=j;
%             elseif couchDirection(j)==4 && couchMinY-tableMaxY>0 && oneCenterX>couchMinX-8 && oneCenterX<couchMaxX+8 && couchMinY-tableMaxY<60
%                 k=k+1;
%                 if isSceneWithOnlyOneCouch
%                     foundTableForOneCouchScene=1;
%                     couchTableDistancesForScenesWithOnlyOneCouch(end+1)=couchMinY-tableMaxY;
%                 end
%                 couchTableDistances(end+1,1)=couchMinY-tableMaxY;
%                 couchTableDistances(end,2)=i;
%                 couchTableDistances(end,3)=j;
%             end
%         end
%     end
%     if ~foundTableForOneCouchScene && isSceneWithOnlyOneCouch
%         C{couches(j)};
%     end
% end

couchDirection=zeros(0);
for i=1:length(couches)
    couchHeightMap=aaBDLR2{couches(i)};
    couchHeightMap1=couchHeightMap(1:round(end/2),:);
    couchHeightMap2=couchHeightMap(round(end/2)+1:end,:);
    couchHeightMap3=couchHeightMap(:,1:round(end/2));
    couchHeightMap4=couchHeightMap(:,round(end/2)+1:end);
    if abs(sum(sum(couchHeightMap1))-sum(sum(couchHeightMap2)))>0.14*(sum(sum(couchHeightMap1))+sum(sum(couchHeightMap2)))/2
        if sum(sum(couchHeightMap1))>sum(sum(couchHeightMap2))
            couchDirection(i)=1;
        else
            couchDirection(i)=2;
        end
    elseif abs(sum(sum(couchHeightMap3))-sum(sum(couchHeightMap4)))>0.14*(sum(sum(couchHeightMap3))+sum(sum(couchHeightMap4)))/2
       if sum(sum(couchHeightMap3))>sum(sum(couchHeightMap4))
            couchDirection(i)=3;
        else
            couchDirection(i)=4;
        end
    end
end