i= 0;
currSceneEnd=0;
clear comps;
ee=zeros(0);
while currSceneEnd~=size(B,2)
    clear A
    bedNums=0;
    bedNums2=0;
    currSceneStart=currSceneEnd+1;
    currSceneEnd=currSceneStart+1;
    currSceneName=B{currSceneStart}{1};
    while (currSceneEnd<=size(B,2)&&isequal(B{currSceneEnd}{1},currSceneName) )
        currSceneEnd=currSceneEnd+1;
    end
    currSceneEnd=currSceneEnd-1;
    ee(end+1)=length(currSceneStart:currSceneEnd);
    for compIndex = currSceneStart:currSceneEnd
        tag = B{compIndex}{7};
        if (~isempty(findstr('bed',lower(tag))) && isempty(findstr('table',lower(tag))) && isempty(findstr('frame',lower(tag))) && isempty(findstr('room',lower(tag))) && isempty(findstr('tv',lower(tag))) && isempty(findstr('leg',lower(tag))) && isempty(findstr('pole',lower(tag))))
            tag;
            bedNums=bedNums+1;
            break;
        end
    end
    
    if bedNums==1
        for compIndex2 = currSceneStart:currSceneEnd
            tag2 = B{compIndex2}{7};
            if (~isempty(findstr('nightstand',lower(tag2))) ||~isempty(strfind(lower(tag2),'night stand'))||~isempty(strfind(lower(tag2),'bedside'))||~isempty(strfind(lower(tag2),'bed side')))
                tag2;
                bedNums2=bedNums2+1;
                i=i+1;
                comps{i}=[compIndex];
                i=i+1;
                comps{i}=[compIndex2];
                break;
            end
        end
    end
end
% x_dis=zeros(size(comps,2)/2,1);
% y_dis=zeros(size(comps,2)/2,1);
% for i=1:2:size(comps,2)
%     x_mid_1=(comps{i}{4}(1)-comps{i}{3}(1))/2;
%     y_mid_1=(comps{i}{4}(2)-comps{i}{3}(2))/2;
%     x_mid_2=(comps{i+1}{4}(1)-comps{i+1}{3}(1))/2;
%     y_mid_2=(comps{i+1}{4}(2)-comps{i+1}{3}(2))/2;
%     
%     
%     x_dis(round(i/2))=abs(x_mid_2-x_mid_1);
%     y_dis(round(i/2))=abs(y_mid_2-y_mid_1);
%     
%     
%     
% end