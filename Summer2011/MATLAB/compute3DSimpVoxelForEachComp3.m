function [compsHeightViewsAll]=compute3DSimpVoxelForEachComp3
  load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags.mat')
parfor i=5000:size(C,2)
    i
    heightMap=make_obj_voxels3(C{i}{1},C{i}{2});
     compsHeightViewsAll{i}=heightMap{C{i}{2}};
end
