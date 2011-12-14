% generates mapping from our Sketchup categories to Varsha's
% categories
% running this script regenerates mappings for all mat files in
% results_ALL
% you are required to load the C cell array and taggedGroups(tags
% obtained via label transfer). You can use an empty taggedGroups if
% you do not want to include the label transferred tags

mapOfCompToVarshaCategory=containers.Map()
mapFromMyCategoriesToVarshas=containers.Map({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17},{8,9, 12 ,10,11,12, 12 ,11,11,3,1,2,4,5,7,6,13})
d_results = dir('../../results_ALL/');
tempKeys=cell(0);
tempValues=cell(0);
parfor fileIndex = 1:(length(d_results)-2)
    % clear A;
    matFile=load(strcat('../../results_ALL/', d_results(fileIndex+2).name));
    A=matFile.A;
    d_results(fileIndex+2).name
    
    valueCell=cell(length(A)-1,3);
    for i=1:length(A)-1
        valueCell{i,1}=A{i}{end};
        a=0;
        if (~isempty(strfind(lower(A{i}{end}),'dresser'))||~isempty(strfind(lower(A{i}{end}),'111armoire'))||~isempty(strfind(lower(A{i}{end}),'armadio'))||~isempty...
                (strfind(lower(A{i}{end}),'111armario'))||~isempty(strfind(lower(A{i}{end}),'111wardrobe')))&&isempty(strfind(lower(A{i}{end}),'lamp'))&&isempty(strfind...
                (lower(A{i}{end}),'room'))&&isempty(strfind(lower(A{i}{end}),'bed'))&&isempty(strfind(lower(A{i}{end}),'leg')) && isempty(strfind(lower(A{i}{end}),'convertable'))
            valueCell{i,2}=7;
       elseif ((~isempty(strfind(lower(A{i}{end}),'bed')) || ~isempty(strfind(lower(A{i}{end}),'bed'))|| ~isempty(strfind(lower(A{i}{end}),'bed')))&& isempty(strfind(lower(A{i}{end}),...
                'lateral')) && isempty(strfind(lower(A{i}{end}),'head')) && isempty(strfind(lower(A{i}{end}),'table')) && isempty(strfind(lower(A{i}{end}),'frame')) && isempty(strfind...
                (lower(A{i}{end}),'room')) && isempty(strfind(lower(A{i}{end}),'latte')) && isempty(strfind(lower(A{i}{end}),'tv')) && isempty(strfind(lower(A{i}{end}),'leg')) && isempty...
                (strfind(lower(A{i}{end}),'pole')))
            valueCell{i,2}=1;
       elseif ((~isempty(strfind(lower(A{i}{end}),'couch')) || ~isempty(strfind(lower(A{i}{end}),'sofa')))&& isempty(strfind(lower(A{i}{end}),'bed'))&& isempty(strfind(lower...
                (A{i}{end}),'table'))&& isempty(strfind(lower(A{i}{end}),'room'))&& isempty(strfind(lower(A{i}{end}),'frame'))&& isempty(strfind(lower(A{i}{end}),'down')))
            valueCell{i,2}=2;
        elseif (~isempty(strfind(lower(A{i}{end}),'nightstand')) ||~isempty(strfind(lower(A{i}{end}),'night stand'))||~isempty(strfind(lower(A{i}{end}),'nighttable'))||~isempty...
                (strfind(lower(A{i}{end}),'night table'))||~isempty(strfind(lower(A{i}{end}),'bedside'))) && isempty(strfind(lower(A{i}{end}),'lamp')) && isempty(strfind(lower...
                (A{i}{end}),'pole')) && isempty(strfind(lower(A{i}{end}),'pole')) && isempty(strfind(lower(A{i}{end}),'dresser')) && isempty(strfind(lower(A{i}{end}),'convertable'))
            valueCell{i,2}=8;
        elseif (~isempty(strfind(lower(A{i}{end}),'desk'))||~isempty(strfind(lower(A{i}{end}),'desk')))&&isempty(strfind(lower(A{i}{end}),'lamp'))&&isempty(strfind(lower(A{i}{end}),'bed'))...
                &&isempty(strfind(lower(A{i}{end}),'leg'))&&isempty(strfind(lower(A{i}{end}),'light'))&&isempty(strfind(lower(A{i}{end}),'convertable'))&&isempty(strfind(lower(A{i}{end}),...
                'phone'))&&isempty(strfind(lower(A{i}{end}),'deska'))&&isempty(strfind(lower(A{i}{end}),'desktop'))
            valueCell{i,2}=5;
        elseif (~isempty(strfind(lower(A{i}{end}),'table'))||~isempty(strfind(lower(A{i}{end}),'table')))&&isempty(strfind(lower(A{i}{end}),'lamp'))&&isempty(strfind(lower(A{i}{end}),'bed'))...
                &&isempty(strfind(lower(A{i}{end}),'leg'))&&isempty(strfind(lower(A{i}{end}),'light'))&&isempty(strfind(lower(A{i}{end}),'convertable'))&&isempty(strfind(lower(A{i}{end}),...
                'phone'))&&isempty(strfind(lower(A{i}{end}),'deska'))&&isempty(strfind(lower(A{i}{end}),'desktop'))
            valueCell{i,2}=9;
         elseif (~isempty(strfind(lower(A{i}{end}),'cabinet'))||~isempty(strfind(lower(A{i}{end}),'cabinet')))&&isempty(strfind(lower(A{i}{end}),'lamp'))&&isempty(strfind(lower(A{i}{end}),'bed'))...
                &&isempty(strfind(lower(A{i}{end}),'leg'))&&isempty(strfind(lower(A{i}{end}),'light'))&&isempty(strfind(lower(A{i}{end}),'convertable'))&&isempty(strfind(lower(A{i}{end}),...
                'phone'))&&isempty(strfind(lower(A{i}{end}),'deska'))&&isempty(strfind(lower(A{i}{end}),'desktop'))
            valueCell{i,2}=3;
        elseif (~isempty(strfind(lower(A{i}{end}),'chair'))||~isempty(strfind(lower(A{i}{end}),'chair')))&&isempty(strfind(lower(A{i}{end}),'lamp'))&&isempty(strfind(lower(A{i}{end}),'bed'))...
                &&isempty(strfind(lower(A{i}{end}),'leg'))&&isempty(strfind(lower(A{i}{end}),'light'))&&isempty(strfind(lower(A{i}{end}),'convertable'))&&isempty(strfind(lower(A{i}{end}),...
                'phone'))&&isempty(strfind(lower(A{i}{end}),'deska'))&&isempty(strfind(lower(A{i}{end}),'desktop'))
            valueCell{i,2}=4;
        elseif (~isempty(strfind(lower(A{i}{end}),'light'))||~isempty(strfind(lower(A{i}{end}),'lamp')))
            valueCell{i,2}=10;
        elseif (~isempty(strfind(lower(A{i}{end}),'door'))||~isempty(strfind(lower(A{i}{end}),'door')))
            valueCell{i,2}=11;
        elseif (~isempty(strfind(lower(A{i}{end}),'window'))||~isempty(strfind(lower(A{i}{end}),'window')))&&isempty(strfind(lower(A{i}{end}),'computer'))...
                &&isempty(strfind(lower(A{i}{end}),'laptop'))
            valueCell{i,2}=12;
        elseif (~isempty(strfind(lower(A{i}{end}),'picture'))||~isempty(strfind(lower(A{i}{end}),'picture')))
            valueCell{i,2}=13;
        elseif (~isempty(strfind(lower(A{i}{end}),'tv'))||~isempty(strfind(lower(A{i}{end}),'television')))
            valueCell{i,2}=14;
        elseif (~isempty(strfind(lower(A{i}{end}),'closet'))||~isempty(strfind(lower(A{i}{end}),'closet')))
            valueCell{i,2}=15;
        elseif (~isempty(strfind(lower(A{i}{end}),'drawer'))||~isempty(strfind(lower(A{i}{end}),'drawer')))&&isempty(strfind(lower(A{i}{end}),'leg'))
            valueCell{i,2}=6;
        end
        if length(A{i})==1
            valueCell{i,2}=NaN
        end
        if isempty(valueCell{i,2})
            strings={'bed','light','window','door','speaker','lamp','table', ...
                     'pillow','books','desk','arm','tv','vase','ceiling', ...
                     'drawer','man','cabinet','dresser','computer','joist', ...
                     'sink','sink','frame','box','toilet','couch', ...
                     'nightstand','sconce','mecate','handle','clock', ...
                     'curtain','blinds','plant','mirror','flatscreen', ...
                     'dining','rug','wardrobe','doorknob','phone','phone', ...
                     'estructura','sofa','guitar','chest','armoire','picture', ...
                     'stool','bathroom','laptop','basket','fan','apple', ...
                     'binder','bookcase','candle','carpet','print','heater', ...
                     'mattress','radiator','trash','bathtub','coat hanger','macbook','dryer','game','tree','bedside table','fireplace','chain','painting','locker','bear','shelving unit','rocker','piano bench','potrait','coat rack','sides','guitar stand','arcondicionado','cd player','crib','bible','pool table','projector','shower curtain','remote','stand','night','nighttable','bedside','side','armoire','armadio','armario','room','leg','chair'};
            for j=1:size(strings,2)
                if ~isempty(strfind(lower(A{i}{end}),strings{j}))
                    valueCell{i,2}=17;       
                    break;
               end
            end
            if isempty(valueCell{i,2})
                valueCell{i,2}=0;
            end
        end
    end
    %mapOfCompToVarshaCategory(d_results(fileIndex+2).name)=valueCell;
    tempKeys{fileIndex}=d_results(fileIndex+2).name;
    tempValues{fileIndex}=valueCell;
