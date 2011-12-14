function [voxels minX minY minZ] = triangle_voxelize(p1, p2, p3)

%p1 = [randi(10) randi(10) randi(10) ]
%p2 = [randi(10) randi(10) randi(10) ]
%p3 = [randi(10) randi(10) randi(10) ]

n = cross(p2-p1, p3-p1);

n_norm = n/norm(n);

%figure

minX = floor(min([p1(1), p2(1), p3(1)]));
maxX = ceil(max([p1(1), p2(1), p3(1)]));
minY = floor(min([p1(2), p2(2), p3(2)]));
maxY = ceil(max([p1(2), p2(2), p3(2)]));
minZ = floor(min([p1(3), p2(3), p3(3)]));
maxZ = ceil(max([p1(3), p2(3), p3(3)]));

%for now use a resolution of 1...
[xx yy zz] = meshgrid(minX:1:maxX, minY:1:maxY, minZ:1:maxZ);
%[xx yy zz] = meshgrid(minY:1:maxY, minX:1:maxX, minZ:1:maxZ);
xxx = xx(:);
yyy = yy(:);
zzz = zz(:);

%tic
p4 = [xxx(:), yyy(:), zzz(:)];

%D = dot(n_norm,(p4-p1));
%THIS IS A DOT PRODUCT;
p4_pp = bsxfun(@minus, p4, p1);
%p4_times = bsxfun(@times, p4, n_norm);
D = sum(bsxfun(@times, p4_pp, n_norm),2);


%this is the projection onto the plane
pp = p4-D*n_norm;

%scatter3(pp(:,1), pp(:,2), pp(:,3))

%SAME AS THIS, but more efficient?
%D = arrayfun(@(x, y, z)sum(([x y z]-p1).*n_norm), p4(:,1), p4(:,2), p4(:,3));

cp1a = cross(p2-p1, p3-p1);
cp1b = cross(p3-p2, p1-p2);
cp1c = cross(p1-p3, p2-p3);

pp_p1 = bsxfun(@minus, pp, p1);
pp_p2 = bsxfun(@minus, pp, p2);
pp_p3 = bsxfun(@minus, pp, p3);

cp2a = cross(repmat(p2-p1, [length(xxx),1]), pp_p1);
cp2b = cross(repmat(p3-p2, [length(xxx),1]), pp_p2);
cp2c = cross(repmat(p1-p3, [length(xxx),1]), pp_p3);

%this is a dot product
dp1 = sum(bsxfun(@times, cp1a, cp2a),2);
dp2 = sum(bsxfun(@times, cp1b, cp2b),2);
dp3 = sum(bsxfun(@times, cp1c, cp2c),2);

vv = abs(D)<=1 & (dp1>=0 & dp2>=0 & dp3>=0);
%toc
%maxX-minX+1;
%maxY-minY+1;
%maxZ-minZ+1;
%size(xx);
voxels = reshape(vv, size(xx));
voxels = permute(voxels, [2 1 3]);  %swap x and y... not sure why, ugh
%figure
%[xaa yaa zaa] = ind2sub(size(voxels), find(voxels == 1));

%scatter3(xaa, yaa, zaa);

%GOTTA DO SOMETHING FOR SMALL TRIANGLES.....
%maybe just add the vertices only...

p1r = round(p1)-[minX minY minZ]+1;
p2r = round(p2)-[minX minY minZ]+1;
p3r = round(p3)-[minX minY minZ]+1;

voxels(p1r(1), p1r(2), p1r(3)) = 1;
voxels(p2r(1), p2r(2), p2r(3)) = 1;
voxels(p3r(1), p3r(2), p3r(3)) = 1;

