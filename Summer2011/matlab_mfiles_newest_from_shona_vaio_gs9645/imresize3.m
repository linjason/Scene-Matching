function M=imresize3(m,k)
d=size(m);
z=1:d(3);
zi=1:(d(3)-1)/(d(3)*k-1):d(3);
M=permute(interp1(z,permute(double(m),[3 1 2]),zi),[2 3 1]); 