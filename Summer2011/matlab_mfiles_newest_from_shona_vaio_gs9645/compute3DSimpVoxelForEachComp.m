function [compsHeightViewsAll]=compute3DSimpVoxelForEachComp
  load(['../../dataStructureForStatistics/bedrooms_livingrooms_2_hotel_withSMALL_BDLR3_with_dist_nametags.mat'])
compsHeightViewsAll=cell(0);
parfor i=1:10000%20001:length(C)
    i
if C{i}{4}(3)-C{i}{3}(3)<13, continue, end
if C{i}{4}(3)-C{i}{3}(3)>75, continue, end
if C{i}{4}(1)-C{i}{3}(1)<10, continue, end
if C{i}{4}(2)-C{i}{3}(2)>95, continue, end
if C{i}{4}(1)-C{i}{3}(1)>95, continue, end
if C{i}{4}(2)-C{i}{3}(2)<10, continue, end
if C{i}{3}(3)-C{i}{5}>24, continue, end
    heightMap=make_obj_voxels(C{i}{1},C{i}{2});
     compsHeightViewsAll{i}=heightMap{C{i}{2}};
end
