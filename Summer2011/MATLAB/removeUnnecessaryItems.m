necessaryIdx=0;
necessaryIndices=zeros(0);
for i=1:length(C)
if C{i}{3}(3)-C{i}{5}>24, continue, end
cMax=C{i}{4};
cMin=C{i}{3};
cSize=cMax-cMin;
if cSize(1)<10 || cSize(1)>95 || cSize(2)<10 || cSize(2)>95 || ...
        cSize(3)<13 || cSize(3)>75, continue, end

necessaryIdx=necessaryIdx+1;
necessaryIndices(end+1)=i;
end