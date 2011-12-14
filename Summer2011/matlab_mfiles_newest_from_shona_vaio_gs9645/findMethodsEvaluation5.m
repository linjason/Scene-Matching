tic
load('compsHeightViewsAll');
load('comps3DVoxPorDnsized')
load(['../../dataStructureForStatistics/bedrooms_2_with_dist_nametags']);
bedIndex=0;
taggedIndex=0;
bedIndices=zeros(0);
taggedIndices=zeros(0);
target=zeros(0);
finalScores=cell(0);
for i=1:size(C,2)
    strings={'bed','light','window','door','speaker','lamp','table','pillow','books','desk','arm','tv','vase','ceiling','drawer','man','cabinet','dresser','computer}','joist','sink','sink','frame','box','toilet','couch','nightstand','sconce','mecate','handle','clock','curtain','blinds','plant','mirror','flatscreen','dining','rug','wardrobe','doorknob','phone','phone','estructura','sofa','guitar','chest','armoire','picture','stool','bathroom','laptop','basket','fan','apple','binder','bookcase','candle','carpet','print','heater','mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote','night','stand'};
    for j=1:size(strings,2)
        if ~isempty(strfind(lower(C{i}{7}),strings{j}))
            taggedIndex=taggedIndex+1;
            taggedIndices(taggedIndex,1)=i;
  bedIndex=bedIndex+1;
        C{i};
        bedIndices(bedIndex,1)=i;
        target(taggedIndex)=1;

            break;
        else
            continue
        end
    end
    %    if 1
        %if (~isempty(findstr('dresser',lower(C{i}{7})))||~isempty(findstr('dresser',lower(C{i}{7}))))&&isempty(findstr('lamp',lower(C{i}{7})))&&isempty(findstr('room',lower(C{i}{7})))&&isempty(findstr('bed',lower(C{i}{7})))&&isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('convertable',lower(C{i}{7})))
        %if ((~isempty(findstr('bed',lower(C{i}{7}))) || ~isempty(findstr('couch',lower(C{i}{7}))))&& isempty(findstr('lateral',lower(C{i}{7}))) && isempty(findstr('head',lower(C{i}{7}))) && isempty(findstr('table',lower(C{i}{7}))) && isempty(findstr('frame',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('latte',lower(C{i}{7}))) && isempty(findstr('tv',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('pole',lower(C{i}{7}))))
        %if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
        % if (~isempty(findstr('nightstand',lower(C{i}{7}))) || ~isempty(findstr('night stand',lower(C{i}{7})))) && isempty(findstr('lamp',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('bed',lower(C{i}{7}))) && isempty(findstr('dresser',lower(C{i}{7}))) && isempty(findstr('convertable',lower(C{i}{7})))
        % if (~isempty(findstr('table',lower(C{i}{7}))))&&isempty(findstr('lamp',lower(C{i}{7})))&&isempty(findstr('bed',lower(C{i}{7})))&&isempty(findstr('leg',lower(C{i}{7})))&&isempty(findstr('dresser',lower(C{i}{7})))&&isempty(strfind(lower(C{i}{7}),'convertable'))    %if (~isempty(strfind(lower(C{i}{7}),'dresser'))||~isempty(strfind(lower(C{i}{7}),'dresser')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'room'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    % if ((~isempty(strfind(lower(C{i}{7}),'bed')) || ~isempty(strfind(lower(C{i}{7}),'couch')))&& isempty(strfind(lower(C{i}{7}),'lateral')) && isempty(strfind(lower(C{i}{7}),'head')) && isempty(strfind(lower(C{i}{7}),'table')) && isempty(strfind(lower(C{i}{7}),'frame')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'latte')) && isempty(strfind(lower(C{i}{7}),'tv')) && isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'pole')))
    % if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
    % if (~isempty(strfind(lower(C{i}{7}),'nightstand')) ||  ~isempty(strfind(lower(C{i}{7}),'night stand'))) && isempty(strfind(lower(C{i}{7}),'lamp')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'bed')) && isempty(strfind(lower(C{i}{7}),'dresser')) && isempty(strfind(lower(C{i}{7}),'convertable'))
     if (~isempty(strfind(lower(C{i}{7}),'table')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
        
    %   bedIndex=bedIndex+1;
    %    C{i};
    %    bedIndices(bedIndex,1)=i;
    %    target(taggedIndex)=1;
    %end
end
target(size(target,2)+1:taggedIndex)=0;
j=0;
validTemplates=0;
templateMat=cell(4);
for j=1:size(bedIndices,1)
    if ~isempty(comps3DVoxPorDnsized{bedIndices(j)})
        validTemplates=validTemplates+1;
    end
end
for k=1:4
    templateMat{k}=zeros(0,0);
    for j=1:size(bedIndices,1)
        if isempty(comps3DVoxPorDnsized{bedIndices(j)})
            continue;
        else
            comps3DRot=zeros(size(comps3DVoxPorDnsized{bedIndices(j)}));
            for l=1:size(comps3DVoxPorDnsized{bedIndices(j)},3)
                comps3DRot(:,:,l)=rot90(comps3DVoxPorDnsized{bedIndices(j)}(:,:,l),k-1);
            end
            templateMat{k} = [templateMat{k} reshape(comps3DRot,[],1)];
        end
    end
end
parfor i=1:size(taggedIndices,1)
    %    if ismember(taggedIndices(i),bedIndices)
    %   remove=find(bedIndices==taggedIndices(i));
    %compareAgainst=bedIndices([1:remove-1 remove+1:end]);
        % else
        compareAgainst=bedIndices;
        %end
    finalScores{i}{1}=taggedIndices(i);
    finalScores{i}{2}=evaluateSimpVoxel2(compareAgainst, taggedIndices(i),comps3DVoxPorDnsized,aa,C,templateMat,bedIndices);
end
 parfor i=1:size(taggedIndices,1)
     if ismember(taggedIndices(i),bedIndices)
         remove=find(bedIndices==taggedIndices(i));
         compareAgainst=bedIndices([1:remove-1 remove+1:end]);
     else
         compareAgainst=bedIndices;
     end
          finalScores(i)=(min(evaluateSimpVoxel(compareAgainst, ...
                                                taggedIndices(i), ...
                                                comps3DVoxPorDnsized,aa,C,templateMat,bedIndices))+min(evaluateTempMatchHS(compareAgainst, taggedIndices(i\
),compsSideViewsAll,aa,C))/30);%/max(evaluateCorr2HSImresz(compareAgainst,
                               %taggedIndices(i),compsSideViewsAllRsz,aaRsz,C));

 end
 parfor i=1:size(taggedIndices,1)
     if ismember(taggedIndices(i),bedIndices)
         remove=find(bedIndices==taggedIndices(i));
         compareAgainst=bedIndices([1:remove-1 remove+1:end]);
     else
         compareAgainst=bedIndices;
     end
          finalScores(i)=finalScores(i)/ ...
              max(evaluateCorr2HSImresz(compareAgainst,taggedIndices(i),compsSideViewsAllRsz,aaRsz,C));
 end
