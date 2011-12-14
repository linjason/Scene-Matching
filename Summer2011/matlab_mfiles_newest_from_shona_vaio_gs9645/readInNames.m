% this file reads in tagged SU component names from a text file and adds it into the A matrix
% now incorporated into compWithMeshNoExplode3.m

d_results = dir('./results')
for fileIndex = 1:(length(d_results)-2)
    fileIndex
    d_results(fileIndex+2).name;
    [path, name, ext] = fileparts(d_results(fileIndex+2).name);
    file = fopen(strcat('./results_name/', d_results(fileIndex+2).name), 'r');
    clear A
    load(strcat('./results_mat/', strcat(name, '.mat')));
    compIndex = 0;
 
    while(~feof(file))
        line = fgetl(file);
        if (findstr('compName', line))
            continue;
        elseif (~isempty(findstr('grouName', line)) || ~isempty(findstr('defiName', line)))
            compIndex = compIndex + 1;
            A{compIndex}{size(A{compIndex},2)+1}=line(11:end);
         end
    end
    if compIndex+1~=size(A,2)
       disp('as~~~~!') 
    end
    fclose('all');
    
    save(strcat('./results_mat/', strcat(name, '.mat')), 'A');
   clear A;
end
