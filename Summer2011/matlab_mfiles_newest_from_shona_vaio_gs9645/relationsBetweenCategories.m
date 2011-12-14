%distances between object categories
distances=cell(0);
relations=zeros(0,2);
nearCompsInfo=cell(0,0);
for i=1:length(taggedGroups)
    i
    for j=i:length(taggedGroups)
        j
        nearCompsInfo{i,j}=0;
        relations(end+1,1)=i;
        relations(end,2)=j;
        distances{end+1}=zeros(0,2);
        for k=1:length(taggedGroups{i})
            for l=1:length(taggedGroups{j})
                oneObj=taggedGroups{i}(k);
                otherObj=taggedGroups{j}(l);
                if ~isequal(C{oneObj}{1},C{otherObj}{1}) || oneObj==otherObj
                    continue;
                end
                oneObjMid=(C{oneObj}{4}+C{oneObj}{3})/2;
                otherObjMid=(C{otherObj}{4}+C{otherObj}{3})/2;
                distances{end}(end+1,1)=abs(oneObjMid(1)-otherObjMid(1))+abs(oneObjMid(2)-otherObjMid(2));
                distances{end}(end,2)=((oneObjMid(1)-otherObjMid(1))^2 + (oneObjMid(2)-otherObjMid(2))^2)^.5;
                distances{end}(end,3)=min([abs(C{oneObj}{4}(1)-C{otherObj}{4}(1)),abs(C{oneObj}{3}(1)-C{otherObj}{3}(1)),abs(C{oneObj}{3}(2)-C{otherObj}{3}(2)),abs(C{oneObj}{4}(2)-C{otherObj}{4}(2))] );
                distances{end}(end,4)=min([abs(C{oneObj}{4}(1)-C{otherObj}{3}(1)),abs(C{oneObj}{4}(2)-C{otherObj}{3}(2)),abs(C{otherObj}{4}(1)-C{oneObj}{3}(1)),abs(C{otherObj}{4}(2)-C{oneObj}{3}(2))]);
                
                % distance between closest pixels between two objs
                oneObjMinX=C{oneObj}{3}(1);
                oneObjMaxX=C{oneObj}{4}(1);
                oneObjMinY=C{oneObj}{3}(2);
                oneObjMaxY=C{oneObj}{4}(2);
                otherObjMinX=C{otherObj}{3}(1);
                otherObjMaxX=C{otherObj}{4}(1);
                otherObjMinY=C{otherObj}{3}(2);
                otherObjMaxY=C{otherObj}{4}(2);
                
                %distance between corners
                potDistances=zeros(0);
                oneObjCorners=[oneObjMinX oneObjMinY;oneObjMinX oneObjMaxY;oneObjMaxX oneObjMinY;oneObjMaxX oneObjMaxY];
                otherObjCorners=[otherObjMinX otherObjMinY;otherObjMinX otherObjMaxY;otherObjMaxX otherObjMinY;otherObjMaxX otherObjMaxY];
                oneObj;
                otherObj;
                for kk=1:4
                    for ll=1:4
                        potDistances(end+1)=((oneObjCorners(ll,1)-otherObjCorners(kk,1))^2+(oneObjCorners(ll,2)-otherObjCorners(kk,2))^2)^.5;
                    end
                end
                
                if otherObjMinX>oneObjMaxX&&otherObjMaxY>oneObjMinY&&otherObjMinY<oneObjMaxY
                    potDistances(end+1)=otherObjMinX-oneObjMaxX;
                end
                if otherObjMaxX<oneObjMinX&&otherObjMaxY>oneObjMinY&&otherObjMinY<oneObjMaxY
                    potDistances(end+1)=oneObjMinX-otherObjMaxX;
                end
                if otherObjMinY>oneObjMaxY&&otherObjMaxX>oneObjMinX&&otherObjMinX<oneObjMaxX
                    potDistances(end+1)=otherObjMinY-oneObjMaxY;
                end
                if otherObjMaxY<oneObjMinY&&otherObjMaxX>oneObjMinX&&otherObjMinX<oneObjMaxX
                    potDistances(end+1)=oneObjMinY-otherObjMaxY;
                end
                distances{end}(end,5)=min(potDistances);
                distances{end}(end,6)=oneObj;
                distances{end}(end,7)=otherObj;
                
                if min(potDistances)<60
                    nearCompsInfo{i,j}=nearCompsInfo{i,j}+1;
                end
                
            end
        end
    end
end




% which components are near other components
% nearCompsInfo=cells(0,0);
% for i=1:length(taggedGroups)
%     i
%     for j=i+1:length(taggedGroups)
%         j
% %         relations(end+1,1)=i;
% %         relations(end,2)=j;
%         distances{end+1}=zeros(0,2);
%         for k=1:length(taggedGroups{i})
%             for l=1:length(taggedGroups{j})
%                 oneObj=taggedGroups{i}(k);
%                 otherObj=taggedGroups{j}(l);
%                 if ~isequal(C{oneObj}{1},C{otherObj}{1}) || oneObj==otherObj
%                     continue;
%                 end
%
%                 if C{oneObj}{4}(3)-C{otherObj}{4}(3)
%
%
%             end
%         end
%     end
% end