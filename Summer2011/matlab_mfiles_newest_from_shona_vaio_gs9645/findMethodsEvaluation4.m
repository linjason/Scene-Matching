tic
disp('wrg')
%load('compsHeightViewsAllBDLR2');
%load('compsSideViewsAll');
%load('comps3DVoxPorBDLR2Dnsized')
load(['../../dataStructureForStatistics/bedrooms_livingrooms_2_hotel_withSMALL_BDLR3_with_dist_nametags.mat']);
%load('compsHeightViewsAllRsz');
%if ~exist('compsSideViewsAllRsz','var'), load('compsSideViewsAllRsz'); end
%load ('validCompsBDLR2');
%load('affMat');
%if ~exist('affMatCorr2BDLR2','var'), load('affMatCorr2BDLR22'); end
%if ~exist('affMatSimpVoxBDLR2','var'), load('affMatSimpVoxBDLR22'); end
if ~exist('affMatSimpVoxBDLR23HT','var'), load('affMatSimpVoxBDLR23HT'); end
if ~exist('affMatTMBDLR23HT','var'), load('affMatTMBDLR23HT'); end
if ~exist('affMatCorr2BDLR23HT','var'), load('affMatCorr2BDLR23HT'); end

%if ~exist('affMatTempMatchBDLR2','var'), load('affMatTempMatchBDLR22'); end
%affMatSimpVoxBDLR2=affMat;
%affMat=sparse(affMat);
bedIndex=0;
taggedIndex=0;
bedIndices=zeros(0);
taggedIndices=zeros(0);
target=zeros(0);
finalScoresCell=cell(0);

