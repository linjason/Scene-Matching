d_results = dir('../../results_ALL/');
i = 0
B=cell(0);
kk=0;
for fileIndex = 1:(length(d_results)-2)
    clear A
    fileIndex
    if ismember(d_results(fileIndex+2).name,allKeys)
        continue;
    end
    kk=kk+1;
    d_results(fileIndex+2).name
    load(strcat('../../results_ALL/', d_results(fileIndex+2).name));
    clear minZ
    startIndexForThisComp = i + 1;
    for compIndex = 1:size(A,2) - 1
        compIndex;
%         if(size(A{compIndex})==[1 1])
%             continue
%         end
        points = cell2mat(A{compIndex}(1:2:end-1)');
        if (isempty(points))
            continue;
        end
        i = i + 1;
        minPoint = min(points);
        maxPoint = max(points);
        B{i}{1} = d_results(fileIndex+2).name;
        B{i}{2} = compIndex;
        B{i}{3} = minPoint;
        B{i}{4} = maxPoint;
        minZ(i-startIndexForThisComp+1)=minPoint(3);
        B{i}{7}=A{compIndex}{end};
    end
    for j =  startIndexForThisComp:i
        B{j}{5} = min(minZ);
    end
end