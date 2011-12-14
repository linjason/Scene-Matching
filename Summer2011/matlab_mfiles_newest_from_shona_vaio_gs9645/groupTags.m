affMatNoDiag=affMat;
for i=1:size(affMat,1)
    affMatNoDiag(i,i)=0;
end
newTags=cell(0);
for k=1:length(allTags)
    newTags{k}{1}=allTags{k};
end 
m=affMatNoDiag;
for rep=1:400
rep;
max(max(m))
 [i,j]=ind2sub(size(m),find(m==max(max(m))));
i=i(1);
j=j(1);
 % i=2;
% j=4;
% m=[0 1 3 6;2 0 0 0;0 4 0 0;0 8 5 0;]


indi=sort([i j]);
i=indi(1);
j=indi(2);
n=m;
n(:,i)=m(:,i)+m(:,j);
n(i,:)=m(i,:)+m(j,:);
n(j,:)=[];
n(:,j)=[];
for k=1:size(n,2)
    n(k,k)=0;
end

for k=1:length(newTags{j})
newTags{i}{end+1}=newTags{j}{k};
end
newTags{i}
for k=j:length(newTags)-1
    newTags{k}=newTags{k+1};
end
newTags2=cell(0);
for k=1:size(newTags,2)-1
    newTags2{k}=newTags{k};
end
%newTags{k+1}=[];
newTags=newTags2;
m=n;
pause
end