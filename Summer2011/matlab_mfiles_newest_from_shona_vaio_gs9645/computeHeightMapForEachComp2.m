function [compsSideViewsAll]=computeHeightMapForEachComp2
  load('../../dataStructureForStatistics/bedrooms_livingrooms_2_hotel_withSMALL_BDLR3_with_dist_nametags.mat')
  compsSideViewsAll=cell(0,0);
parfor i=1:size(C,2)
    i
  [h, h2, h3, h4]=make_obj_height_map2(C{i}{1},C{i}{2});
compsSideViewsAll{i}{1}=h{C{i}{2}};
compsSideViewsAll{i}{2}=h2{C{i}{2}};
compsSideViewsAll{i}{3}=h3{C{i}{2}};
compsSideViewsAll{i}{4}=h4{C{i}{2}};

end
