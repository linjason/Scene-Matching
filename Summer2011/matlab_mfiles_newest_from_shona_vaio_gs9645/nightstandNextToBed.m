allKeys=keys(mapOfCompToVarshaCategory);
k=0;
j=0;
m=0;
for i=1:length(allKeys)
    if isequal('help',allKeys{i}), continue, end
    
    value=mapOfCompToVarshaCategory(allKeys{i});
    ptr=pointerFromAtoC(allKeys{i});
    if size(ptr,1)<=3, continue, end
    if length(find(abs(cell2mat(value(:,2)))==1))==1
        j=j+1;
    end
    if length(find(abs(cell2mat(value(:,2)))==1))==1 %&& (length(find(abs(cell2mat(value(:,2)))==8))==0 && length(find(abs(cell2mat(value(:,2)))==9))==0)
        k=k+1;
        bedIdx=ptr{find(abs(cell2mat(value(:,2)))==1),1};
        for l=1:size(value,1)
            if isnan(value{l,2})||abs(value{l,2})==1||abs(value{l,2})==8||abs(value{l,2})==9, continue, end
           if distNearestPixels(ptr{l,1},ptr{find(abs(cell2mat(value(:,2)))==1),1},C) >12, continue, end
            if C{ptr{l,1}}{3}(3)-C{ptr{l,1}}{5}>12, continue, end
           if C{ptr{l,1}}{4}(3)-C{ptr{l,1}}{3}(3)>40 || C{ptr{l,1}}{4}(3)-C{ptr{l,1}}{3}(3)<10 || C{ptr{l,1}}{4}(2)-C{ptr{l,1}}{3}(2)>40 || C{ptr{l,1}}{4}(1)-C{ptr{l,1}}{3}(1)>40
                continue 
            end
            %k=k+1;
            nightstandIdx=ptr{l,1};
            nsMid=(C{nightstandIdx}{4}+C{nightstandIdx}{3})/2;
            if (abs(C{bedIdx}{4}(2)-nsMid(2))<26 || abs(C{bedIdx}{3}(2)-nsMid(2))<26) && (abs(C{bedIdx}{4}(1)-nsMid(1))<26 || abs(C{bedIdx}{3}(1)-nsMid(1))<26)
                value{l,1}
                allKeys{i}
            m=m+1
            end
            
        end
    end
    
    
end