d_results = dir('./results');
bounds = zeros(length(d_results)-2, 6);
j = 0;

for i = 1:(length(d_results)-2)
    fout = fopen('./passedSizeTest.txt', 'a');
    file = fopen(strcat('./results/', d_results(i+2).name), 'r');
    %fscanf(file, '%[##Only one Component]');
    bound = fscanf(file, '%f', [1,6]);
    if (~isempty(bound) )
        %if(1)
        %if (bound(2)-bound(1)<2000 && bound(2)-bound(1)>0 && bound(4)-bound(3)<2000 && bound(4)-bound(3)>0 && bound(6)-bound(5)<2000 && bound(6)-bound(5)>0)
        if (bound(2)-bound(1)<800 && bound(2)-bound(1)>130 && bound(4)-bound(3)<800 && bound(4)-bound(3)>130 && bound(6)-bound(5)<200 && bound(6)-bound(5)>12)
            j = j + 1;
            fprintf(fout, '%s\n', d_results(i+2).name);
            bounds(j, :) = bound;
            d_results(i+2).name;
        else
            %d_results(i+2).name
            continue;
        end
    else
        %d_results(i+2).name
        continue;
    end
    fclose('all');
end
 fclose('all');
j
 subplot(3,1,3),hist(bounds(1:j,6)-bounds(1:j,5),120)
 subplot(3,1,2),hist(bounds(1:j,4)-bounds(1:j,3),120)
 subplot(3,1,1),hist(bounds(1:j,2)-bounds(1:j,1),120)