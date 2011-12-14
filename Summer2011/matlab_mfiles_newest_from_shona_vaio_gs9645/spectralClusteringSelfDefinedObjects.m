names2=cell(0);
for i=1:max(cluster_labels) %num_cl
    nm=new(find(cluster_labels==i));
    for j=1:length(nm)
        names2{i}{j}=C{nm(j)}{7};
    end
end