 function varargout = saveKinectImages(varargin)
% SAVEKINECTIMAGES M-file for saveKinectImages.fig
%      SAVEKINECTIMAGES, by itself, creates a new SAVEKINECTIMAGES or raises the existing
%      singleton*.
%
%      H = SAVEKINECTIMAGES returns the handle to a new SAVEKINECTIMAGES or the handle to
%      the existing singleton*.
%
%      SAVEKINECTIMAGES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVEKINECTIMAGES.M with the given input arguments.
%
%      SAVEKINECTIMAGES('Property','Value',...) creates a new SAVEKINECTIMAGES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before saveKinectImages_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to saveKinectImages_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help saveKinectImages

% Last Modified by GUIDE v2.5 19-Jul-2011 23:55:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @saveKinectImages_OpeningFcn, ...
    'gui_OutputFcn',  @saveKinectImages_OutputFcn, ...
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


% --- Executes just before saveKinectImages is made visible.
function saveKinectImages_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saveKinectImages (see VARARGIN)

% Choose default command line output for saveKinectImages
handles.output = hObject;
%sample_niImage
%pause(5)
disp('33')
disp(handles)

handles.context = mxNiCreateContext('Config/SamplesConfig_HighRes.xml');
handles.i=0;

%disp(handles)
% Update handles structure
guidata(hObject, handles);

function refreshDepthDisplay(obj, event, handles, ax)
option.adjust_view_point = true;
mxNiUpdateContext(handles.context, option);
[rgb, depth] = mxNiImage(handles.context);
%depth=rand(100)*100;
%rgb=rand(100)*100;
%disp(handles)
%disp(hObject)
axes(ax)
imagesc((depth),'parent',handles.axes1)
imagesc((rgb),'parent',handles.axes2)
%guidata(hObject, handles);

% UIWAIT makes saveKinectImages wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = saveKinectImages_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

option.adjust_view_point = true;
mxNiUpdateContext(handles.context, option);
[rgb, depth] = mxNiImage(handles.context);
%depth=rand(100)*100;
%rgb=rand(100)*100;
axes(handles.axes1)
handles.i=handles.i+1
fileNameDepth=strcat(datestr(now,'mmmmdd_HHMMSS'), '_depth');
fileNameRGB=strcat(datestr(now,'mmmmdd_HHMMSS'), 'rgb');
save(strcat(fileNameDepth,'.mat'),'depth')
save(strcat(fileNameRGB,'.mat'),'rgb')
%hh=get(gcf,'CurrentAxes')
imagesc((depth), 'parent', handles.axes3)
imagesc((rgb), 'parent', handles.axes4)
%set(handles.axes1,'CData',depth)
guidata(hObject, handles);
%plot(depth)


% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to depth=magic(100)be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
t = timer('StartDelay', .5, 'Period', 1, 'TasksToExecute', 100,'ExecutionMode', 'fixedRate')
t.TimerFcn = {@refreshDepthDisplay,handles, handles.axes1};
start(t)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
