function [d, indices, newIndices]=findBedsWithVoxelizing()
load('compsSideViewsAll')
load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags.mat')
load('compsHeightViewsAll')

tic
j=0;
distToGround=zeros(0, 1);
sizes=zeros(0, 3);
distsToWalls=zeros(0, 4);
indices=zeros(0,1);
% clear comps;
for i=1:size(C,2)
    if ((~isempty(findstr('sofa',lower(C{i}{7}))) || ~isempty(findstr('bed',lower(C{i}{7}))) || ~isempty(findstr('couch',lower(C{i}{7})))) && isempty(findstr('lateral',lower(C{i}{7}))) && isempty(findstr('head',lower(C{i}{7}))) && isempty(findstr('table',lower(C{i}{7}))) && isempty(findstr('frame',lower(C{i}{7}))) && isempty(findstr('room',lower(C{i}{7}))) && isempty(findstr('latte',lower(C{i}{7}))) && isempty(findstr('tv',lower(C{i}{7}))) && isempty(findstr('leg',lower(C{i}{7}))) && isempty(findstr('pole',lower(C{i}{7}))))
        %if ((~isempty(strfind(lower(C{i}{7}),'couch')) || ~isempty(strfind(lower(C{i}{7}),'sofa')))&& isempty(strfind(lower(C{i}{7}),'bed'))&& isempty(strfind(lower(C{i}{7}),'table'))&& isempty(strfind(lower(C{i}{7}),'room'))&& isempty(strfind(lower(C{i}{7}),'frame'))&& isempty(strfind(lower(C{i}{7}),'down')))
        j=j+1;
        C{i};
        %         heightMap=make_obj_height_map(C{i}{1},C{i}{2});
        %         compsHeightView{j}=heightMap{C{i}{2}};
        %         distToGround(j, 1)=C{i}{3}(3)-C{i}{5};
        %         distsToWalls(j, :)=C{i}{6};
        %         sizes(j, :)=C{i}{4}-C{i}{3};
        indices(j,1)=i;
    end
end

%indices(45)=[];%for couches
bedIndex=0;
clear newBeds6;
newBeds6=cell(0,0);
indexIntoIndices=1:size(indices, 1);%[1 2 5 6 7 9 11 13 14 18 26 40 41 43 64 71 73 75 76 77 78 81 85 87 88 100 119 130 137];
bb=cell(0,0);
for i=1:size(indexIntoIndices,2)
    bb{i}=aa{indices(indexIntoIndices(i))};
end
parfor i=1:size(C,2)
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    if (~isempty(find(indices==i))) || (xySorted(1)<20 || xySorted(2)<20 || height<29 || height>70 || xySorted(1)>110 || xySorted(2)>110)%for couch/sofa
        %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
        continue;
    end
    i
    %heightMap=make_obj_height_map(C{i}{1},C{i}{2});
    compsHeightViews=cell(8,1);
    compsHeightViews{1}=aa{i};%heightMap{C{i}{2}};
    if isempty(aa{i})
        continue;
    end
    compsHeightViews{2}=fliplr(compsHeightViews{1});
    compsHeightViews{3}=flipud(compsHeightViews{1});
    compsHeightViews{4}=rot90(compsHeightViews{1},2);
    compsHeightViews{5}=fliplr(compsHeightViews{1}');
    compsHeightViews{6}=flipud(compsHeightViews{1}');
    compsHeightViews{7}=rot90(compsHeightViews{1}',2);
    compsHeightViews{8}=compsHeightViews{1}';
    scores=zeros(0,8);
    
    %indexIntoIndices=1:size(indices,1);%[1:10 13:14 15:21 23:32 34 36 38
    %40:46 53 55 57 58 61];%%[1 2 5 6 7 9 11 13 14 18 26 40 41 43 64 71 73 75 76 77 78 81 85 87 88 100 119 130 137];
    for j=1:size(indexIntoIndices,2)
                          resizedTemplate=imresize(aa{indices(indexIntoIndices(j))},[100 100]);
        %                 templateXY=C{indices(indexIntoIndices(j))}{4}-C{indices(indexIntoIndices(j))}{3};
        %                 templateArea=templateXY(2)*templateXY(1);
        %                 areaScore=-1.0*abs(1-templateArea/(sizesForComp(2)*sizesForComp(1)));
        for k=1:8
            k;
            %    scores(j,k)=corr2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))    *   exp(areaScore);
            %scores(j,k)=max(max(conv2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))));
            
            oneSize=size(bb{j});
            otherSize=size(compsHeightViews{k});
            
            oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
            otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
            % scores(j,k)=min(min(template_matching(bb{j},compsHeightViews{k})))    / exp((oneScore+otherScore)*1.2);
            scores(j,k)=corr2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))    *   exp(oneScore+otherScore);
        end
    end
    %min(min(scores'))
    %    if size(find(min(scores')<120000),2)>2
        if size(find(max(scores')>0.5),2)>1
        %min(min(scores'))
        %if(max(max(scores))>0.5)%(score1>0.5||score2>0.5||score3>0.5||score4>0.5||score5>0.5||score6>0.5||score7>0.5||score8>0.5))
        %bedIndex=bedIndex+1
        C{i}
        i;
        newBeds6{i}{1}=compsHeightViews{1};
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