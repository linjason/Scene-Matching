function [d, indices, newIndices]=findDressersWithVoxelizing()
load('compsSideViewsAll')
load('compsHeightViewsAll')
load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags.mat')

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
    if (~isempty(findstr('dresser',lower(C{i}{7}))) || ~isempty(findstr('dresser',lower(C{i}{7})))) && isempty(findstr('lamp',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('bed',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('convertable',lower(C{i}{7})))
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
indexIntoIndices=1:size(indices, 1);%[1 2 5 6 7 9 11 13 14 18 26 40 41 43 64 71 73 75 76 77 78 81 85 87 88 100 119 130 137];%[1:10 13:14 15:21 23:32 34 36 38 40:46 53 55 57 58 61];
tagged=cell(0,0);
taggedHeightView=zeros(0);
for i=1:size(indexIntoIndices,2)
    tagged{i}=compsSideViewsAll{indices(indexIntoIndices(i))};
    taggedHeightView{i}=aa{indices(indexIntoIndices(i))};
end
parfor i=1:size(C,2)
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2)
    height = sizesForComp(3);
    if   (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>60 || xySorted(2)>60)%for couch/sofa
        %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
        continue;
    end
    i
    if isempty(compsSideViewsAll{i})
        continue;
    end
    scores=zeros(0);
    
    
    for j=1:size(indexIntoIndices,2)
        %                  resizedTemplate=imresize(aa{indices(indexIntoIndices(j))},[100 100]);
        %                 templateXY=C{indices(indexIntoIndices(j))}{4}-C{indices(indexIntoIndices(j))}{3};
        %                 templateArea=templateXY(2)*templateXY(1);
        %                 areaScore=-1.0*abs(1-templateArea/(sizesForComp(2)*sizesForComp(1)));
        oneSize=size(taggedHeightView{j});
        otherSize=size(aa{i});
        otherSize2=size(rot90(aa{i},1));
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
        subScores=zeros(4,4)
        for k=1:4
            for l=1:4
                subScores(k,l)=max(max(corr2(imresize(tagged{j}{k},[100 100]), imresize(compsSideViewsAll{i}{l},[100 100]))))
            end
        end
        subScores;
        scores(j,1)=((subScores(1,1)+subScores(2,2)+subScores(3,3)+subScores(4,4))/4+max(max(corr2(imresize(taggedHeightView{j},[100 100]),imresize(aa{i},[100 100])))))*exp((oneScore+otherScore)*1.2)
        scores(j,2)=((subScores(1,2)+subScores(2,3)+subScores(3,4)+subScores(4,1))/4+max(max(corr2(imresize(taggedHeightView{j},[100 100]),imresize(rot90(aa{i},1),[100 100])))))*exp((oneScore2+otherScore2)*1.2)
        scores(j,3)=((subScores(1,3)+subScores(2,4)+subScores(3,1)+subScores(4,2))/4+max(max(corr2(imresize(taggedHeightView{j},[100 100]),imresize(rot90(aa{i},2),[100 100])))))*exp((oneScore+otherScore)*1.2)
        scores(j,4)=((subScores(1,4)+subScores(2,1)+subScores(3,2)+subScores(4,3))/4+max(max(corr2(imresize(taggedHeightView{j},[100 100]),imresize(rot90(aa{i},3),[100 100])))))*exp((oneScore2+otherScore2)*1.2)
        scores;
    end
    max(max(corr2(imresize(taggedHeightView{j},[100 100]), imresize(rot90(aa{i},2),[100 100]))));
    if size(find(max(scores')>1.15),2)>0
        %if size(find(max(scores')>0.6),2)>0
        C{i}
        newBeds6{i}{1}=compsSideViewsAll{i};
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