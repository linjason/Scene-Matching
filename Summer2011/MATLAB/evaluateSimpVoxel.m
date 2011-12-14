function [scores]=evaluateSimpVoxel(search, candidate, comps3DVoxPorDnsized, aa,C,preComputedTemplateMat, preComputedSearch)
%load('compsHeightViewsAll');
% load('comps3DVoxPorDnsized')
%    load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags');
    i=candidate;
    sizesForComp = C{i}{4} - C{i}{3};
    xySorted = sort(sizesForComp(1:2), 2);
    height = sizesForComp(3);
    scores=zeros(0,4);
    i;
    if isempty(comps3DVoxPorDnsized{i}) || (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>90 || xySorted(2)>90) || isempty(comps3DVoxPorDnsized{i}) || isempty(aa{i})
        scores=100000000;
    else
        validTemplates=0;
        for j=1:size(search,1)
            if ~isempty(comps3DVoxPorDnsized{search(j)})
                validTemplates=validTemplates+1;
            end
        end
        scores=zeros(validTemplates,4);
        for k=1:4   
            templateMat=zeros(0,0);
            if ~1%isequal(preComputedSearch,search)
                templateMat=preComputedTemplateMat{k};
                disp('goog')            
            else
                for j=1:size(search,1)
                    if isempty(comps3DVoxPorDnsized{search(j)})
                        continue;
                    else
                        comps3DRot=zeros(size(comps3DVoxPorDnsized{search(j)}));
                        for l=1:size(comps3DVoxPorDnsized{search(j)},3)
                            comps3DRot(:,:,l)=rot90(comps3DVoxPorDnsized{search(j)}(:,:,l),k-1);
                        end
                        templateMat = [templateMat  reshape(comps3DRot,[],1)];
                    end
                end
            end    
            candMat=repmat(reshape(comps3DVoxPorDnsized{i},[],1), [1 size(templateMat,2)]);
            ss=sum((candMat-templateMat).^2)';
            if validTemplates~=size(templateMat,2)
                disp('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee')
            end
            scores(:,k)=ss;
        end


        ind=0;
        for j=1:size(search,1)
            if isempty(comps3DVoxPorDnsized{search(j)})
                continue;
            else
                ind=ind+1;
                oneSize=size(aa{search(j)});
                otherSize=size(aa{i});
                otherSize2=size(rot90(aa{i},1));
                oneScore=-1.0*abs(1-(max(oneSize(2),otherSize(2))/min(oneSize(2),otherSize(2))));
                otherScore=-1.0*abs(1-(max(oneSize(1),otherSize(1))/min(oneSize(1),otherSize(1))));
                oneScore2=-1.0*abs(1-(max(oneSize(2),otherSize2(2))/min(oneSize(2),otherSize2(2))));
                otherScore2=-1.0*abs(1-(max(oneSize(1),otherSize2(1))/min(oneSize(1),otherSize2(1))));
                
                %subScores=zeros(4,4);
                % [scores1,scores2,scores3,scores4]=compareTwoSimpVoxels(comps3DVoxPorDnsized{i},comps3DVoxPorDnsized{search(j)});
                %scores(j,1)=scores1/exp((oneScore+otherScore)*1.2);
                %scores(j,2)=scores2/exp((oneScore2+otherScore2)*1.2);
                %scores(j,3)=scores3/exp((oneScore+otherScore)*1.2);
                %scores(j,4)=scores4/exp((oneScore2+otherScore2)*1.2);
                scores(ind,1)=scores(ind,1)./exp((oneScore+otherScore)*1.2);
                scores(ind,2)=scores(ind,2)./exp((oneScore2+otherScore2)*1.2);
                scores(ind,3)=scores(ind,3)./exp((oneScore+otherScore)*1.2);
                scores(ind,4)=scores(ind,4)./exp((oneScore2+otherScore2)*1.2);
            end
        end
        if validTemplates~=ind
            disp('2352wergrrrwergwergwergwergwergwerg34')
        end
        scores=sort(min(scores'),'descend');
        %nightstand
        %if (xySorted(1)<10 || xySorted(2)<10 || height<15 || height>50 || xySorted(1)>65 || xySorted(2)>65)
        %if ~(xySorted(1)>32 && xySorted(1)<90 && xySorted(2)<90 && xySorted(2)>50 && C{i}{3}(3)-C{i}{5} < 12 && height>20) || ~isempty(find(indices==i))
        %   scores=100000000;
        %end
        %if isempty(aa{i}) || isempty(comps3DVoxPorDnsized{i})
        %    scores=100000000;
        %end
    end        





