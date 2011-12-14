% for i=1:length(taggedGroups{1}) % beds
%     for j=
%
%
%
%     end
% end
allKeys=keys(mapOfCompToVarshaCategory);
numberOfBedsInScenes=zeros(0);
objectsNearBedInOneBedScenes=zeros(0);
for i=1:length(allKeys)
    value=mapOfCompToVarshaCategory(allKeys{i});
    if ~isequal('help',allKeys{i})
        i;  
        length(find(abs(cell2mat(value(:,2)))==1));
        numberOfBedsInScenes(end+1)=length(find(abs(cell2mat(value(:,2)))==1));
    else
        continue
    end
    ptr=pointerFromAtoC(allKeys{i});
    % only one bed in scene
    if length(find(abs(cell2mat(value(:,2)))==1))==1
        for j=1:size(ptr,1)
            if isempty(ptr{j,1}), continue, end
            % not in same scene
            if ~isequal(C{ptr{j,1}}{1},C{ptr{find(abs(cell2mat(value(:,2)))==1),1}}{1}), i,keyboard, end
            % comparing two same objects
            if isequal(C{ptr{j,1}}{2},C{ptr{find(abs(cell2mat(value(:,2)))==1),1}}{2}), continue, end
            % ignore objects 1 foot above ground
            if C{ptr{j,1}}{3}(3)-C{ptr{j,1}}{5}>12, continue, end
            if distNearestPixels(ptr{j,1},ptr{find(abs(cell2mat(value(:,2)))==1),1},C)<12 
                objectsNearBedInOneBedScenes(end+1)=value{j,2};
                if value{j,2}==0
                    C{ptr{j,1}}{7}
                    allKeys{i}
                end
            end
        end
    end
 end
