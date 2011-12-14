d_results = dir('./results');
bounds = zeros(0, 6);
j = 0;

for i = 1:(length(d_results)-2)
    numb=0;
    fout = fopen('./passedSizeTest.txt', 'a');
    file = fopen(strcat('./results/', d_results(i+2).name), 'r');
       bound = fscanf(file, '%f\n', [1,6]);
     comps=fscanf(file, '%[##Small number of components and groups: ]');
  numb=fscanf(file,'%f');
  if ~isempty(numb)&&numb~=1
      numb=[];
  end
%   if numb==1
%       d_results(i+2).name
%   end
    d_results(i+2).name;
    if (~isempty(bound))
        if ~(bound(2)-bound(1)<800 && bound(2)-bound(1)>130 && bound(4)-bound(3)<800 && bound(4)-bound(3)>130 && bound(6)-bound(5)<200 && bound(6)-bound(5)>12)
            if bound(2)-bound(1)<=800 && bound(2)-bound(1)>90 && bound(4)-bound(3)<=800 && bound(4)-bound(3)>90 && bound(6)-bound(5)<200 && bound(6)-bound(5)>12 && isempty(numb)
                j = j + 1;
                fprintf(fout, '%s\n', d_results(i+2).name);
                bounds(j, :) = bound;
                d_results(i+2).name
            end
        end
    end
    fclose('all');
end
fclose('all');
%  subplot(3,1,3),hist(bounds(1:j,6)-bounds(1:j,5),120)
%  subplot(3,1,2),hist(bounds(1:j,4)-bounds(1:j,3),120)
%  subplot(3,1,1),hist(bounds(1:j,2)-bounds(1:j,1),120)