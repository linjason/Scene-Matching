clear syn;
syn=cell(0);
j=0;
for i=1:3049
    i;
    if ~isequal(finalScores{i}{2},0)
        j=j+1;
        syn{j}{1}=C{finalScores{i}{1}}{7};
        syn{j}{2}=finalScores{i}{1};
        l=0;
        for k=1:3
            if finalScores{i}{2}(k,2)==finalScores{i}{1}
                continue
            else
                l=l+1;
                syn{j}{3*l}=C{finalScores{i}{2}(k,2)}{7};
                syn{j}{3*l+1}=finalScores{i}{2}(k,2);
                syn{j}{3*l+2}=finalScores{i}{2}(k,1);
            end
        end
    end
end
% k=0;
% results=cell(0);
% for i=1:length(syn)
%     categories=zeros(1,5);
%     for j=[1 3 5]
%         if (~isempty(strfind(lower(syn{i}{j}),'dresser'))||~isempty(strfind(lower(syn{i}{j}),'dresser')))&&isempty(strfind(lower(syn{i}{j}),'lamp'))&&isempty(strfind(lower(syn{i}{j}),'room'))&&isempty(strfind(lower(syn{i}{j}),'bed'))&&isempty(strfind(lower(syn{i}{j}),'leg')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=1;
%         end
%         if ((~isempty(strfind(lower(syn{i}{j}),'bed')) || ~isempty(strfind(lower(syn{i}{j}),'couch')))&& isempty(strfind(lower(syn{i}{j}),'lateral')) && isempty(strfind(lower(syn{i}{j}),'head')) && isempty(strfind(lower(syn{i}{j}),'table')) && isempty(strfind(lower(syn{i}{j}),'frame')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'latte')) && isempty(strfind(lower(syn{i}{j}),'tv')) && isempty(strfind(lower(syn{i}{j}),'leg')) && isempty(strfind(lower(syn{i}{j}),'pole')))
%             categories(j)=2;
%         end
%         if ((~isempty(strfind(lower(syn{i}{j}),'couch')) || ~isempty(strfind(lower(syn{i}{j}),'sofa')))&& isempty(strfind(lower(syn{i}{j}),'bed'))&& isempty(strfind(lower(syn{i}{j}),'table'))&& isempty(strfind(lower(syn{i}{j}),'room'))&& isempty(strfind(lower(syn{i}{j}),'frame'))&& isempty(strfind(lower(syn{i}{j}),'down')))
%             categories(j)=3;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'nightstand')) ||  ~isempty(strfind(lower(syn{i}{j}),'night stand'))) && isempty(strfind(lower(syn{i}{j}),'lamp')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'bed')) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=4;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'nightstand')) ||  ~isempty(strfind(lower(syn{i}{j}),'night stand'))) && isempty(strfind(lower(syn{i}{j}),'lamp')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'bed')) && isempty(strfind(lower(syn{i}{j}),'desk')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=5;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'toilet')))
%             categories(j)=6;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'sink')))
%             categories(j)=7;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'computer')) || ~isempty(strfind(lower(syn{i}{j}),'computer'))) && isempty(strfind(lower(syn{i}{j}),'lamp')) && isempty(strfind(lower(syn{i}{j}),'room')) && (isempty(strfind(lower(syn{i}{j}),'desk'))||~isempty(strfind(lower(syn{i}{j}),'desktop'))) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=8;
%         end
%           if (~isempty(strfind(lower(syn{i}{j}),'lamp')) ) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=9;
%           end
%         if (~isempty(strfind(lower(syn{i}{j}),'tv')) ) && isempty(strfind(lower(syn{i}{j}),'desk')) && isempty(strfind(lower(syn{i}{j}),'table')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=10;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'bathtub')) ) && isempty(strfind(lower(syn{i}{j}),'desk')) && isempty(strfind(lower(syn{i}{j}),'table')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=10;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'door')) ) && isempty(strfind(lower(syn{i}{j}),'desk')) && isempty(strfind(lower(syn{i}{j}),'table')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=10;
%         end
%         if (~isempty(strfind(lower(syn{i}{j}),'file cabinet'))||~isempty(strfind(lower(syn{i}{j}),'filing cabinet')) ) && isempty(strfind(lower(syn{i}{j}),'desk')) && isempty(strfind(lower(syn{i}{j}),'table')) && isempty(strfind(lower(syn{i}{j}),'room')) && isempty(strfind(lower(syn{i}{j}),'dresser')) && isempty(strfind(lower(syn{i}{j}),'convertable'))
%             categories(j)=10;
%         end
%     end
%     allTheSame=isequal(syn{i}{1},syn{i}{3})&&isequal(syn{i}{3},syn{i}{5});
%     if ~allTheSame&&(categories(1)==0 ||categories(1)~=categories(3) || categories(1)~=categories(5) || categories(5)~=categories(3))
%         %if allTheSame
%         i;
%         k=k+1;
%         results{k}=syn{i};
%         syn{i}
%     end
% end


% allTags=cell(0);
% m=0;
% for i=1:length(syn)
%     for j=[1 3 6]
%         if ~ismember(syn{i}{j},allTags)
%             m=m+1;
%             allTags{m}=syn{i}{j};
%         end
%     end
% end
% affMat=zeros(length(allTags),length(allTags));
% for i=1:length(syn)
%     oneStrInd=zeros(0,5);
%     for j=[1 3 6]
%         oneStrInd(j)=1;
%         for m=1:length(allTags)
%             if isequal(allTags{oneStrInd(j)},syn{i}{j})
%                 break
%             else
%                 oneStrInd(j)=oneStrInd(j)+1;
%             end
%         end
%     end
%     affMat(oneStrInd(1),oneStrInd(3))=affMat(oneStrInd(1),oneStrInd(3))+10000-syn{i}{5};
%     affMat(oneStrInd(1),oneStrInd(6))=affMat(oneStrInd(1),oneStrInd(6))+10000-syn{i}{8};
% end

allResults=zeros(0,3);
aRIndex=0;
for i=1:length(syn)
    for j=[3 6]
        aRIndex=aRIndex+1;
        allResults(aRIndex,1)=syn{i}{2};
        allResults(aRIndex,2)=syn{i}{j+1};
        allResults(aRIndex,3)=syn{i}{j+2};
    end
end

sortedResults=sortrows(allResults,3);
%sortedResults=[1 4;1 5;6 1  ]
grouped=zeros(0);
for i=1:size(sortedResults,1)
    one=sortedResults(i,1);
    other=sortedResults(i,2);
    if ~ismember(one,grouped)&&~ismember(other,grouped)
        grouped(end+1,1)=one;
        grouped(end,2)=other;
    elseif ~ismember(one,grouped)&&ismember(other,grouped)
        [a b]=ind2sub(size(grouped),find(grouped==other,1));
        if isempty(find(grouped(a,:)==0,1))
            grouped(a,end+1)=one;
        else
            grouped(a,find(grouped(a,:)==0,1))=one;
        end
    elseif ismember(one,grouped)&&~ismember(other,grouped)
        [a b]=ind2sub(size(grouped),find(grouped==one,1));
        if isempty(find(grouped(a,:)==0,1))
            grouped(a,end+1)=other;
        else
            grouped(a,find(grouped(a,:)==0,1))=other;
        end
    elseif ismember(one,grouped)&&ismember(other,grouped)
        
       
        s=sort([other one]);
        one=s(1);
        other=s(2);
        [a b]=ind2sub(size(grouped),find(grouped==one,1));
        [c d]=ind2sub(size(grouped),find(grouped==other,1));
         if a==c
            continue
         end
          sortedResults(i,3)
        %pause
        disp('a')
        for ii=1:length(grouped(a,:))
            if grouped(a,ii)~=0
                C{grouped(a,ii)}{7}
            end
        end
        disp('c')
        for ii=1:length(grouped(c,:))
            if grouped(c,ii)~=0
                C{grouped(c,ii)}{7}
            end
        end
       
        if isempty(find(grouped(a,:)==0,1))
            grouped(a,end+1)=grouped(c,1);
            inde=2;
            while grouped(c,inde)~=0
               grouped(a,end+1)=grouped(c,inde)
                inde=inde+1;
            end
        else
            grouped(a,find(grouped(a,:)==0,1))=other;
            inde=1;
            while inde<=size(grouped(c,:),2) && grouped(c,inde)~=0
               grouped(a,find(grouped(a,:)==0,1)+inde-1)=grouped(c,inde); 
                inde=inde+1;
            end
        end
        grouped(c,:)=[];
    end
    %   pause
end
groupedUnique=zeros(0,0);
for i=1:size(grouped,1)
unq=unique(grouped(i,:));
groupedUnique(i,1:length(unq))=unq;
end
names=cell(0);
for i=1:size(groupedUnique,1)
   iii=0;
    for j=1:size(groupedUnique,2)
    if groupedUnique(i,j)~=0
        iii=iii+1;
        names{i}{iii}=C{groupedUnique(i,j)}{7};
    end
   end
end
