function realtimeVideo()
% Define frame rate
% Open figure
hFigure1=figure(1);
hFigure2=figure(2);
hFigure3=figure(3);
set(hFigure1,'Position', [50, 250, 400, 300]);
set(hFigure2,'Position', [550, 250, 400, 300]);
set(hFigure3,'Position', [950, 250, 400, 300]);

NumberFrameDisplayPerSecond=3;

% Set-up webcam video input
% For windows
vid = videoinput('winvideo', 1);
%vid=videoinput('winvideo',1,'YUY2_320x240'); %'YUY2_320x240');

% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',1);

% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);

% Get a rgb image
set(vid,'ReturnedColorSpace','rgb');

triggerconfig(vid, 'Manual');

% set up timer object
TimerData=timer('TimerFcn', {@FrameRateDisplay,vid},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
%TimerData2=timer('TimerFcn', {@FrameRateDisplay,vid2},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');

% Start video and timer object
start(vid);
start(TimerData);
%start(TimerData2);
% We go on until the figure1 is closed
uiwait(hFigure1);
%close all 
% Clean up everything
stop(TimerData);
%stop(TimerData2);
delete(TimerData);
%delete(TimerData2);
stop(vid);
delete(vid);


delete (figure(2))
delete (figure(3))


% clear persistent variables
clear realVideo;
% This function is called by the timer to display one frame of the figure

function FrameRateDisplay(~,~,vid)
persistent IM;
persistent handlesRaw;
persistent handlesEdge;
persistent handlesCor;
trigger(vid);
mode=0;
IM=getdata(vid,1,'uint8');

if isempty(handlesRaw)
   % if first execution, we create the figure objects
    %    subplot(1,2,1);
    %    % Plot first value
    %    subplot(1,2,2);
    %    HandlesEdge=image(BW);
 
     figure(1)
     handlesRaw=imagesc(IM);
     title('ORIGINAL');
  
     figure(2)
     handlesEdge=image(IM);
     title('EDGE DETECTION');

     figure(3)
     handlesCor=image(IM);
     title('COLOR DETECTION');
else
   % We only update what is needed
   BW1=rgb2gray(IM);
   %BW1 = edge(BW1,'Sobel');
   BW1 = edge(BW1,'Canny');
   BW2=createMask(IM,mode);
   
   set(handlesRaw,'CData',IM);
   set(handlesEdge, 'CData', repmat(BW1, [1 1 3]));
   set(handlesCor, 'CData', repmat(BW2, [1 1 3]));
   
   flushdata(vid);
   %saveimages([IM,BW1,BW2]);
    
end