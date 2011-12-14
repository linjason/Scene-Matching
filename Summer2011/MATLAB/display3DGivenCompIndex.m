function display3DGivenCompIndex(compIndexAll)
load('../../dataStructureForStatistics/bedrooms_2_with_dist_nametags.mat');
    compIndex=compIndexAll(1:30);
  drawnow, figure(11)
    
for i=2
 results_mat_name=C{compIndex(i)}{1};
    cIndex=C{compIndex(i)}{2};
    %figure(11),clf
        clear A;
        load(strcat(strcat('../../results_bedroom_2_mat/', results_mat_name), ''));
        %for compsIndex = 33%compNum%1:size(A, 2) - 1
        %colorIndex = mod(compsIndex-1, 20)+1;
        for facesIndex = 1:2:size(A{cIndex},2)-1
            pointsTrans = A{cIndex}{facesIndex};
            polygons = A{cIndex}{facesIndex+1};
            patch('vertices', (pointsTrans), 'faces', abs(polygons'));
        
        end
      
%end
    end
