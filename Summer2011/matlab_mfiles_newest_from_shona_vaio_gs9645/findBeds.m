j=0;
distToGround=zeros(0, 1);
sizes=zeros(0, 3);
distsToWalls=zeros(0, 4);
indices=zeros(0,1);
clear comps;
for i=1:size(C,2)
    if (~isempty(findstr('bed',lower(C{i}{7})))  && isempty(findstr('table',lower(C{i}{7}))) && isempty(findstr('frame',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('tv',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('pole',lower(C{i}{7}))))
        j=j+1;
        comps{j}=C{i};
        distToGround(j, 1)=C{i}{3}(3)-C{i}{5};
        distsToWalls(j, :)=C{i}{6};
        sizes(j, :)=C{i}{4}-C{i}{3};
        indices(j,1)=i;
    end
end
j=0;
for i=1:size(C,2)
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    if(xySorted(1)>32 && xySorted(1)<88 && xySorted(2)<88 && xySorted(2)>72 && C{i}{3}(3)-C{i}{5} < 10 && isempty(find(indices==i))&&isempty(findstr('couch',lower(C{i}{7})))&&isempty(findstr('sofa',lower(C{i}{7})))&&isempty(findstr('desk',lower(C{i}{7})))&&isempty(findstr('table',lower(C{i}{7})))&&isempty(findstr('drawer',lower(C{i}{7}))) && height<50 && height>20 && (~isequal(isnan(C{i}{6}), [0 0 0 0])||min(C{i}{6})<11))
        j=j+1
        C{i}
        
        
    end
end