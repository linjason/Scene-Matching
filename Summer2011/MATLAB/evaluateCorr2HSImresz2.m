function [scores]=evaluateCorr2HSImresz2(search, candidate,compsSideViewsAllRsz,aaRsz,aa,C)
%    load('compsHeightViewsAllRsz');
%    load('compsSideViewsAllRsz');
%    load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags');
    i=candidate;
    %sizesForComp = C{i}{4} - C{i}{3};
    %xySorted = sort(sizesForComp(1:2), 2);
    %height = sizesForComp(3);
    i;
    if 0%isempty(aaRsz{i}) || (xySorted(1)<10 || xySorted(2)<10 || height<13 || height>75 || xySorted(1)>90 || xySorted(2)>90) || isempty(compsSideViewsAllRsz{i})
        disp('uh oh 4');
        scores=0;
    else
        scores=zeros(0,0);
        for j=1:length(search)
            if isempty(compsSideViewsAllRsz{search(j)}) || isempty(aaRsz{search(j)})
                disp('ssssssssssssssssssss!!!!!!!!!!!!!!!!!!!!!!!!!');
                scores(j,:)=[0 0 0 0];
                continue;
            end
            %resizedTemplate=imresize(aaRsz{search(j)},[100 100]);
            oneSize=size(aa{search(j)});
            otherSize=size(aa{i});
            otherSize2=size(rot90(aa{i},1));
            oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
            otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
            oneScore2=-1.0*abs(1-(max(oneSize(2),otherSize2(2))/min(oneSize(2),otherSize2(2))));
            otherScore2=-1.0*abs(1-(max(oneSize(1),otherSize2(1))/min(oneSize(1),otherSize2(1))));
            subScores=zeros(4,4);
            for k=1:4
                for l=1:4
                    subScores(k,l)=max(max(corr2(compsSideViewsAllRsz{search(j)}{k}, compsSideViewsAllRsz{i}{l})));
                end
            end
            scores(j,1)=((subScores(1,1)+subScores(2,2)+subScores(3,3)+subScores(4,4))/4+max(max(corr2(aaRsz{search(j)},aaRsz{i}))))*exp((oneScore+otherScore)*1.2);
            scores(j,2)=((subScores(1,2)+subScores(2,3)+subScores(3,4)+subScores(4,1))/4+max(max(corr2(aaRsz{search(j)},rot90(aaRsz{i},1)))))*exp((oneScore2+otherScore2)*1.2);
            scores(j,3)=((subScores(1,3)+subScores(2,4)+subScores(3,1)+subScores(4,2))/4+max(max(corr2(aaRsz{search(j)},rot90(aaRsz{i},2)))))*exp((oneScore+otherScore)*1.2);
            scores(j,4)=((subScores(1,4)+subScores(2,1)+subScores(3,2)+subScores(4,3))/4+max(max(corr2(aaRsz{search(j)},rot90(aaRsz{i},3)))))*exp((oneScore2+otherScore2)*1.2);
            if search(j)==candidate
                scores(j,:)=[0 0 0 0];
            end
        end
        scores=max(scores');
    end    
    %if (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>65 || xySorted(2)>65)
    %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
    %       scores=0;
    %  end
    % if isempty(aaRsz{i}) || isempty(compsSideViewsAllRsz{i})
    % scores=0;
    % end
end





