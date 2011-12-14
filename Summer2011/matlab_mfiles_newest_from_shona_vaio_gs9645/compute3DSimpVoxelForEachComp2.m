function [compsHeightViewsAll]=compute3DSimpVoxelForEachComp2
  load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags.mat')
parfor i=2500:5500
    i
    heightMap=make_obj_voxels2(C{i}{1},C{i}{2});
     compsHeightViewsAll{i}=heightMap{C{i}{2}};
end
