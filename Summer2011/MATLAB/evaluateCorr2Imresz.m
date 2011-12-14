function [scores]=evaluateCorr2Imresz(search, candidate, aaRsz)
%    load('compsHeightViewsAllRsz');
    load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags');
    i=candidate;
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    i
    %heightMap=make_obj_height_map(C{i}{1},C{i}{2});
    compsHeightViews=cell(8,1);
    compsHeightViews{1}=aaRsz{i};%heightMap{C{i}{2}};
    if isempty(aaRsz{i})
        disp('nooooooooooooooooo');
        scores=0;
    else
        compsHeightViews{2}=fliplr(compsHeightViews{1});
        compsHeightViews{3}=flipud(compsHeightViews{1});
        compsHeightViews{4}=rot90(compsHeightViews{1},2);
        compsHeightViews{5}=fliplr(compsHeightViews{1}');
        compsHeightViews{6}=flipud(compsHeightViews{1}');
        compsHeightViews{7}=rot90(compsHeightViews{1}',2);
        compsHeightViews{8}=compsHeightViews{1}';
        scores=zeros(0,8);
        for j=1:size(search,1)
            resizedTemplate=aaRsz{search(j)};
            %                 templateXY=C{indices(indexIntoIndices(j))}{4}-C{indices(indexIntoIndices(j))}{3};
            %                 templateArea=templateXY(2)*templateXY(1);
            %                 areaScore=-1.0*abs(1-templateArea/(sizesForComp(2)*sizesForComp(1)));
            if isempty(resizedTemplate)
                scores(j,:)=[0 0 0 0 0 0 0 0];
            else
                for k=1:8
                    k;
                    %    scores(j,k)=corr2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))    *   exp(areaScore);
                    %scores(j,k)=max(max(conv2(resizedTemplate,imresize(compsHeightViews{k},[100 100]))));
                    if ismember(k, [1 2 3 4])           
                        oneSize=sizesForComp([1:2]);
                    else
                        oneSize=fliplr(sizesForComp([1:2]));
                    end  
                    otheSize=C{search(j)}{4}-C{search(j)}{3};
                    otherSize=otheSize([1:2]);
                    oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
                    otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
                    % scores(j,k)=min(min(template_matching(bb{j},compsHeightViews{k})))    / exp((oneScore+otherScore)*1.2);
                    scores(j,k)=corr2(resizedTemplate,compsHeightViews{k})    *   exp(oneScore+otherScore);
                end
            end
        end    
        scores=sort(max(scores'),'descend');
        if (xySorted(1)<25 || xySorted(2)<15 || height<15 || height>70 || xySorted(1)>110 || xySorted(2)>110)%for couch/sofa
                                                                                                             %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
            scores=0;
        end
    end
end




