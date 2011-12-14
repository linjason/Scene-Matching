bedIndex=0;
taggedIndex=0;
bedIndices=zeros(0);
taggedIndices=zeros(0);
target=zeros(0);
finalScores=zeros(0);
for i=1:size(C,2)
    
    strings={'bed','light','window','door','speaker','lamp','table','pillow','books','desk','arm','tv','vase','ceiling','drawer','man','cabinet','dresser','computer}','joist','sink','sink','frame','box','toilet','couch','nightstand','sconce','mecate','handle','clock','curtain','blinds','plant','mirror','flatscreen','dining','rug','wardrobe','doorknob','phone','phone','estructura','sofa','guitar','chest','armoire','picture','stool','bathroom','laptop','basket','fan','apple','binder','bookcase','candle','carpet','print','heater','mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote'};
    for j=1:size(strings,2)
        if ~isempty(findstr(strings{j},lower(C{i}{7})))
            taggedIndex=taggedIndex+1;
            taggedIndices(taggedIndex,1)=i;
            break;
        else
            continue
        end
        
    end
    % if (~isempty(findstr('dresser',lower(C{i}{7})))||~isempty(findstr('dresser',lower(C{i}{7}))))&&isempty(findstr('lamp',lower(C{i}{7})))&&isempty(findstr('room',lower(C{i}{7})))&&isempty(findstr('bed',lower(C{i}{7})))&&isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('convertable',lower(C{i}{7})))
     if ((~isempty(findstr('bed',lower(C{i}{7}))) || ~isempty(findstr('couch',lower(C{i}{7}))))&& isempty(findstr('lateral',lower(C{i}{7}))) && isempty(findstr('head',lower(C{i}{7}))) && isempty(findstr('table',lower(C{i}{7}))) && isempty(findstr('frame',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('latte',lower(C{i}{7}))) && isempty(findstr('tv',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('pole',lower(C{i}{7}))))
        %if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
        %     if (~isempty(findstr('nightstand',lower(C{i}{7}))) || ~isempty(findstr('night stand',lower(C{i}{7})))) && isempty(findstr('lamp',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('bed',lower(C{i}{7}))) && isempty(findstr('dresser',lower(C{i}{7}))) && isempty(findstr('convertable',lower(C{i}{7})))
        bedIndex=bedIndex+1;
        C{i};
        bedIndices(bedIndex,1)=i;
        target(taggedIndex)=1;
    end
    
    
end
target(size(target,2)+1:taggedIndex)=0;
j=0;
parfor i=1:size(taggedIndices,1)
    if   ismember(taggedIndices(i),bedIndices)
        remove=find(bedIndices==taggedIndices(i));
        compareAgainst=bedIndices([1:remove-1 remove+1:end]);
       %evaluateFindBeds
    else
        compareAgainst=bedIndices;
        
    end
    finalScores(i)=max(evaluateCorr2Imresz(compareAgainst, taggedIndices(i)));
end
%prec_rec(finalScores,target);s
save('ev');