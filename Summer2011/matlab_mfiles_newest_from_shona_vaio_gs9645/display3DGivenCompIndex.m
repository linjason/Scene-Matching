% draws components in 3D
% input: the component index in the C array

function display3DGivenCompIndex(compIndexAll)
load('bedrooms_2_with_dist_nametags.mat');
compIndex=compIndexAll;
drawnow, figure(12)
for i=1:length(compIndexAll)
    results_mat_name=C{compIndex(i)}{1};
    cIndex=C{compIndex(i)}{2};
    %figure(12),clf
    i
    clear A;
    load(strcat(strcat('results_mat/', results_mat_name), ''));
    for facesIndex = 1:2:size(A{cIndex},2)-1
        pointsTrans = A{cIndex}{facesIndex};
        polygons = A{cIndex}{facesIndex+1};
        patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', 'r');
        
    end
    %pause
end
