% tic
d_results = dir('./SSResults');
% allParses=cell(0);
% for i=1:(length(d_results)-2)
%     i;
%     if isempty(strfind(d_results(i+2).name,'.mat')) %   || i==o%isequal(d_results(i+2).name,'uiuc245_parse.mat')
%         continue;
%     end
%     allParses{end+1}{1}=d_results(i+2).name;
%     clear parse
%     load(strcat('./datadistribute/', d_results(i+2).name),'parse');
%     %allParses(:,:,end+1)=parse;
%     allParses{end}{2}=int8(parse);
% end
%
% allCCFromParses=cell(0);
% for i=1:length(allParses)
%     for j=[6 8 9:12]
%         CCTemp=bwconncomp(imresize(allParses{i}{2},size(allParses{i}{2}),'nearest')==j);
%         %         for k=1:CCTemp.NumObjects
%         %             CCTemp.PixelIdxList{k}=int32(CCTemp.PixelIdxList{k});
%         %         end
%         allCCFromParses{i}{j}{1}=CCTemp;%bwconncomp(imresize(allParses{i}{2},[500 666],'nearest')==j);
%         allCCFromParses{i}{j}{2}=regionprops(CCTemp,'area');
%     end
% end
% toc
% pause
tic

resultsNumObjects=cell(0,0);

for i=1:(length(d_results)-2)
    figure
    imagesc(allParses{124}{3})
    hold on
    resultsNumObjects{o,i}=zeros(0);
    load(strcat('./SSResults/', d_results(i+2).name));
    o=str2num(uiuc_num);
    label_mask=imresize(label_mask,size(allParses{o}{2}),'nearest');
    
    i;
    
    totalNumObjects=0;
    totalNumDetectedObjects=0;
    CCArray=cell(0);
    CCNumObjArray=zeros(0);
    CCPixelsArray=cell(0);
    CCAreaArray=zeros(0);
    for j=[6 8 9:12]
        CC=bwconncomp(allParses{124}{3}==j,4);%allCCFromParses{o}{j}{1};%bwconncomp(oneResult==j);
        CCArray{j}=CC;
        CCNumObjArray(j)=CC.NumObjects;
        CCPixelsArray{j}=CC.PixelIdxList;
        CCAreaArray{j}=regionprops(CC,'area');%allCCFromParses{o}{j}{2};
    end
    uniqueNums=unique(label_mask);
    labelNums=uniqueNums(uniqueNums>0);
    
    for j=[6 8 9:12]
        
        totalNumObjects=totalNumObjects+CCNumObjArray(j);
        %CC2=bwconncomp(label_mask==labelNums(q));
        %CC2NumObj=CC2.NumObjects;
        CC2Objs=zeros(0);
        for p=1:length(labelNums)
            if label_mapping{labelNums(p),3}==j
                CC2Objs(end+1)=labelNums(p);
            end
        end
        for k=1:CCNumObjArray(j)
            if CCAreaArray{j}(k).Area<500
                totalNumObjects=totalNumObjects-1;
                continue;
            end
            isFound=0;
            indicesOfOtherResThatOverlapOneRes=zeros(0);
            for l=1:length(CC2Objs)
                if ~isempty(intersect(CCPixelsArray{j}{k},find(label_mask==CC2Objs(l))))
                    isFound=1;
                    indicesOfOtherResThatOverlapOneRes(end+1)=l;
                end
            end
            %   if isFound==0&&~isempty(find(label_mask(CCPixelsArray{j}{k})==CC2Objs(l), 1)), disp('uh oh'), end
            subScoresForObj=zeros(0);
            for l=indicesOfOtherResThatOverlapOneRes
                if ~isempty(find(label_mask(CCPixelsArray{j}{k})==CC2Objs(l), 1))
                    subScoresForObj(end+1)=length(intersect(CCPixelsArray{j}{k},find(label_mask==CC2Objs(l))))/length(union(CCPixelsArray{j}{k},find(label_mask==CC2Objs(l))));
                    if length(union(CCPixelsArray{j}{k},find(label_mask==CC2Objs(l))))==0 ,i, end
                    %subScoresForObj(end+1)=length(find(otherResult(CCPixelsArray{j}{k})==j))/length(union(CCPixelsArray{j}{k},CC2.PixelIdxList{l}))
                else
                    subScoresForObj(end+1)=0;
                    disp('sdsd')
                end
            end
            subScoreForObj=max(subScoresForObj);
            if isempty(indicesOfOtherResThatOverlapOneRes)
                subScoreForObj=0;
            end
            %resultsNumObjects(o,i,resultsIndex)=subScoreForObj;
            resultsNumObjects{o,i}(end+1)=subScoreForObj;
            if subScoreForObj>0.5
                j;
                totalNumDetectedObjects=totalNumDetectedObjects+1;
            end
            cent=regionprops(CCArray{j},'centroid');
            text(cent(k).Centroid(1),cent(k).Centroid(2),num2str(subScoreForObj))
            hold on
        end
    end
    %resultsNumObjects(o,i)=totalNumDetectedObjects/totalNumObjects;
end
toc