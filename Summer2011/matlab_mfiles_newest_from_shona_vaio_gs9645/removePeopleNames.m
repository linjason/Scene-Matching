% looks for SU tags that contain any of these common names
% used to find common people names in SU scenes, to remove later

commonNames={'smith','johnson','william','jones','davis','miller','bryce','wilson','moore','taylor','andreson','thomas','jackson','harris','martin',...
    'thompson','garcia','martinez','robinson','mary','patricia','linda','barbara','liz','elizabeth','jennifer','maria','susan','margaret','dorothy','james.john','robert',...
    'michael','williams','david','richard','charles','joseph','thomas','lisa','nancy','karen','betty','helen','sandra','donna','carol','ruth','sharon','michelle',...
    'laura','sarah','kimberly','deborah','chris','daniel','scott','paul','mark','donald','george','kenneth','steven','edward','brian','ronald','anthony','kevin'...
    ,'jason','jeff','carter','nelson','adams','mitchell','roberts','parker','evans','edward','collins','woman','women','man','child','kid','toddler'};
k=0;
for i=1:length(C)
    for j=1:length(commonNames)
        if ~isempty(strfind(lower(C{i}{7}),commonNames{j}))
            C{i}{7}
        k=k+1;
        break;
        end
    end
end