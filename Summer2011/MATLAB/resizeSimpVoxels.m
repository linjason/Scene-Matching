comps3DVoxBDLR23HT_Dnsz_Rsz=cell(1,size(comps3DVoxBDLR23HT_Dnsz,2));

parfor compIndex=1:size(comps3DVoxBDLR23HT_Dnsz,2)
compIndex
 m=comps3DVoxBDLR23HT_Dnsz{compIndex};
if isempty(m)||~isequal(size(size(m)),[1 3])
comps3DVoxBDLR23HT_Dnsz_Rsz{compIndex}=[];
continue;
end
n=zeros(0,0,0);
for i=1:size(m,3)
n(:,:,i)=imresize(m(:,:,i),[30 30]);
end
o=imresize3(n,30/size(m,3));

comps3DVoxBDLR23HT_Dnsz_Rsz{compIndex}=o;



end