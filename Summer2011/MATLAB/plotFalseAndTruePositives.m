aaa=flipud(sortrows([finalScores' taggedIndices target']))
in=aaa(find(aaa(:,3)==0,5),2)
%load('bedrooms_2_with_dist_nametags.mat');

drawnow, figure(12)
for i=1:5
    results_mat_name=C{in(i)}{1};
    cIndex=C{in(i)}{2};
    %figure(12),clf
    i
    clear A;
    load(strcat(strcat('../../results_bedroom_2_mat/', results_mat_name)));
    for facesIndex = 1:2:size(A{cIndex},2)-1
        pointsTrans = A{cIndex}{facesIndex};
        polygons = A{cIndex}{facesIndex+1};
        %hold on   
     subplot(2,5,i),patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', 'r');
    end
end
for i=1:5
    results_mat_name=C{in(i)}{1};
    cIndex=C{in(i)}{2};
    %figure(12),clf
    i
    clear A;
    load(strcat(strcat('../../results_bedroom_2_mat/', ...
                       results_mat_name)));
    for facesIndex = 1:2:size(A{cIndex},2)-1
        pointsTrans = A{cIndex}{facesIndex};
        polygons = A{cIndex}{facesIndex+1};
        %hold on
     subplot(2,5,i),patch('vertices', (pointsTrans), 'faces', ...
                          abs(polygons'), 'facecolor', 'r');
    end
end
