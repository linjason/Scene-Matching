clusters=cell(0);
for i=1:num_cl
    i;
    nm=convertion(find(cluster_labels==i));
    for j=1:length(nm)
        clusters{i}{j}=nm(j);
    end
end
sco=0;
numTagged=0;
for j=1:num_cl
    indicesForCluster=cell2mat(clusters{j});
    realTags=zeros(size(indicesForCluster));
    for k=1:length(realTags)
        i=indicesForCluster(k);
        if isempty(find(convertionTagged==i, 1))
            realTags(k)=-1;
            continue;
        end
        if (~isempty(strfind(lower(C{i}{7}),'dresser'))||~isempty(strfind(lower(C{i}{7}),'arm'))||~isempty(strfind(lower(C{i}{7}),'drawer'))||~isempty(strfind(lower(C{i}{7}),'arm')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'room'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'convertable'))
            realTags(k)=1;
        end
        if ((~isempty(strfind(lower(C{i}{7}),'bed')) || ~isempty(strfind(lower(C{i}{7}),'bed')))&& isempty(strfind(lower(C{i}{7}),'lateral')) && isempty(strfind(lower(C{i}{7}),'head')) && isempty(strfind(lower(C{i}{7}),'table')) && isempty(strfind(lower(C{i}{7}),'frame')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'latte')) && isempty(strfind(lower(C{i}{7}),'tv')) && isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'pole')))
            realTags(k)=2;
        end
        if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
            realTags(k)=3;
        end
        if (~isempty(strfind(lower(C{i}{7}),'nightstand')) ||  ~isempty(strfind(lower(C{i}{7}),'night stand')) || ~isempty(strfind(lower(C{i}{7}),'bedside'))) && isempty(strfind(lower(C{i}{7}),'lamp')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'bed')) && isempty(strfind(lower(C{i}{7}),'dresser')) && isempty(strfind(lower(C{i}{7}),'convertable'))
            realTags(k)=4;
        end
        if (~isempty(strfind(lower(C{i}{7}),'table')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
            realTags(k)=5;
        end
        if (~isempty(strfind(lower(C{i}{7}),'desk')))&&isempty(strfind(lower(C{i}{7}),'desktop'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
            realTags(k)=6;
        end
        if (~isempty(strfind(lower(C{i}{7}),'light'))||~isempty(strfind(lower(C{i}{7}),'lamp')))&&isempty(strfind(lower(C{i}{7}),'desktop'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
            realTags(k)=7;
        end
        if (~isempty(strfind(lower(C{i}{7}),'toilet'))||~isempty(strfind(lower(C{i}{7}),'toilet')))&&isempty(strfind(lower(C{i}{7}),'desktop'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
            realTags(k)=8;
        end
    end
    realTags(realTags==-1)=[];
    if length(find(realTags==mode(realTags)))/length(realTags)>0.7 && length(realTags)>5 && mode(realTags)~=0
        [length(find(realTags==mode(realTags))) length(realTags) j mode(realTags)];
        numTagged=numTagged+length(find(realTags==mode(realTags)));
        sco=sco+1;
    end
end