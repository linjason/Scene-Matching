function [d, indices, newIndices]=findDesksWithVoxelizing3DSimpVoxel()
load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags.mat')
load('comps3DSimpVoxPortionDnsized');
load('compsHeightViewsAll');

tic
j=0;
distToGround=zeros(0, 1);
sizes=zeros(0, 3);
distsToWalls=zeros(0, 4);
indices=zeros(0,1);
% clear comps;
for i=1:size(C,2)
    %if (~isempty(findstr('bed',lower(C{i}{7}))) || ~isempty(findstr('couch',lower(C{i}{7})))&& isempty(findstr('lateral',lower(C{i}{7}))) && isempty(findstr('head',lower(C{i}{7}))) && isempty(findstr('table',lower(C{i}{7}))) && isempty(findstr('frame',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('latte',lower(C{i}{7}))) && isempty(findstr('tv',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('pole',lower(C{i}{7}))))
    %if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
    if (~isempty(findstr('dresser',lower(C{i}{7}))) )&& isempty(findstr('lamp',lower(C{i}{7}))) && isempty(findstr('bed',lower(C{i}{7}))) && isempty(findstr('phone',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('vase',lower(C{i}{7}))) && isempty(findstr('chair',lower(C{i}{7})))&& isempty(findstr('light',lower(C{i}{7})))&& isempty(findstr('desktop',lower(C{i}{7})))
        
        sizesForComp = C{i}{4} - C{i}{3};
        if sizesForComp(3)<15 || sizesForComp(3)>50
            continue;
        end
        j=j+1;
        C{i};
        %         distToGround(j, 1)=C{i}{3}(3)-C{i}{5};
        %         distsToWalls(j, :)=C{i}{6};
        %         sizes(j, :)=C{i}{4}-C{i}{3};
        indices(j,1)=i;
    end
end

%indices(45)=[];%for couches
clear newBeds6;
newBeds6=cell(0,0);
indexIntoIndices=[1:size(indices, 1)];%[1 2 5 6 7 9 11 13 14 18 26 40 41 43 64 71 73 75 76 77 78 81 85 87 88 100 119 130 137];%[1:10 13:14 15:21 23:32 34 36 38 40:46 53 55 57 58 61];
taggedSimpVox=cell(0);
for i=1:size(indexIntoIndices,2)
    taggedSimpVox{i}=comps3DSimpVoxPortionDnsized{indices(indexIntoIndices(i))};
end
parfor i=1:size(C,2)
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2)
    height = sizesForComp(3);
    distFromGround=C{i}{3}(3)-C{i}{5};
    if (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>45 || xySorted(1)>60 || xySorted(2)>60 || distFromGround<20)
        %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
        continue;
    end
    i
    if isempty(comps3DSimpVoxPortionDnsized{i})
        continue;
    end
    scores=zeros(0);
    med=median(reshape(aa{i},1,[]));
    topScore=size(find(ismember(aa{i},[round(med)-2: round(med)+2])==1),1)/size(aa{i},1)/size(aa{i},2);
    if med<15
        topScore=0;
    end
    for j=1:size(indexIntoIndices,2)
        %                  resizedTemplate=imresize(aa{indices(indexIntoIndices(j))},[100 100]);
        %                 templateXY=C{indices(indexIntoIndices(j))}{4}-C{indices(indexIntoIndices(j))}{3};
        %                 templateArea=templateXY(2)*templateXY(1);
        %                 areaScore=-1.0*abs(1-templateArea/(sizesForComp(2)*sizesForComp(1)));
        
        oneSize=C{indices(indexIntoIndices(j))}{4}-C{indices(indexIntoIndices(j))}{3};
        compSize=C{i}{4}-C{i}{3};
        otherSize=compSize(1:2);
        otherSize2=fliplr(otherSize);
        oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
        otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
        oneScore2=-1.0*abs(1-(max(oneSize(2),otherSize2(2))/min(oneSize(2),otherSize2(2))));
        otherScore2=-1.0*abs(1-(max(oneSize(1),otherSize2(1))/min(oneSize(1),otherSize2(1))));
        
        oneScore;
        otherScore;
        oneScore2;
        otherScore2;
        % if (i==indices(j))
        %        scores=100000000;
        %        break;
        %    end
        
        [scores1,scores2,scores3,scores4]=compareTwoSimpVoxels(comps3DSimpVoxPortionDnsized{i},comps3DSimpVoxPortionDnsized{indices(indexIntoIndices(j))});
        scores(j,1)=scores1/exp((oneScore+otherScore)*1.2);
        scores(j,2)=scores2/exp((oneScore2+otherScore2)*1.2);
        scores(j,3)=scores3/exp((oneScore+otherScore)*1.2);
        scores(j,4)=scores4/exp((oneScore2+otherScore2)*1.2);
    end
    

    %if size(find(max(scores')>0.7),2)>0&&topScore>0.7
if size(find(min(scores')<2000),2)>0&&topScore>0.7 %7000 for desks
    
    C{i}
        newBeds6{i}{1}=comps3DSimpVoxPortionDnsized{i};
        newBeds6{i}{2}=scores;
        newBeds6{i}{3}=i;
    end
    
end
l=0;
toc
d=cell(0,0);
newIndices=zeros(0);
for i=1:size(newBeds6,2)
    if ~isempty(newBeds6{i})
        l=l+1;
        newIndices(l)=i;
        d{l}=newBeds6{i};
    end
end
