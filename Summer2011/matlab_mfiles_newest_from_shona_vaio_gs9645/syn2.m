% clear syn;
% syn=cell(0);
% j=0;
% for i=1:length(finalScores)
%     i;
%     if ~isequal(finalScores{i}(1),Inf)
%         j=j+1;
%         syn{j}{1}=C{taggedIndices(i)}{7};
%         syn{j}{2}=taggedIndices(i);
%         l=0;
%         sortedInfo=sortrows([abs(finalScores{i}') validTemplates'],1);
%         for k=1:200
%             if sortedInfo(k,2)==taggedIndices(i)
%                 continue
%             else
%                 l=l+1;
%                 syn{j}{3*l}=C{sortedInfo(k,2)}{7};
%                 syn{j}{3*l+1}=sortedInfo(k,2);
%                 syn{j}{3*l+2}=sortedInfo(k,1);
%             end
%         end
%     end
% end
% allResults=zeros(0,3);
% aRIndex=0;
% for i=1:length(syn)
%     for j=3*[1:180]
%         aRIndex=aRIndex+1;
%         allResults(aRIndex,1)=syn{i}{2};
%         allResults(aRIndex,2)=syn{i}{j+1};
%         allResults(aRIndex,3)=syn{i}{j+2};
%     end
% end
% tic
% sortedResults=sortrows(allResults,3);
% sortedNames=cell(0);
% parfor i=1:length(sortedResults)
%     sortedNames{i}{1}=C{sortedResults(i,1)}{7};
%     sortedNames{i}{2}=C{sortedResults(i,2)}{7};
%     sortedNames{i}{3}=sortedResults(i,3);
% end
% toc
% convertion=zeros(0);
% for i=1:length(syn)
%     for k=[2 1.+3*[1:180]]
%         if ~ismember(syn{i}{k},convertion)
%             convertion(end+1)=syn{i}{k};
%         end
%     end
% end
% %
% %
% % A=zeros(length(convertion),length(convertion));
% % for i=1:size(allResults,1)
% %     A(find(convertion==allResults(i,1)),find(convertion==allResults(i,2)))=allResults(i,3);
% % end
% %
% % for i=1:size(A,1)
% %     for j=1:size(A,2)
% %         if i==j
% %             A(i,j)=0;
% %         else
% %             if A(i,j)==0 && A(j,i)~=0
% %                 A(i,j)=A(j,i);
% %             elseif A(j,i)==0 && A(i,j)~=0
% %                 A(j,i)=A(i,j);
% %             end
% %         end
% %     end
% % end

eval=zeros(0,3);
for num_cl=20
    sc_num=0;
    num_tagged=0;
    num_runs=1;
    for run=1:num_runs
        [cluster_labels evd_time kmeans_time total_time] = sc(affMat3, 0, num_cl);
        names2=cell(0);
        for i=1:num_cl
            nm=new(find(cluster_labels==i));
            for j=1:length(nm)
                names2{i}{j}=C{nm(j)}{7};
            end
        end
        evaluateClustering;
        sc_num=sc_num+sco/num_cl;
        num_tagged=num_tagged+numTagged;
    end
    eval(end+1,1)=sc_num/num_runs
    eval(end,2)=num_tagged/num_runs
    eval(end,3)=num_cl
end