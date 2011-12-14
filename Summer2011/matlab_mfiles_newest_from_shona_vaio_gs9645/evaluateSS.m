% tic
% d_results = dir('./datadistribute');
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
%         CCTemp=bwconncomp(imresize(allParses{i}{2},[500 666],'nearest')==j);
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

resultsPixels=zeros(0);
resultsNumObjects=zeros(0,0);
for o=309%1:length(allParses)%(length(d_results)-2)
    o;
    %     if isempty(strfind(d_results(o+2).name,'.mat'))
    %         continue
    %     end
    %load('./datadistribute/uiuc245_parse.mat');
    clear parse
    %load(strcat('./datadistribute/', d_results(o+2).name),'parse');
    parse=allParses{o}{2};
    oneResult=imresize(parse,[500 666],'nearest');
    for i=1:length(allParses)%1:(length(d_results)-2)
%resultsNumObjects{o,i}=zeros(0);
        i;
        resultsIndex=0;
        if  i==o%isequal(d_results(i+2).name,'uiuc245_parse.mat') || isempty(strfind(d_results(i+2).name,'.mat')
            continue;
        end
        %pp=load(strcat('./datadistribute/', d_results(i+2).name),'parse');
        %otherResult=imresize(pp.parse,[500 666],'nearest');
        parse=allParses{i}{2};
        otherResult=imresize(parse,[500 666],'nearest');
        % pixel based evaluation
        
        %     intersect=0;
        %     union=0;
        %     for j=1:size(oneResult,1)
        %         for k=1:size(oneResult,2)
        %             if oneResult(j,k)==otherResult(j,k) && oneResult(j,k)~=13 && oneResult(j,k)~=2
        %                 intersect=intersect+1;
        %              end
        %         end
        %     end
        %     resultsPixels(i)=intersect;
        
        % counting number of detected objects, over 50% overlap considered
        % detected
        totalNumObjects=0;
        totalNumDetectedObjects=0;
        CCNumObjArray=zeros(0);
        CCPixelsArray=cell(0);
        CCAreaArray=zeros(0);
        for j=[6 8 9:12]
            CC=allCCFromParses{o}{j}{1};%bwconncomp(oneResult==j);
            CCNumObjArray(j)=CC.NumObjects;
            CCPixelsArray{j}=CC.PixelIdxList;
            CCAreaArray{j}=allCCFromParses{o}{j}{2};%regionprops(CC,'area');
        end
        for j=[6 8 9:12]
            totalNumObjects=totalNumObjects+CCNumObjArray(j);
            CC2=allCCFromParses{i}{j}{1};%bwconncomp(otherResult==j);
            CC2NumObj=CC2.NumObjects;
            for k=1:CCNumObjArray(j)
                if CCAreaArray{j}(k).Area<500
                    totalNumObjects=totalNumObjects-1;
                    continue;
                end
                isFound=0;
                indicesOfOtherResThatOverlapOneRes=zeros(0);
                for l=1:CC2NumObj
                    if ~isempty(intersect(CCPixelsArray{j}{k},CC2.PixelIdxList{l}))
                        isFound=1;
                        %break;
                        indicesOfOtherResThatOverlapOneRes(end+1)=l;
                    end
                end
                if isFound==0&&~isempty(find(otherResult(CCPixelsArray{j}{k})==j, 1))
                    disp('uh oh')
                    pause
                end
                subScoresForObj=zeros(0);
                for l=indicesOfOtherResThatOverlapOneRes
                    if ~isempty(find(otherResult(CCPixelsArray{j}{k})==j, 1))
                        subScoresForObj(end+1)=length(intersect(CCPixelsArray{j}{k},CC2.PixelIdxList{l}))/length(union(CCPixelsArray{j}{k},CC2.PixelIdxList{l})); 
                        if length(union(CCPixelsArray{j}{k},CC2.PixelIdxList{l}))==0
                           i 
                        end
                        %subScoresForObj(end+1)=length(find(otherResult(CCPixelsArray{j}{k})==j))/length(union(CCPixelsArray{j}{k},CC2.PixelIdxList{l}))
                    else
                        subScoresForObj(end+1)=0;
                    end
                end
                  subScoreForObj=max(subScoresForObj);
                if isempty(indicesOfOtherResThatOverlapOneRes)
                    subScoreForObj=0;
                end
              resultsIndex=resultsIndex+1;
                %resultsNumObjects(o,i,resultsIndex)=subScoreForObj;
                %resultsNumObjects{o,i}(end+1)=subScoreForObj;
                if subScoreForObj>0.5
                    j;
                    totalNumDetectedObjects=totalNumDetectedObjects+1;
                end
            end
            %pause
        end
        resultsNumObjects(o,i)=totalNumDetectedObjects/totalNumObjects;
    end
end
toc