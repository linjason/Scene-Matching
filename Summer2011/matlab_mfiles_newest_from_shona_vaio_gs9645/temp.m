couchesInSameScene=zeros(0,2);
couchesInSameSceneClusters=cell(0);
couchesInSameSceneClustersNames=cell(0);
remove=0;
for i=1:length(taggedGroups{1})
    for j=i+1:length(taggedGroups{1})
        if isequal(C{taggedGroups{1}(i)}{1},C{taggedGroups{1}(j)}{1})
            k=k+1
            couchesInSameScene(end+1,1)=taggedGroups{1}(i);
            couchesInSameScene(end,2)=taggedGroups{1}(j);
        end
    end
end
for i=1:size(couchesInSameScene,1)
    indexForClusterName=find((ismember(couchesInSameSceneClustersNames,C{couchesInSameScene(i,1)}{1}))==1);
    if isempty(indexForClusterName)
        couchesInSameSceneClustersNames{end+1}=C{couchesInSameScene(i,1)}{1};
        couchesInSameSceneClusters{end+1}=couchesInSameScene(i,1:2);
    else
        couchesInSameSceneClusters{indexForClusterName}=unique([couchesInSameSceneClusters{indexForClusterName} couchesInSameScene(i,1:2) ]);
    end
end
for i=1:length(couchesInSameSceneClusters)
    compIndices=zeros(0);
    for j=1:length(couchesInSameSceneClusters{i})
        compIndices(j)=C{ couchesInSameSceneClusters{i}(j)}{2};
    end
    uniqueCompIndices=unique(compIndices);
    for j=1:length(uniqueCompIndices)
        if length(find(compIndices==uniqueCompIndices(j)))>=2
            couchesInSameSceneClusters{i}
            couchesInSameSceneClusters{i}(find(compIndices==uniqueCompIndices(j),length(find(compIndices==uniqueCompIndices(j)))-1,'last'))=[]
            remove=remove+1
            couchesInSameSceneClusters{i}
            compIndices(find(compIndices==uniqueCompIndices(j),length(find(compIndices==uniqueCompIndices(j)))-1,'last'))=[]
        end
    end
end