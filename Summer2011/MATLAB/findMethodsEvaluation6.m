tic
disp('wrg')
load('compsHeightViewsAllBDLR2');
load('compsSideViewsAll');
if ~exist('comps3DVoxPorBDLR2Dnsized','var')
    load('comps3DVoxPorBDLR2Dnsized')
end
load(['../../dataStructureForStatistics/bedrooms_livingrooms_2_with_dist_nametags']);
load('compsHeightViewsAllRsz');
load('compsSideViewsAllRsz');

for sliceIndex=56%[1:55 57:ceil(length(C)/200)]
    %56%[62:ceil(length(C)/200)]
    %56%[41:55 57:ceil(length(C)/200)]

    bedIndex=0;
    taggedIndex=0;
    bedIndices=zeros(0);
    taggedIndices=zeros(0);
    target=zeros(0);
    finalScores=cell(0);
    %affMat=zeros(length(C),length(C));


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
    bedIndices=[1+200*(sliceIndex-1):min(200*sliceIndex,length(C))]';
    1+200*(sliceIndex-1)
    min(200*sliceIndex,length(C))
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
    for k=1:4
        count=0;
        templateMat{k}=zeros(30*30*30,length(validTemplates));
        for j=1:length(validTemplates)
            if isempty(comps3DVoxPorBDLR2Dnsized{validTemplates(j)})
                disp('oh oh 10')
                continue;
            else
                comps3DRot=zeros(size(comps3DVoxPorBDLR2Dnsized{validTemplates(j)}));
                for l=1:size(comps3DVoxPorBDLR2Dnsized{validTemplates(j)},3)
                    comps3DRot(:,:,l)=rot90(comps3DVoxPorBDLR2Dnsized{validTemplates(j)}(:,:,l),k-1);
                end
                count=count+1;
                templateMat{k}(:,count) =   reshape(comps3DRot,[],1);
                %templateMat{k}(:,end+1) = [templateMat{k} reshape(comps3DRot,[],1)];
            end
        end
    end
    newTaggedIndices=zeros(size(taggedIndices));
    for i=1:length(taggedIndices)
        i;
        candidate=taggedIndices(i);
        sizesForComp = C{candidate}{4} - C{candidate}{3};
        xySorted = sort(sizesForComp(1:2), 2);
        height = sizesForComp(3);
        if isempty(comps3DVoxPorBDLR2Dnsized{candidate}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(comps3DVoxPorBDLR2Dnsized{candidate}) || isempty(aaBDLR2{candidate})
            if ~isempty(comps3DVoxPorBDLR2Dnsized{candidate}) && (xySorted(1)>=10 && xySorted(2)>=10 && height>13 && height<75 && xySorted(1)<=90 && xySorted(2)<=90)&&~isempty(comps3DVoxPorBDLR2Dnsized{candidate}) && ~isempty(aaBDLR2{candidate})
                i;
                newTaggedIndices(i)=1;
                 finalScores{i}=evaluateSimpVoxel2(validTemplates',taggedIndices(i),comps3DVoxPorBDLR2Dnsized,aaBDLR2,C,templateMat,validTemplates');
                %finalScores{i}=ones([1 length(validTemplates)]).*100000000;
            end    
        else
            %oneSc=evaluateSimpVoxel2(validTemplates',taggedIndices(i), comps3DVoxPorBDLR2Dnsized,aaBDLR2,C,templateMat,validTemplates');
            %otherSc=0;%(evaluateTempMatchHS2(validTemplates', taggedIndices(i),compsSideViewsAll,aa,C)/30)
            %finalScores{i}=oneSc+otherSc;
        end
    end
    sum(newTaggedIndices)
    %parfor i=[]%1:size(taggedIndices,1)
    %    candidate=taggedIndices(i);
    %    sizesForComp = C{candidate}{4} - C{candidate}{3};
    %    xySorted = sort(sizesForComp(1:2), 2);
    %    height = sizesForComp(3);
    %    scores=zeros(0,4);
    %    if isempty(comps3DVoxPorBDLR2Dnsized{candidate}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(comps3DVoxPorBDLR2Dnsized{candidate}) || isempty(aaBDLR2{candidate})
    %        finalScores{i}=ones([1 length(validTemplates)]).*100000000;
    %    else
    %        finalScores{i}=abs(finalScores{i}./(evaluateCorr2HSImresz2(validTemplates',taggedIndices(i),compsSideViewsAllRsz,aaRsz,C)));
    %    end
    %end
    toc
    %finalScores=max(cell2mat(finalScores)');
    fs=zeros(size(target));
    %for i=1:length(fs)
    %fs(i)=min(finalScores{i});
    %end
    %finalScores=fs;
    disp('c')
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
end