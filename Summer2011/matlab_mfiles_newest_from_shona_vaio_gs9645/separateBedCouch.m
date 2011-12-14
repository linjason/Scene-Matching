% separates beds and couches into different groups
% when performing label transfer, it can be more effective to consider couches and beds as 
% a single category.
% the label transfer will output the components that it thinks are either beds or couches, and then we separate them properly with this script
% input: C array, allNewBeds (array containing C component indices of either beds or couches), heightMap
% output: beds, couches 

beds=zeros(0);
couches=zeros(0);
for i=1:length(allNewBeds)
    if strfind(C{allNewBeds(i)}{7},'bed')
        beds(end+1)=allNewBeds(i);
        continue;
    elseif strfind(C{allNewBeds(i)}{7},'couch')
        couches(end+1)=allNewBeds(i);
        continue;
    elseif strfind(C{allNewBeds(i)}{7},'sofa')
        couches(end+1)=allNewBeds(i);
        continue;
    end
    heightMap=aaBDLR2{allNewBeds(i)}(aaBDLR2{allNewBeds(i)}>0);
    calScore=size(find(ismember(heightMap,[median(reshape(heightMap,1,[]))-2:median(reshape(heightMap,1,[]))+2])==1),1)/(size(find(ismember(heightMap,[max(reshape(heightMap,1,[]))-4:max(reshape(heightMap,1,[]))])),1));
    if calScore>5
        beds(end+1)=allNewBeds(i);
    else
        couches(end+1)=allNewBeds(i);
    end
end
