% tic
% %allCCFromParses=cell(0);
% parfor i=1:length(allParses)
%     for j=[6 8 9:12]
%         CCTemp=bwconncomp(imresize(allParses{i}{2},[500 666],'nearest')==j);
%         %         for k=1:CCTemp.NumObjects
%         %             CCTemp.PixelIdxList{k}=int32(CCTemp.PixelIdxList{k});
%         %         end
%         %allCCFromParses{i}{j}{1}=CCTemp;%bwconncomp(imresize(allParses{i}{2},[500 666],'nearest')==j);
%         %allCCFromParses{i}{j}{2}=regionprops(CCTemp,'area');
%         allCCFromParses{i}{j}{3}=bwboundaries(imresize(allParses{i}{2},[500 666],'nearest')==j,'noholes');
%     end
% end
% toc
% pause

tic
resultsBoundary=cell(0,0);
resultsBoundaryMean=cell(0,0);
for o=1:length(allParses)%(length(d_results)-2)
    o
    %     if isempty(strfind(d_results(o+2).name,'.mat'))
    %         continue
    %     end
    %load('./datadistribute/uiuc245_parse.mat');
    %clear parse
    %load(strcat('./datadistribute/', d_results(o+2).name),'parse');
    parse=allParses{o}{2};
    oneResult=imresize(parse,[500 666],'nearest');
    for i=1:length(allParses)%1:(length(d_results)-2)
        resultsBoundary{o}{i}=zeros(0);
        resultsBoundaryMean{o}{i}=zeros(0);
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
                subScoresForObjMean=zeros(0);
                oneBoundary=allCCFromParses{o}{j}{3}{k};
                for l=indicesOfOtherResThatOverlapOneRes
                    otherBoundary=allCCFromParses{i}{j}{3}{l};
                    distsBetweenTwoBoundaries=zeros(0);
                    for y=1:size(oneBoundary,1)
                        %minDistForPixel=Inf;
                        %for z=1:size(otherBoundary,1)
                            %distBetweenTwoPixels=((oneBoundary(y,1)-otherBoundary(z,1))^2+  (oneBoundary(y,2)-otherBoundary(z,2))^2)^.5;
                            
                            %if distBetweenTwoPixels<minDistForPixel
                                %minDistForPixel=distBetweenTwoPixels;
                                %end
                            %end
                        distsBetweenTwoBoundaries(y)=min(((oneBoundary(y,1)-otherBoundary(:,1)).^2+(oneBoundary(y,2)-otherBoundary(:,2)).^2).^.5);
                        %distsBetweenTwoBoundaries(y)=minDistForPixel;
                    end
                    subScoresForObj(end+1)=median(distsBetweenTwoBoundaries);
                    subScoresForObjMean(end+1)=mean(distsBetweenTwoBoundaries);
                    %if ~isempty(find(otherResult(CCPixelsArray{j}{k})==j,1))
                    %subScoresForObj(z)=length(intersect(CCPixelsArray{j}{k},CC2.PixelIdxList{l}))/length(union(CCPixelsArray{j}{k},CC2.PixelIdxList{l}));
                    %else
                    %subScoresForObj(end+1)=0;
                    %end
                end
                subScoreForObj=min(subScoresForObj);
                subScoreForObjMean=min(subScoresForObjMean);
                if isempty(indicesOfOtherResThatOverlapOneRes)
                    subScoreForObj=Inf;
                    subScoreForObjMean=Inf;
                end
                resultsIndex=resultsIndex+1;
                %resultsBoundary(o,i,resultsIndex)=subScoreForObj;
                resultsBoundary{o}{i}(end+1)=subScoreForObj;
                resultsBoundaryMean{o}{i}(end+1)=subScoreForObjMean;
                if subScoreForObj>0.5
                    j;
                    totalNumDetectedObjects=totalNumDetectedObjects+1;
                end
            end
            %pause
        end
        %resultsBoundary(o,i)=totalNumDetectedObjects/totalNumObjects;
    end
end
toc