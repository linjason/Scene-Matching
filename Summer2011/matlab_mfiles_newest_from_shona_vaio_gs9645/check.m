d_results = dir('./results_mat');
for fileIndex = 1:(length(d_results)-2)
    clear A
    load(strcat('./results_mat/', d_results(fileIndex+2).name));

  if (~isequal(size(A{size(A,2)}),[1 2]))
      fileIndex
      d_results(fileIndex+2).name
  end
end