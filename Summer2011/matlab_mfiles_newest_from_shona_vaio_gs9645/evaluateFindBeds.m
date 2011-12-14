function [scores]=evaluateFindBeds(search, candidate)
load('compsHeightViewsAll');
load('bedrooms_2_with_dist_nametags');
i=candidate;
%parfor i=1:size(all,1)
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
  
    i
    %heightMap=make_obj_height_map(C{i}{1},C{i}{2});
    compsHeightViews=cell(8,1);
    compsHeightViews{1}=aa{i};%heightMap{C{i}{2}};
    if isempty(aa{i})
        disp('nooooooooooooooooo');
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
    for j=1:size(search,1)
                          resizedTemplate=imresize(aa{search(j)},[100 100]);
        %                 templateXY=C{indices(indexIntoIndices(j))}{4}-C{indices(indexIntoIndices(j))}{3};
        %                 templateArea=templateXY(2)*templateXY(1);
        %                 areaScore=-1.0*abs(1-templateArea/(sizesForComp(2)*sizesForComp(1)));
        for k=1:8
            k;
            %    scores(j,k)=corr2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))    *   exp(areaScore);
            %scores(j,k)=max(max(conv2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))));
            
            oneSize=size(aa{search(j)});
            otherSize=size(compsHeightViews{k});
            
            oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
            otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
            % scores(j,k)=min(min(template_matching(bb{j},compsHeightViews{k})))    / exp((oneScore+otherScore)*1.2);
            scores(j,k)=corr2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))    *   exp(oneScore+otherScore);
        end
    end
  scores=sort(max(scores'),'descend');
    if (xySorted(1)<20 || xySorted(2)<20 || height<29 || height>70 || xySorted(1)>110 || xySorted(2)>110)%for couch/sofa
        %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
        scores=0;
    end
end





