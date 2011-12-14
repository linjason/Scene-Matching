tic
disp('wrg')
load('compsHeightViewsAll');
load('compsSideViewsAll');
load('comps3DVoxPorDnsized')
load(['../../dataStructureForStatistics/bedrooms_2_with_dist_nametags']);
load('compsHeightViewsAllRsz');
load('compsSideViewsAllRsz');

bedIndex=0;
taggedIndex=0;
bedIndices=zeros(0);
taggedIndices=zeros(0);
target=zeros(0);
finalScores=cell(0);
for i=1:8819
    strings={'bed','light','window','door','speaker','lamp','table','pillow','books','desk','arm','tv','vase','ceiling','drawer','man','cabinet','dresser','computer}','joist','sink','sink','frame','box','toilet','couch','nightstand','sconce','mecate','handle','clock','curtain','blinds','plant','mirror','flatscreen','dining','rug','wardrobe','doorknob','phone','phone','estructura','sofa','guitar','chest','armoire','picture','stool','bathroom','laptop','basket','fan','apple','binder','bookcase','candle','carpet','print','heater','mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote','stand','night'};
    a=0;
    for j=1:size(strings,2)
        if ~0%isempty(strfind(lower(C{i}{7}),strings{j}))
            taggedIndex=taggedIndex+1;
            taggedIndices(taggedIndex,1)=i;
            a=1;
bedIndex=bedIndex+1;
        C{i};
        bedIndices(bedIndex,1)=i;
        target(taggedIndex)=1;
       break;
        else
            continue
        end
    end
    %  if (~isempty(strfind(lower(C{i}{7}),'dresser'))||~isempty(strfind(lower(C{i}{7}),'dresser')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'room'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    %if ((~isempty(strfind(lower(C{i}{7}),'bed')) || ~isempty(strfind(lower(C{i}{7}),'bed')))&& isempty(strfind(lower(C{i}{7}),'lateral')) && isempty(strfind(lower(C{i}{7}),'head')) && isempty(strfind(lower(C{i}{7}),'table')) && isempty(strfind(lower(C{i}{7}),'frame')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'latte')) && isempty(strfind(lower(C{i}{7}),'tv')) && isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'pole')))
    %if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
    %if (~isempty(strfind(lower(C{i}{7}),'nightstand')) ||  ~isempty(strfind(lower(C{i}{7}),'night stand'))) && isempty(strfind(lower(C{i}{7}),'lamp')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'bed')) && isempty(strfind(lower(C{i}{7}),'dresser')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    %    if (~isempty(strfind(lower(C{i}{7}),'table')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'dresser'))&&isempty(strfind(lower(C{i}{7}),'convertable'))
end
target(size(target,2)+1:taggedIndex)=0;
j=0;
compareAgainst=bedIndices;
validTemplates=zeros(0);
templateMat=cell(4);
for j=1:length(bedIndices)
    if ~isempty(comps3DVoxPorDnsized{bedIndices(j)})
        validTemplates(end+1)=bedIndices(j);
    end
end

parfor i=[]%1:size(taggedIndices,1)
    candidate=taggedIndices(i);
    sizesForComp = C{candidate}{4} - C{candidate}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    if isempty(comps3DVoxPorDnsized{candidate}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(comps3DVoxPorDnsized{candidate}) || isempty(aa{candidate})
        finalScores{i}=ones([1 length(validTemplates)]).*100000000;
    else
        oneSc=evaluateSimpVoxel2(validTemplates',taggedIndices(i), comps3DVoxPorDnsized,aa,C,templateMat,validTemplates')
        finalScores{i}=oneSc;
    end
end
parfor i=1:size(taggedIndices,1)
    candidate=taggedIndices(i);
    sizesForComp = C{candidate}{4} - C{candidate}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    i;
    if isempty(comps3DVoxPorDnsized{candidate}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(comps3DVoxPorDnsized{candidate}) || isempty(aa{candidate})
        finalScores{i}=ones([1 length(validTemplates)]).*100000000;
    else
        otherSc=(evaluateTempMatchHS2(validTemplates', taggedIndices(i),compsSideViewsAll,aa,C)/30)
        finalScores{i}=otherSc;
    end
end
parfor i=[]%1:size(taggedIndices,1)
    candidate=taggedIndices(i);
    sizesForComp = C{candidate}{4} - C{candidate}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    if isempty(comps3DVoxPorDnsized{candidate}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(comps3DVoxPorDnsized{candidate}) || isempty(aa{candidate})
        finalScores{i}=ones([1 length(validTemplates)]).*100000000;
    else
        finalScores{i}=abs(finalScores{i}./(evaluateCorr2HSImresz2(validTemplates',taggedIndices(i),compsSideViewsAllRsz,aaRsz,C)));
    end
end
toc
fs=zeros(size(target));
for i=1:length(fs)
fs(i)=min(finalScores{i});
end
%finalScores=fs;