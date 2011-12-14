% outputs overlap score and component category, using intersection/union
% score
function resultsNumObjects = evaluateSSRealResults2_bb(uiuc_num, label_mask, label_mapping, separated)
tic
resultsNumObjects=cell(0);
for i=1%:(length(d_results)-2)
    load allParses
    % results
    resultsNumObjects{i}=zeros(0);
    
    % SS result label_mask
    %load(strcat('./SSResults/', d_results(i+2).name));
    o=str2num(uiuc_num);
    label_mask=imresize(label_mask,size(allParses{o}{2}),'nearest');
    
    %figure
    %imagesc(allParses{o}{separated})
    %hold on
    
    uniqueNums=unique(label_mask);
    labelNums=uniqueNums(uniqueNums>0);
    for j=[6 8 9:12] % only interested in these ground truth components
        CC=bwconncomp(abs(allParses{o}{separated})==j,4);   % normally use {o}{2}, here {o}{3} contains manually-separated connected objects
        CCNumObj=CC.NumObjects;
        CCPixels=CC.PixelIdxList;
        CCArea=regionprops(CC,'area');
        CCBB=regionprops(CC,'BoundingBox');
        
        
        % the label_mask labels we are interested in during this iteration
        CC2Objs=zeros(0);
        for p=1:length(labelNums)
            if abs(label_mapping{labelNums(p),3})==j
                CC2Objs(end+1)=labelNums(p);
            end
        end
        
        for k=1:CCNumObj % for all instances of this category in ground truth
            if CCArea(k).Area<500
                continue;
            end
            
                          thisCCBB=CCBB(k).BoundingBox;
                [X Y]=meshgrid(ceil(thisCCBB(2)):ceil(thisCCBB(2))+thisCCBB(4)-1,ceil(thisCCBB(1)):ceil(thisCCBB(1))+thisCCBB(3)-1);
                CCBBIdx=sub2ind(size(allParses{o}{separated}),X,Y);
            % the overlapping components in the label_mask
            indicesOfOtherResThatOverlapOneRes=zeros(0);
            for l=1:length(CC2Objs)
  
                
                CCBB2=regionprops(label_mask==CC2Objs(l),'BoundingBox');
                if ~isequal(size(CCBB2),[1 1]), disp('error~~~~~~~~~~~~~'), end
                thisCCBB2=CCBB2.BoundingBox;
                [X Y]=meshgrid(ceil(thisCCBB2(2)):ceil(thisCCBB2(2))+thisCCBB2(4)-1,ceil(thisCCBB2(1)):ceil(thisCCBB2(1))+thisCCBB2(3)-1);
                CCBB2Idx=sub2ind(size(allParses{o}{separated}),X,Y);
                
                if ~isempty(intersect(CCBBIdx(:),CCBB2Idx(:)))
                    indicesOfOtherResThatOverlapOneRes(end+1)=l;
                end
            end
            
            % compute score
            subScoresForObj=zeros(0);
            for l=indicesOfOtherResThatOverlapOneRes
                CCBB2=regionprops(label_mask==CC2Objs(l),'BoundingBox');
                thisCCBB2=CCBB2.BoundingBox;
          [X Y]=meshgrid(ceil(thisCCBB2(2)):ceil(thisCCBB2(2))+thisCCBB2(4)-1,ceil(thisCCBB2(1)):ceil(thisCCBB2(1))+thisCCBB2(3)-1);
                CCBB2Idx=sub2ind(size(allParses{o}{separated}),X,Y);
                
                subScoresForObj(end+1)=length(intersect(CCBBIdx(:),CCBB2Idx(:)))/length(union(CCBBIdx(:),CCBB2Idx(:)));
                if length(union(CCBBIdx(:),CCBB2Idx(:)))==0 ,disp('uh oh, error'), end
            end
            
            % if component in the ground truth overlaps multiple comps in
            % the label_mask, choose the highest matching score
            subScoreForObj=max(subScoresForObj);
            
            if isempty(indicesOfOtherResThatOverlapOneRes) % no matches at all in label_mask
                subScoreForObj=0;
            end
            resultsNumObjects{i}(end+1,1)=subScoreForObj;
            resultsNumObjects{i}(end,2)=j;
            % write score onto figure
            %cent=regionprops(CC,'centroid');
            %text(cent(k).Centroid(1),cent(k).Centroid(2),num2str(subScoreForObj))
            %hold on
        end
    end
end
toc