for k=1:length(necessaryIndices)
    i=necessaryIndices(k);
    strings={'bed','light','window','door','speaker','lamp','table','pillow','books','desk','arm','tv','vase','ceiling','drawer','man','cabinet','dresser','computer','joist','sink','sink','frame','box','toilet','couch','nightstand','sconce','mecate','handle','clock','curtain','blinds','plant','mirror','flatscreen','dining','rug','wardrobe','doorknob','phone','phone','estructura','sofa','guitar','chest','armoire','picture','stool','bathroom','laptop','basket','fan','apple','binder','bookcase','candle','carpet','print','heater','mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote','stand','night','nighttable','bedside','side','armoire','armadio','armario','room','leg','chair','mesa','mesita','shelf'};
    a=0;
    for j=1:length(strings)
        if 1%~isempty(strfind(lower(C{i}{7}),strings{j}))
            taggedIndex=taggedIndex+1;
            taggedIndices(taggedIndex,1)=k;
            a=1;
            break;
        else
            continue
        end
    end
    if (~isempty(strfind(lower(C{i}{7}),'dresser'))||~isempty(strfind(lower(C{i}{7}),'111armoire'))||~isempty(strfind(lower(C{i}{7}),'armadio'))||~isempty(strfind(lower(C{i}{7}),'111armario'))||~isempty(strfind(lower(C{i}{7}),'111wardrobe')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'room'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    %if ((~isempty(strfind(lower(C{i}{7}),'bed')) || ~isempty(strfind(lower(C{i}{7}),'couch'))|| ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'lateral')) && isempty(strfind(lower(C{i}{7}),'head')) && isempty(strfind(lower(C{i}{7}),'table')) && isempty(strfind(lower(C{i}{7}),'frame')) && isempty(strfind(lower(C{i}{7}),'room')) && isempty(strfind(lower(C{i}{7}),'latte')) && isempty(strfind(lower(C{i}{7}),'tv')) && isempty(strfind(lower(C{i}{7}),'leg')) && isempty(strfind(lower(C{i}{7}),'pole')))
    % if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
    %if (~isempty(strfind(lower(C{i}{7}),'nightstand')) ||~isempty(strfind(lower(C{i}{7}),'night stand'))||~isempty(strfind(lower(C{i}{7}),'nighttable'))||~isempty(strfind(lower(C{i}{7}),'night table'))||~isempty(strfind(lower(C{i}{7}),'bedside'))) && isempty(strfind(lower(C{i}{7}),'lamp')) && isempty(strfind(lower(C{i}{7}),'pole')) && isempty(strfind(lower(C{i}{7}),'pole')) && isempty(strfind(lower(C{i}{7}),'dresser')) && isempty(strfind(lower(C{i}{7}),'convertable'))
    %if (~isempty(strfind(lower(C{i}{7}),'drawer'))||~isempty(strfind(lower(C{i}{7}),'drawer')))&&isempty(strfind(lower(C{i}{7}),'lamp'))&&isempty(strfind(lower(C{i}{7}),'bed'))&&isempty(strfind(lower(C{i}{7}),'leg'))&&isempty(strfind(lower(C{i}{7}),'light'))&&isempty(strfind(lower(C{i}{7}),'convertable'))&&isempty(strfind(lower(C{i}{7}),'phone'))&&isempty(strfind(lower(C{i}{7}),'deska'))&&isempty(strfind(lower(C{i}{7}),'desktop'))
         if a==0
            disp('235252435');
        end
        bedIndex=bedIndex+1;
        C{i};
        bedIndices(bedIndex,1)=k;
        target(taggedIndex)=1;
    end
end
compareAgainst=bedIndices;
target(size(target,2)+1:taggedIndex)=0;
j=0;
validTemplates=zeros(0);
templateMat=cell(4);
%{
for j=1:length(bedIndices)
    %    if ~isempty(comps3DVoxPorBDLR2Dnsized{bedIndices(j)})
    if ~isempty(find(validCompsBDLR2==bedIndices(j)))
        validTemplates(end+1)=bedIndices(j);
    end
end
for k=1:4
    templateMat{k}=zeros(0,0);
    for j=1:length(validTemplates)
        if isempty(comps3DVoxPorBDLR2Dnsized{validTemplates(j)})
            continue;
        else
            comps3DRot=zeros(size(comps3DVoxPorBDLR2Dnsized{validTemplates(j)}));
            for l=1:size(comps3DVoxPorBDLR2Dnsized{validTemplates(j)},3)
                comps3DRot(:,:,l)=rot90(comps3DVoxPorBDLR2Dnsized{validTemplates(j)}(:,:,l),k-1);
            end
            templateMat{k} = [templateMat{k} reshape(comps3DRot,[],1)];
        end
    end
end
%}
validTemplates=bedIndices;
for i=i:6
finalScoresCell{i}=zeros(length(taggedIndices),length(validTemplates));
end
%{
parfor i=[]%1:size(taggedIndices,1)
    candidate=taggedIndices(i);
    sizesForComp = C{candidate}{4} - C{candidate}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    if isempty(find(validCompsBDLR2==candidate)) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(aaBDLR2{candidate})
        finalScores{i}=ones([1 length(validTemplates)]).*100000000;
    else
        oneSc=evaluateSimpVoxel2(validTemplates',taggedIndices(i),comps3DVoxPorBDLR2Dnsized,aaBDLR2,C,templateMat,validTemplates');
        %oneSc=affMat(candidate,validTemplates);
        %otherSc=(evaluateTempMatchHS2(validTemplates', taggedIndices(i),compsSideViewsAll,aa,C)/30)
        
        finalScores{i}=oneSc;
    end
end
%}
validCompsHere=zeros(0);
validCompsHereNot=zeros(0);
for i=1:size(taggedIndices,1)
    candidate=taggedIndices(i);
    %sizesForComp = C{candidate}{4} - C{candidate}{3};
    %xySorted = sort(sizesForComp(1:2), 2);
    %height = sizesForComp(3);
    if 0%isempty(find(validCompsBDLR2==candidate)) || (xySorted(1)<10 || xySorted(2)<10 || height<13 || height>75 || xySorted(1)>90 || xySorted(2)>90) || isempty(aaBDLR2{candidate})
        %finalScores{i}=ones([1 length(validTemplates)]).*0;%100000000;
    validCompsHereNot(end+1)=i;
    else
        %finalScores{i}=abs(finalScores{i}./(evaluateCorr2HSImresz2(validTemplates',taggedIndices(i),compsSideViewsAllRsz,aaRsz,C)));
        % finalScores{i}=abs((evaluateCorr2HSImresz2(validTemplates',taggedIndices(i),compsSideViewsAllRsz,aaRsz,C)));
        %finalScores{i}=affMatCorr2BDLR2(candidate,validTemplates);
        validCompsHere(end+1)=i;
 end
end
toc

for i=1:5
finalScoresCell{i}(validCompsHereNot,:)=ones([length(validCompsHereNot) length(validTemplates)]).*100000000;
end
finalScoresCell{6}(validCompsHereNot,:)=ones([length(validCompsHereNot) length(validTemplates)]).*0;

finalScoresCell{6}(validCompsHere,:)=affMatCorr2BDLR23HT(taggedIndices(validCompsHere),validTemplates);
finalScoresCell{1}(validCompsHere,:)=affMatSimpVoxBDLR23HT(taggedIndices(validCompsHere),validTemplates);
finalScoresCell{2}(validCompsHere,:)=affMatTMBDLR23HT(taggedIndices(validCompsHere),validTemplates);
finalScoresCell{3}(validCompsHere,:)=affMatSimpVoxBDLR23HT(taggedIndices(validCompsHere),validTemplates)./abs(affMatCorr2BDLR23HT(taggedIndices(validCompsHere),validTemplates));
finalScoresCell{4}(validCompsHere,:)=affMatTMBDLR23HT(taggedIndices(validCompsHere),validTemplates)./abs(affMatCorr2BDLR23HT(taggedIndices(validCompsHere),validTemplates));
finalScoresCell{5}(validCompsHere,:)=(affMatSimpVoxBDLR23HT(taggedIndices(validCompsHere),validTemplates)+affMatTMBDLR23HT(taggedIndices(validCompsHere),validTemplates))./abs(affMatCorr2BDLR23HT(taggedIndices(validCompsHere),validTemplates));

%finalScores=max(cell2mat(finalScores)');
figure
fs=cell(0);
for j=1:6
    fs{j}=zeros(size(target));
    for i=1:length(fs{j})
        if ismember(j, 1:5)
            fs{j}(i)=min(finalScoresCell{j}(i,:));
        else
            fs{j}(i)=max(finalScoresCell{j}(i,:));
        end
    end
    finalScores=fs{j};
    hold on
    plotColor=j;
    if ismember(j, 1:5)
        pr
    else
        pr2
    end
end