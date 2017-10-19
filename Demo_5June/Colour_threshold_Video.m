function varargout = Colour_threshold_Video(varargin)
%      COLOUR_THRESHOLD_VIDEO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLOUR_THRESHOLD_VIDEO.M with the given input arguments.
%
%      COLOUR_THRESHOLD_VIDEO('Property','Value',...) creates a new COLOUR_THRESHOLD_VIDEO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Colour_threshold_Video_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Colour_threshold_Video_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help Colour_threshold_Video
% Last Modified by GUIDE v2.5 19-May-2017 15:25:22
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Colour_threshold_Video_OpeningFcn, ...
                   'gui_OutputFcn',  @Colour_threshold_Video_OutputFcn, ...
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


% --- Executes just before Colour_threshold_Video is made visible.
function Colour_threshold_Video_OpeningFcn(hObject,eventdata,handles,varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Colour_threshold_Video (see VARARGIN)
% Choose default command line output for Colour_threshold_Video
handles.output = hObject;
%Update handles structure
handles.red = 0;
handles.black = 1;
%handles.kernal=1;
handles.Stop = false;
handles.box=1;
%handles.snapshot=true;
handles.image=[];
handles.object=0;
handles.counter=1;
handles.stats=struct;
handles.area=0.0;
guidata(hObject, handles);


%UIWAIT makes Colour_threshold_Video wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Colour_threshold_Video_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, ~, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
%if (handles.buttonRed == true)||(handles.buttonOrange == true)||(handles.buttonYellow == true)||(handles.buttonGreen == true)||(handles.buttonBlue == true)||(handles.buttonPurple == true)|| (handles.buttonGrey == true)|| (handles.buttonInverse == true)
% Set the properties of the video object
handles.Stop=false;
guidata(hObject, handles);
imaqreset;
vid = videoinput('winvideo',1, 'YUY2_320x240');%'YUY2_320x240'
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
vid.FrameGrabInterval = 5;
start(vid);
axes(handles.axes1);

while(handles.Stop == false)
    data = getsnapshot(vid);
    Segout = data;
    if(handles.red==true)
        %[~,maskedRGBImage7]=createMaskdemored(data);
        [~,maskedRGBImage7]=createMasklab(data);
    end
    if(handles.black==true)
        [~,maskedRGBImage7]=createMaskdemoblack(data); 
    end
    
    I = rgb2gray(maskedRGBImage7);
    I = medfilt2(I, [3 3]);
    I = imbinarize(I,0.18);
    I = bwareaopen(I,2500); 
    [m,n,~]=size(I);
    rgb=zeros(m,n,3); 
    rgb(:,:,1)=I;
    rgb(:,:,2)=rgb(:,:,1);
    rgb(:,:,3)=rgb(:,:,1);
    Image=rgb/255; 
    BWoutline7 = bwperim(Image);
    Segout(BWoutline7) = 55;

    handles = guidata(hObject);
    imshow(Segout);
    hold on
    if handles.box==1
        %This is a loop to bound the red objects in a rectangular box.
        bw = bwlabel(I, 8);
        stats = regionprops(bw,'Centroid','area');
        handles.stats=stats;
        handles.object=length(stats);
        for object = 1:handles.object
            bc = stats(object).Centroid;
            ba=round(stats(object).Area)/100/8;
            plot(bc(1),bc(2), '-m+');
            a=text(bc(1)+15,bc(2),num2str(ba));
            set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 15, 'Color', 'yellow');
        end
        
    end   
    handles.image=data;
    guidata(hObject, handles);
    flushdata(vid);
end

% Both the loops end here.
% Stop the video aquisition.
%stop(vid);
% Clear all variables
clear all;
sprintf('%s','System Completed ')

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, ~, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Stop = true;
guidata(hObject, handles);



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, ~, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.box=true;
    %handles.Stop = false;
    disp(handles.box);
    guidata(hObject, handles);
else
	handles.box=false;
    %handles.Stop = false;
    disp(handles.box);
    guidata(hObject, handles);
end

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (ee GUIDATA)

for object = 1:handles.object
    ba=round(handles.stats(object).Area)/100/8;
    handles.area=(handles.area+ba);
    
end
t=date();
str=strcat('Database/#',num2str(handles.counter),'-',t,'-','area=',num2str(handles.area),'.jpg');
%str=strcat('Database/',t,'.jpg');
handles.counter=handles.counter+1;
imwrite(handles.image,str);
handles.area=0.0;
axes(handles.axes4);
imshow(handles.image);
axes(handles.axes1);
guidata(hObject, handles);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.kernal = uint8(get(hObject,'Value')*9)+1;
%myString = sprintf('Kernal%d', handles.kernal);
% set(handles.text6, 'String', myString);
%handles.text6=(handles.kernal);
caption = sprintf('Kernal Size = %d', handles.kernal);
set(handles.text6,'String',caption);
%disp(handles.kernal)
drawnow;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



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
% --- Executes during object creation, after setting all properties.


% --- Executes during object creation, after setting all properties.
function text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% myString = sprintf('Kernal%d', handles.kernal);
% set(handles.text6, 'String', myString);

guidata(hObject, handles);




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


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.red=true;
handles.black=false;
disp('red-grey');
guidata(hObject, handles);



% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.red=false;
handles.black=true;
disp('black-grey');
guidata(hObject, handles);

