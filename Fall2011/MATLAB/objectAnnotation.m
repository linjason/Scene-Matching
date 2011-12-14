function varargout = objectAnnotation(varargin)
% OBJECTANNOTATION M-file for objectAnnotation.fig
%      OBJECTANNOTATION, by itself, creates a new OBJECTANNOTATION or raises the existing
%      singleton*.
%
%      H = OBJECTANNOTATION returns the handle to a new OBJECTANNOTATION or the handle to
%      the existing singleton*.
%
%      OBJECTANNOTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OBJECTANNOTATION.M with the given input arguments.
%
%      OBJECTANNOTATION('Property','Value',...) creates a new OBJECTANNOTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before objectAnnotation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to objectAnnotation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help objectAnnotation

% Last Modified by GUIDE v2.5 09-Oct-2011 01:36:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @objectAnnotation_OpeningFcn, ...
    'gui_OutputFcn',  @objectAnnotation_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before objectAnnotation is made visible.
function objectAnnotation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to objectAnnotation (see VARARGIN)

% Choose default command line output for objectAnnotation
handles.output = hObject;
load bedrooms_livingrooms_2_hotel_withSMALL_BDLR3_with_dist_nametags.mat
load pointerFromAtoC_BDLR23_hotel_withSmall.mat
load mapOfCompToVarshaCategory_withSmallBDLR_hotel_BDLR3_newTagged_tableFromCouch_withManualAnnot.mat
handles.C=C;
handles.ptr=pointerFromAtoC;
handles.map=mapOfCompToVarshaCategory;
catHelp=mapOfCompToVarshaCategory('help');
set(handles.text7,'String',[num2str([1:17]') repmat(': ',17,1) char(catHelp{2:18,2})]);

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using objectAnnotation.
if strcmp(get(hObject,'Visible'),'off')
    plot(0);
end

% UIWAIT makes objectAnnotation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = objectAnnotation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
%set(gcf, 'Renderer', 'opengl')
cla;

edit_get_string = get(handles.edit1, 'String'); % scene name
fprintf('You entered scene name: %s\n',char(edit_get_string));
if exist(char(strcat('./results_mat_1/',edit_get_string)),'file')==2
    disp('Rendering scene...');
    clear A;
    load(char(strcat('./results_mat_1/',edit_get_string)))
    C=handles.C;
    ptr=handles.ptr;
    map=handles.map;
    ptrForThisScene=ptr(char(edit_get_string));
    mapForThisScene=map(char(edit_get_string));
    set(handles.edit7,'String',num2str(mapForThisScene{1,6}));
    compTags=char(mapForThisScene{:,1});
    %stringToDisplay=[num2str([1:size(mapForThisScene,1)]') repmat('   ',size(mapForThisScene,1),1) ...
    %compTags(:,1:min(20,end)) repmat('   ',size(mapForThisScene,1),1) num2str(cell2mat(mapForThisScene(:,2))) ...
    %repmat('   ',size(mapForThisScene,1),1) num2str(cell2mat(mapForThisScene(:,4)))]; %display of comp number and cat
    strToDisplayHTML=cell(0);
    colors = hsv(size(A, 2) - 1);
    drawnow
    % draw the components
    for compsIndex = 1:size(A, 2) - 1
        fprintf('Rendering component %d of %d.....',compsIndex,size(A, 2) - 1);
        if isequal(size(A{compsIndex}),[1 1])
            strToDisplayHTML{end+1}='';
            disp('Component does not exist, skipping');
            continue;
        end
        thisCompIdxInX=ptrForThisScene{compsIndex,1};
        if C{thisCompIdxInX}{3}(3)-C{thisCompIdxInX}{5}>12*2,
            strToDisplayHTML{end+1}='';
            disp('Component more than 2 feet off ground, skipping');
            continue;
        end
        if C{thisCompIdxInX}{4}(3)-C{thisCompIdxInX}{3}(3)<12 ||...
                C{thisCompIdxInX}{4}(2)-C{thisCompIdxInX}{3}(2)<12 ||...
                C{thisCompIdxInX}{4}(1)-C{thisCompIdxInX}{3}(1)<12
            strToDisplayHTML{end+1}='';
            disp('Component too small, skipping');
            continue;
        end
        colorIndex = mod(compsIndex-1, 20)+1;
        for facesIndex = 1:2:size(A{compsIndex},2)-1
            if facesIndex>18000, fprintf('Too many faces, Aborting...'), break, end
            pointsTrans = A{compsIndex}{facesIndex};
            polygons = A{compsIndex}{facesIndex+1};
            patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', colors(colorIndex,:));
        end
        colorCodeHTML=reshape(num2str(dec2hex(round(255*colors(colorIndex,:)))'),1,[]);
        thisCompTag=mapForThisScene{compsIndex,1};
        strToDisplayHTML{end+1}=sprintf('<HTML><FONT color="%s">&#9607</FONT>%2d %s%s%2d&nbsp;%2d</HTML>',colorCodeHTML,compsIndex,...
            thisCompTag(1:min(20,end)),repmat('&nbsp;',1,20-length(thisCompTag(1:min(20,end)))+1),mapForThisScene{compsIndex,2},mapForThisScene{compsIndex,4});
        fprintf('done\n');
    end
    % draw component labels (component number/category) on top right corner
    % of component
    for compsIndex = 1:size(A, 2) - 1
        if compsIndex>size(ptr,1), break, end
        if isequal(size(A{compsIndex}),[1 1])
            continue;
        end
        thisCompIdxInX=ptrForThisScene{compsIndex,1};
        if C{thisCompIdxInX}{3}(3)-C{thisCompIdxInX}{5}>12*2, continue, end
        if C{thisCompIdxInX}{4}(3)-C{thisCompIdxInX}{3}(3)<12 ||...
                C{thisrCompIdxInX}{4}(2)-C{thisCompIdxInX}{3}(2)<12 ||...
                C{thisCompIdxInX}{4}(1)-C{thisCompIdxInX}{3}(1)<12, continue, end
        minPoint=C{thisCompIdxInX}{3};
        maxPoint=C{thisCompIdxInX}{4};
        %axPos = get(gca,'Position');
        %xMinMax = xlim;
        %yMinMax = ylim;
        %xPlot=(minPoint(1)+maxPoint(1))/2;
        %yPlot=(minPoint(2)+maxPoint(2))/2;
        %xAnnotation = axPos(1) + (xPlot - xMinMax(1))/(xMinMax(2)-xMinMax(1)) * axPos(3);
        %yAnnotation = axPos(2) + (yPlot - yMinMax(1))/(yMinMax(2)-yMinMax(1)) * axPos(4);
        %xlimm=xlim;ylimm=ylim;
        %annotation('textbox',[xAnnotation,yAnnotation, .1,.1],'String',strcat(num2str(compsIndex), num2str(2)))
        text(maxPoint(1),maxPoint(2), sprintf('%d/%d',compsIndex,mapForThisScene{compsIndex,2}),'BackgroundColor',[.7 .9 .7],'color','r','FontWeight','Bold');
    end
    % draw walls
    boundsWallsIndex = size(A, 2);
    for wallIndex = 1:2:size(A{boundsWallsIndex}{2},1) - 1
        onePoint = A{boundsWallsIndex}{2}(wallIndex, :);
        otherPoint = A{boundsWallsIndex}{2}(wallIndex + 1, :);
        drawEdge3d([onePoint otherPoint]);
    end
    disp('Finished rendering!')
    set(handles.text1, 'Style','list', 'String', strToDisplayHTML,'Value',1);
    %handles.strToDisplayHTML=strToDisplayHTML;
    %set(handles.text1,'Style','list', 'String', ...
    %{'<HTML><FONT color="FF00FF">&#9607&#9607Hellergwero</FONT></HTML>', ...
    %'worlregergerwergwd', ...
    %'<HTML><FONT color="blue">!!wergwergw!</FONT></HTML>'});
else
    errordlg('INVALID SCENE NAME','Error');
    disp('**********************INVALID SCENE NAME**********************')
end
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mapFromMyCategoriesToVarshas=containers.Map({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17},...
    {0,8,9, 12 ,10,11,12, 12 ,11,11,3,1,2,4,5,7,6,13});
edit_get_string2 = get(handles.edit2, 'String');
edit_get_string3 = get(handles.edit3, 'String');
compNumToChange=str2num(char(edit_get_string2));
compCatToChangeTo=str2num(char(edit_get_string3));
edit_get_string = get(handles.edit1, 'String');
if exist(char(strcat('./results_mat_1/',edit_get_string)),'file')==2
    C=handles.C;
    map=handles.map;
    mapForThisScene=map(char(edit_get_string));
    %update map
    if isnan(mapForThisScene{compNumToChange,4})
        % move auto generated tags to 4,5
        mapForThisScene{compNumToChange,4}=mapForThisScene{compNumToChange,2};
        mapForThisScene{compNumToChange,5}=mapForThisScene{compNumToChange,3};
    end
    % update 2,3 with manual tags
    mapForThisScene{compNumToChange,2}=compCatToChangeTo;
    mapForThisScene{compNumToChange,3}=mapFromMyCategoriesToVarshas(compCatToChangeTo);
    % update and save map
    newMap=map;
    newMap(char(edit_get_string))=mapForThisScene;
    handles.map=newMap;
    mapOfCompToVarshaCategory=newMap;
    save mapOfCompToVarshaCategory_withSmallBDLR_hotel_BDLR3_newTagged_tableFromCouch_withManualAnnot.mat mapOfCompToVarshaCategory
    %compTags=char(mapForThisScene{:,1});
    %stringToDisplay=[num2str([1:size(mapForThisScene,1)]') repmat('   ',size(mapForThisScene,1),1) ...
    %compTags(:,1:min(20,end)) repmat('   ',size(mapForThisScene,1),1) num2str(cell2mat(mapForThisScene(:,2))) ...
    %repmat('   ',size(mapForThisScene,1),1) num2str(cell2mat(mapForThisScene(:,4)))]; % update display of comp nums and cats
    %strToDisplayHTML=handles.strToDisplayHTML;
    %strToDisplayHTML{compNumToChange}=;
    %set(handles.text1, 'Style','list', 'String', strToDisplayHTML);
    fprintf('Updated component %d to category %d.\n',compNumToChange,compCatToChangeTo);
else
    errordlg('INVALID SCENE NAME','Error');
    disp('**********************INVALID SCENE NAME**********************')
end
guidata(hObject, handles);

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update database
pushbutton4_Callback(hObject, eventdata, handles)
% update figure
pushbutton1_Callback(hObject, eventdata, handles);


% --- Executes on selection change in text1.
function text1_Callback(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns text1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text1


index_selected = get(hObject,'Value');
set(handles.edit2, 'String', num2str(index_selected));


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

keys=handles.map.keys;
edit_get_string = get(handles.edit6, 'String'); % scene number
sceneNum=str2num(char(edit_get_string))
set(handles.edit6,'String',num2str(sceneNum+1));
set(handles.edit1,'String',keys{sceneNum});
pushbutton1_Callback(hObject, eventdata, handles)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scene_validity=str2num(char(get(handles.edit7, 'String')));
if scene_validity==1
    scene_validity=0;
else
    scene_validity=1;
end
fprintf('Changed scene validity to "%d".\n',scene_validity);
scene_name=char(get(handles.edit1, 'String'));
map=handles.map;
mapForThisScene=map(scene_name);
mapForThisScene{1,6}=scene_validity;
map(scene_name)=mapForThisScene;
set(handles.edit7, 'String', num2str(scene_validity));
mapOfCompToVarshaCategory=map;
handles.map=mapOfCompToVarshaCategory;
save mapOfCompToVarshaCategory_withSmallBDLR_hotel_BDLR3_newTagged_tableFromCouch_withManualAnnot.mat mapOfCompToVarshaCategory

guidata(hObject, handles);
