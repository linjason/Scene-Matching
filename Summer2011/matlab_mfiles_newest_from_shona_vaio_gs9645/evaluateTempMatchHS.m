function [scores]=evaluateTempMatchHS(search, candidate, compsSideViewsAll, aa, C)
%load('compsHeightViewsAll');
%load('compsSideViewsAll');
%load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags');
    i=candidate;
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    i
    if isempty(aa{i}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(compsSideViewsAll{i})
        scores=100000000;
    else
        scores=zeros(0,0);
        for j=1:size(search,1)
            if isempty(compsSideViewsAll{search(j)})
                disp('ssssssssssssssssssss!!!!!!!!!!!!!!!!!!!!!!!!!');
            end
            %resizedTemplate=imresize(aa{search(j)},[100 100]);
            oneSize=size(aa{search(j)});
            otherSize=size(aa{i});
            otherSize2=size(rot90(aa{i},1));oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
            otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
            oneScore2=-1.0*abs(1-(max(oneSize(2),otherSize2(2))/min(oneSize(2),otherSize2(2))));
            otherScore2=-1.0*abs(1-(max(oneSize(1),otherSize2(1))/min(oneSize(1),otherSize2(1))));
            subScores=zeros(4,4);
            for k=1:4
                for l=1:4
                    subScores(k,l)=min(min(template_matching(compsSideViewsAll{search(j)}{k}, compsSideViewsAll{i}{l})));
                end
            end
            scores(j,1)=((subScores(1,1)+subScores(2,2)+subScores(3,3)+subScores(4,4))/4+min(min(template_matching(aa{search(j)},aa{i}))))/exp((oneScore+otherScore)*1.2);
            scores(j,2)=((subScores(1,2)+subScores(2,3)+subScores(3,4)+subScores(4,1))/4+min(min(template_matching(aa{search(j)},rot90(aa{i},1)))))/exp((oneScore2+otherScore2)*1.2);
            scores(j,3)=((subScores(1,3)+subScores(2,4)+subScores(3,1)+subScores(4,2))/4+min(min(template_matching(aa{search(j)},rot90(aa{i},2)))))/exp((oneScore+otherScore)*1.2);
            scores(j,4)=((subScores(1,4)+subScores(2,1)+subScores(3,2)+subScores(4,3))/4+min(min(template_matching(aa{search(j)},rot90(aa{i},3)))))/exp((oneScore2+otherScore2)*1.2);
        end
        scores=sort(min(scores'),'descend');
    end
end