end

for fileIndex = 1:(length(d_results)-2)
mapOfCompToVarshaCategory(tempKeys{fileIndex})=tempValues{fileIndex};
end

for j=1:length(taggedGroups)
    tables=taggedGroups{j};
    for i=1:length(tables)
        mapValue=mapOfCompToVarshaCategory(C{tables(i)}{1});
        mapValueValue=mapValue(C{tables(i)}{2},2);
        if mapValueValue{:}<=0 ||  mapValueValue{:}==17
            if mapValueValue{:}==17
                i
            end
            mapValue(C{tables(i)}{2},2)={-j};
        end
        mapOfCompToVarshaCategory(C{tables(i)}{1})=mapValue;
    end
end

allKeys=keys(mapOfCompToVarshaCategory);
for i=1:length(allKeys)
    i
    allKeys{i}
    thisValue=mapOfCompToVarshaCategory(allKeys{i});
    theseValues=thisValue(:,2);
    disp('here')
    for j=1:length(theseValues)
        theseValues{j}
        if theseValues{j}==0
            thisValue{j,3}=0;
        elseif theseValues{j}>0
            thisValue{j,3}=mapFromMyCategoriesToVarshas(theseValues{j});
        elseif theseValues{j}<0
            thisValue{j,3}=-mapFromMyCategoriesToVarshas(-theseValues{j});
        elseif isnan(theseValues{j})
            thisValue{j,3}=NaN;
        end
    end
    allKeys{i}
    mapOfCompToVarshaCategory(allKeys{i})=thisValue;
end
mapOfCompToVarshaCategory('help')={'Our Categories', '';1,'bed';2,'couch';3,'cabinet';4,'chair';5,'desk';6,'drawer';7,'dresser';8,'nightstand';9,'table';10,'light';11,'door';...
                    12,'window';13,'picture';14,'tv';15,'closet';16,'bookshelf';17,'misc';'Varshas','';1,'door';2,'window';3,'lamp';4,'picutre';5,'tv';6,'bookshelf';7,'closet';8,'bed';9,'sofa';10,...
                    'chair';11,'table';12,'drawer';13,'misc'};