function [compsHeightViewsAll]=computeHeightMapForEachComp
    load('../../dataStructureForStatistics/bedrooms_livingrooms_2_hotel_withSMALL_BDLR3_with_dist_nametags.mat')
    compsHeightViewsAll=cell(0);
    parfor i=1:size(C,2)
        i
    heightMap=make_obj_height_map(C{i}{1},C{i}{2});
    compsHeightViewsAll{i}=heightMap{C{i}{2}};
    end
    