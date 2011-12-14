tic
load('compsHeightViewsAllRsz');
load('compsSideViewsAllRsz');
load(['../../dataStructureForStatistics/bedrooms_2_with_dist_nametags']);
bedIndex=0;
taggedIndex=0;
bedIndices=zeros(0);
taggedIndices=zeros(0);
target=zeros(0);
finalScores=zeros(0);
for i=1:size(C,2)
    strings={'bed','light','window','door','speaker','lamp','table','pillow','books','desk','arm','tv','vase','ceiling','drawer','man','cabinet','dresser','computer}','joist','sink','sink','frame','box','toilet','couch','nightstand','sconce','mecate','handle','clock','curtain','blinds','plant','mirror','flatscreen','dining','rug','wardrobe','doorknob','phone','phone','estructura','sofa','guitar','chest','armoire','picture','stool','bathroom','laptop','basket','fan','apple','binder','bookcase','candle','carpet','print','heater','mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote','night','stand','nighttable','bedside','side','armoire','armadio','armrio','room','leg','chair'};
    a=0;
    for j=1:size(strings,2)
        if ~isempty(strfind(lower(C{i}{7}),strings{j}))
            taggedIndex=taggedIndex+1;
            taggedIndices(taggedIndex,1)=i;
        a=1;
            break;
        else
            continue
        end
        
    end
    % if (~isempty(strfind(lower(C{i}{7}),'dresser'))||~isempty(strfind(lower(C{i}{7}),'dresser')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'room'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    if ((~isempty(strfind(lower(C{i}{7}),'bed')) || ~isempty(strfind(lower(C{i}{7}),'bed')))&& isempty(strfind(lower(C{i}{7}),'lateral')) && isempty(strfind(lower(C{i}{7}),'head')) && isempty(strfind(lower(C{i}{7}),'table')) && isempty(strfind(lower(C{i}{7}),'frame')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'latte')) && isempty(strfind(lower(C{i}{7}),'tv')) && isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'pole')))
    %   if ((~isempty(strfind(lower(C{i}{7}),'sofa')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
    %  if (~isempty(strfind(lower(C{i}{7}),'nightstand')) ||  ~isempty(strfind(lower(C{i}{7}),'night stand'))) && isempty(strfind(lower(C{i}{7}),'lamp')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'bed')) && isempty(strfind(lower(C{i}{7}),'dresser')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    % if (~isempty(strfind(lower(C{i}{7}),'table')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
 if a==0
disp('235252435');
end
        
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
    else
        compareAgainst=bedIndices;
    end
    %       finalScores(i)=max(evaluateCorr2Imresz(compareAgainst, taggedIndices(i),aaRsz));
                finalScores(i)=min(evaluateSimpVoxel(compareAgainst, taggedIndices(i),compsSideViewsAllRsz,aaRsz,C));
end
%prec_rec(finalScores,target);
%save('ev3');
toc