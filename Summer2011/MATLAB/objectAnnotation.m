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

% Last Modified by GUIDE v2.5 17-Sep-2011 20:36:54

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
load bedrooms_livingrooms_2_hotel_withSMALL_BDLR3_with_dist_nametags
load pointerFromAtoC_BDLR23_hotel_withSmall.mat
handles.C=C;
handles.ptr=pointerFromAtoC;
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using objectAnnotation.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
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
%figure(1)
cla;
disp(size(handles.C))
edit_get_string = get(handles.edit1, 'String');
disp(class(char(strcat('./results_mat_1/',edit_get_string))))
if exist(char(strcat('./results_mat_1/',edit_get_string)),'file')==2
    clear A;
    load(char(strcat('./results_mat_1/',edit_get_string)))
    %readInValues;
ptr=handles.ptr;
C=handles.C;
aaa=get(gcf,'CurrentAxes');

colors = hsv(20);
drawnow
for compsIndex = 17%1:size(A, 2) - 1
    if isequal(size(A{compsIndex}),[1 1])
        continue;
    end
    
    %disp(class(ptr))
    ptrForThisScene=ptr(char(edit_get_string));
    %disp(ptrForThisScene)
    thisCompIdxInX=ptrForThisScene{compsIndex,1};
    if C{thisCompIdxInX}{3}(3)-C{thisCompIdxInX}{5}>12*2, continue, end
    disp(compsIndex)
    disp(thisCompIdxInX)
    minPoint=C{thisCompIdxInX}{3};
    maxPoint=C{thisCompIdxInX}{4};
    
    colorIndex = mod(compsIndex-1, 20)+1;
    for facesIndex = 1:2:size(A{compsIndex},2)-1
        pointsTrans = A{compsIndex}{facesIndex};
        polygons = A{compsIndex}{facesIndex+1};
        patch('vertices', (pointsTrans), 'faces', abs(polygons'), 'facecolor', colors(colorIndex,:));
    end
    
    %text((minPoint(1)+maxPoint(1))/2, (minPoint(2)+maxPoint(2))/2, '222awgafgds','BackgroundColor',[.7 .9 .7]);
end
%xlim([-800 200])
%ylim([-200 1000])
for compsIndex = 17%1:size(A, 2) - 1
    if isequal(size(A{compsIndex}),[1 1])
        continue;
    end
    ptrForThisScene=ptr(char(edit_get_string));
    %disp(ptrForThisScene)
    thisCompIdxInX=ptrForThisScene{compsIndex,1};
    if C{thisCompIdxInX}{3}(3)-C{thisCompIdxInX}{5}>12*2, continue, end
    disp(compsIndex)
    disp(thisCompIdxInX)

    minPoint=C{thisCompIdxInX}{3};
    maxPoint=C{thisCompIdxInX}{4};
        disp(minPoint)
    disp(maxPoint)
    
    axPos = get(gca,'Position');
    disp(compsIndex)
    disp('axpos')
    disp(axPos)
   
    xMinMax = xlim;
yMinMax = ylim;
 disp(xMinMax(1))
  disp(xMinMax(2))
 disp(yMinMax(1))
  disp(yMinMax(2))
  disp(xlim('mode'))
xPlot=(minPoint(1)+maxPoint(1))/2;
yPlot=(minPoint(2)+maxPoint(2))/2;
%xPlot=-600;yPlot=-200;
  disp(xPlot)
  disp(yPlot)
xAnnotation = axPos(1) + (xPlot - xMinMax(1))/(xMinMax(2)-xMinMax(1)) * axPos(3);
yAnnotation = axPos(2) + (yPlot - yMinMax(1))/(yMinMax(2)-yMinMax(1)) * axPos(4);
disp(xAnnotation)
disp(yAnnotation)
%xlimm=xlim;ylimm=ylim;
%[xAnnotation, yAnnotation] = ds2nfu(aaa,xPlot, yPlot)
    %annotation('textbox',[xAnnotation,yAnnotation, .1,.1],'String',strcat(num2str(compsIndex), num2str(2)))
    %text((minPoint(1)+maxPoint(1))/2, (minPoint(2)+maxPoint(2))/2, '222awgafgds','BackgroundColor',[.7 .9 .7]);
    text((minPoint(1)+maxPoint(1))/2, (minPoint(2)+maxPoint(2))/2, strcat(num2str(compsIndex), num2str(2)),'color','r','FontWeight','Bold','BackgroundColor','w');
end
boundsWallsIndex = size(A, 2);
bounds = A{boundsWallsIndex}{1};

for wallIndex = 1:2:size(A{boundsWallsIndex}{2},1) - 1
    onePoint = A{boundsWallsIndex}{2}(wallIndex, :);
    otherPoint = A{boundsWallsIndex}{2}(wallIndex + 1, :);
    drawEdge3d([onePoint otherPoint]);
end



end
disp(edit_get_string)


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
