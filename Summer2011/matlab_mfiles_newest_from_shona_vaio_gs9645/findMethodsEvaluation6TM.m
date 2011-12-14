tic
disp('wrg')
load('compsHeightViewsAllBDLR2');
load('compsSideViewsAllBDLR2Dnsized');
load('comps3DVoxPorBDLR2Dnsized')
load(['../../dataStructureForStatistics/bedrooms_livingrooms_2_with_dist_nametags']);
%load('compsHeightViewsAllRsz');
%load('compsSideViewsAllRsz');

bedIndex=0;
taggedIndex=0;
bedIndices=zeros(0);
taggedIndices=zeros(0);
target=zeros(0);
finalScores=cell(0);
%affMat=zeros(length(C),length(C));
%for sliceIndex=1:ceil(length(C)/200)

for i=1:length(C)
    strings={'bed','light','window','door','speaker','lamp','table','pillow','books','desk','arm','tv','vase','ceiling','drawer','man','cabinet','dresser','computer}','joist','sink','sink','frame','box','toilet','couch','nightstand','sconce','mecate','handle','clock','curtain','blinds','plant','mirror','flatscreen','dining','rug','wardrobe','doorknob','phone','phone','estructura','sofa','guitar','chest','armoire','picture','stool','bathroom','laptop','basket','fan','apple','binder','bookcase','candle','carpet','print','heater','mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote','stand','night'};
    a=0;
    for j=1:size(strings,2)
        if 1%~isempty(strfind(lower(C{i}{7}),strings{j}))
            taggedIndex=taggedIndex+1;
            taggedIndices(taggedIndex,1)=i;
            a=1;
            break;
        else
            continue
        end
    end
    if 1%(~isempty(strfind(lower(C{i}{7}),'dresser'))||~isempty(strfind(lower(C{i}{7}),'dresser')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'room'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'convertable'))
        % if ((~isempty(strfind(lower(C{i}{7}),'bed')) || ~isempty(strfind(lower(C{i}{7}),'bed')))&& isempty(strfind(lower(C{i}{7}),'lateral')) && isempty(strfind(lower(C{i}{7}),'head')) && isempty(strfind(lower(C{i}{7}),'table')) && isempty(strfind(lower(C{i}{7}),'frame')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'latte')) && isempty(strfind(lower(C{i}{7}),'tv')) && isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'pole')))
        % if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
        % if (~isempty(strfind(lower(C{i}{7}),'nightstand')) ||  ~isempty(strfind(lower(C{i}{7}),'night stand'))) && isempty(strfind(lower(C{i}{7}),'lamp')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'bed')) && isempty(strfind(lower(C{i}{7}),'dresser')) && isempty(strfind(lower(C{i}{7}),'convertable'))
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
%bedIndices=[1+200*(sliceIndex-1):min(200*sliceIndex,length(C))]';
%1+200*(sliceIndex-1)
%min(200*sliceIndex,length(C))
bedIndices=[1:length(C)]';
compareAgainst=bedIndices;
target(size(target,2)+1:taggedIndex)=0;
j=0;
validTemplates=zeros(0);
templateMat=cell(4);
for j=1:length(bedIndices)
    if ~isempty(comps3DVoxPorBDLR2Dnsized{bedIndices(j)})
        validTemplates(end+1)=bedIndices(j);
    end
end
newTaggedIndices=zeros(size(taggedIndices));
parfor i=1:size(taggedIndices,1)
    candidate=taggedIndices(i);
    sizesForComp = C{candidate}{4} - C{candidate}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    if isempty(compsSideViewsAllBDLR2Dnsized{candidate}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(compsSideViewsAllBDLR2Dnsized{candidate}) || isempty(aaBDLR2{candidate})
        if ~isempty(compsSideViewsAllBDLR2Dnsized{candidate}) && (xySorted(1)>=10&xySorted(2)>=10&& height>13&& height<75&&xySorted(1)<=90&&xySorted(2)<=90)&&~isempty(compsSideViewsAllBDLR2Dnsized{candidate}) && ~isempty(aaBDLR2{candidate})
            newTaggedIndices(i)=1;
             finalScores{i}=(evaluateTempMatchHS2(validTemplates',taggedIndices(i),compsSideViewsAllBDLR2Dnsized,aaBDLR2,C)/30);
        end
        %finalScores{i}=ones([1 length(validTemplates)]).*100000000;
    else
        %otherSc=(evaluateTempMatchHS2(validTemplates',taggedIndices(i),compsSideViewsAllBDLR2Dnsized,aaBDLR2,C)/30)
        %finalScores{i}=otherSc;
    end
end
toc
%finalScores=max(cell2mat(finalScores)');
fs=zeros(size(target));
%for i=1:length(fs)
%fs(i)=min(finalScores{i});
%end
%finalScores=fs;
tic
for i=1:length(taggedIndices)
    if newTaggedIndices(i)==0
        continue
    end
    for j=1:length(validTemplates)
        affMat(taggedIndices(i),validTemplates(j))=finalScores{i}(j);
    end
end
toc
%end