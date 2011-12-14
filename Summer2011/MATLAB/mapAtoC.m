pointerFromAtoC=containers.Map;
allKeys=keys(mapOfCompToVarshaCategory);
newKeys=cell(0);
newValues=cell(0);
for i=1:length(allKeys)
    if isequal('help',allKeys{i})
        continue
    end
    i;
    newValue=cell(0);
    for j=1:length(C)
        if isequal(C{j}{1},allKeys{i})
            break
        end
    end
    while j<=length(C) && isequal(C{j}{1},allKeys{i})
        newValue{C{j}{2},1}=j;
        newValue{C{j}{2},2}=C{j}{7};
        j=j+1;
    end
    pointerFromAtoC(allKeys{i})=newValue;
end
% simple check for correctness
allKeys=keys(pointerFromAtoC);
for i=1:length(allKeys)
    if ~isequal(size(mapOfCompToVarshaCategory(allKeys{i}),1), ...
                size(pointerFromAtoC(allKeys{i}),1)), i, end
    for j=1:size(pointerFromAtoC(allKeys{i}),1)
        aa=pointerFromAtoC(allKeys{i});
        if isempty(aa{j,1})
            continue;
        end
        if ~isequal(allKeys{i},C{aa{j,1}}{1}) || ~isequal(aa{j,2},C{aa{j,1}}{7})
            i
            keyboard
        end
    end
end