aaa=flipud((sortrows([finalScores' taggedIndices target'])))
falsePos=aaa(find(aaa(:,3)==0,5),2)
falseNeg=aaa(find(aaa(:,3)==1,5,'last'),2)
%load('bedrooms_2_with_dist_nametags.mat');

drawnow, figure(12), clf
for i=1:5
    falsePos(i)
    results_mat_name=C{falsePos(i)}{1};
    cIndex=C{falsePos(i)}{2};
    tag=C{falsePos(i)}{7};
    %figure(12),clf
    i
    clear A;
    load(strcat(strcat('./results_mat/', results_mat_name)));
    if size(A{cIndex},2)>3000
        ending=3001;
    else
        ending=size(A{cIndex},2);
    end
        for facesIndex = 1:2:ending-1
        pointsTrans = A{cIndex}{facesIndex};
        polygons = A{cIndex}{facesIndex+1};
        %hold on
        subplot(2,5,i),patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', 'r');
        if length(tag)>22 && length(tag)<=40
            title({tag(1:round(length(tag)/2));tag(round(length(tag)/2)+1:end)});
        elseif length(tag)>40
            title({tag(1:round(length(tag)/3));tag(round(length(tag)/3)+1:round(length(tag)*2/3));tag(round(length(tag)*2/3)+1:end) });
        else
            title(tag);
        end
    end
end
for i=1:5
    falseNeg(i)
    results_mat_name=C{falseNeg(i)}{1};
    cIndex=C{falseNeg(i)}{2};
    tag=C{falseNeg(i)}{7};
    %figure(12),clf
    i
    clear A;
    load(strcat(strcat('./results_mat/', results_mat_name)));
     if size(A{cIndex},2)>3000
        ending=3001;
    else
        ending=size(A{cIndex},2);
    end
        for facesIndex = 1:2:ending-1
        pointsTrans = A{cIndex}{facesIndex};
        polygons = A{cIndex}{facesIndex+1};
        %hold on
        subplot(2,5,i+5),patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', 'r');
    if length(tag)>22 && length(tag)<=40
            title({tag(1:round(length(tag)/2));tag(round(length(tag)/2)+1:end)});
        elseif length(tag)>40
            title({tag(1:round(length(tag)/3));tag(round(length(tag)/3)+1:round(length(tag)*2/3));tag(round(length(tag)*2/3)+1:end) });
        else
            title(tag);
        end
    end
end