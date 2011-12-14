function evaluateSSDrawBBAndSeg(uiuc_num, label_mask, label_mapping, separated)
o=str2num(uiuc_num);
load allParses
figure
uiuc_img=imread(sprintf('./datadistribute/images/uiuc%d.jpg',o));
imagesc(uiuc_img)
label_mask=imresize(label_mask,size(allParses{o}{separated}),'nearest');
gt=allParses{o}{separated}; % ground truth
uniqueNums=unique(label_mask);
labelNums=uniqueNums(uniqueNums>0);

%%% map component numbers to true colors, for both label_mask and
%%% ground_truth
label_mask_hsv=zeros([size(label_mask) 3]);
gt_hsv=zeros([size(label_mask) 3]);
colors=[0 0 0;hsv(13)];
for m=1:size(label_mask,1)
    for n=1:size(label_mask,2)
        if gt(m,n)==6||gt(m,n)==8||gt(m,n)==9||gt(m,n)==10||gt(m,n)==11||gt(m,n)==12||gt(m,n)==13 % 100 times faster than the next line
        %if ismember(gt(m,n),[6 8 9:12 13])
            gt_hsv(m,n,:)=colors(gt(m,n)+1,:);
        else
            gt_hsv(m,n,:)=colors(13+1,:);
        end
        if label_mask(m,n)==0
            label_mask_hsv(m,n,:)=[0 0 0];
        else
            label_mask_hsv(m,n,:)=colors(abs(label_mapping{label_mask(m,n),3})+1,:);
        end
    end
end

%%% overlay label_mask onto uiuc_image and set transparency of label_mask
hold on
h = imagesc(label_mask_hsv);
hold off
set(h, 'AlphaData', 0.5*(label_mask~=0))

%%% draw bounding box onto uiuc_image and label category number (using
%%% Varshyy
for j=labelNums'
    CCBB=regionprops(label_mask==j,'BoundingBox');
    thisCCBB=CCBB.BoundingBox;
    hold on
    xMin=ceil(thisCCBB(1));
    xMax=ceil(thisCCBB(1))+thisCCBB(3);
    yMin=ceil(thisCCBB(2));
    yMax=ceil(thisCCBB(2))+thisCCBB(4);
    line([xMin,xMin],[yMin,yMax],'color','black')
    line([xMin,xMax],[yMin,yMin],'color','black')
    line([xMin,xMax],[yMax,yMax],'color','black')
    line([xMax,xMax],[yMin,yMax],'color','black')
    text((xMin+xMax)/2,(yMin+yMax)/2,sprintf('Cat: %d',label_mapping{j,3}))
end

%%% ground truth
figure
imagesc(gt_hsv)
%%% on ground_truth, label the order in which the objects are scored
scoringOrder=1;
for j=[6 8 9:12] % only interested in these ground truth components
    CC=bwconncomp(allParses{o}{separated}==j,4);   % normally use {o}{2}, here {o}{3} contains manually-separated connected objects
    CCNumObj=CC.NumObjects;
    CCArea=regionprops(CC,'area');
    for k=1:CCNumObj % for all instances of this category in ground truth
        if CCArea(k).Area<500
            continue;
        end
        cent=regionprops(CC,'centroid');
        text(cent(k).Centroid(1),cent(k).Centroid(2),sprintf('Order: %d',scoringOrder))
        hold on
        scoringOrder=scoringOrder+1;
    end
end
for j=labelNums'
    CCBoundary=bwboundaries(label_mask==j,'n');
    plot(CCBoundary{:}(:,2),CCBoundary{:}(:,1));
end
