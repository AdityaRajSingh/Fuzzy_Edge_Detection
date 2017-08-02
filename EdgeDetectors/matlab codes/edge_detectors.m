function varargout = edge_detectors(varargin)
% EDGE_DETECTORS MATLAB code for edge_detectors.fig
%      EDGE_DETECTORS, by itself, creates a new EDGE_DETECTORS or raises the existing
%      singleton*.
%
%      H = EDGE_DETECTORS returns the handle to a new EDGE_DETECTORS or the handle to
%      the existing singleton*.
%
%      EDGE_DETECTORS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDGE_DETECTORS.M with the given input arguments.
%
%      EDGE_DETECTORS('Property','Value',...) creates a new EDGE_DETECTORS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edge_detectors_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edge_detectors_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edge_detectors

% Last Modified by GUIDE v2.5 02-Aug-2017 15:36:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @edge_detectors_OpeningFcn, ...
    'gui_OutputFcn',  @edge_detectors_OutputFcn, ...
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


% --- Executes just before edge_detectors is made visible.
function edge_detectors_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edge_detectors (see VARARGIN)

% Choose default command line output for edge_detectors
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edge_detectors wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = edge_detectors_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load the images
global im Igray Gx Gy Gmag Gdir Idouble
[filename, user_canceled] = imgetfile();
if user_canceled
    msgbox(sprintf('Error: no image is selected'),'Error','Error');
    return
end
im = imread(filename);
% input image is grayscale or not. If not then convert grayscale and double
% presision
if size(im,3)==3
    Igray = rgb2gray(im);
    Idouble = im2double(Igray);
else
    Igray = im; % for compatibility
    Idouble = im2double(im);
end

[Gx,Gy] = imgradientxy(Idouble,'Sobel'); % directional gradient of the image
% Calculate the gradient magnitude and direction using the directional gradients
[Gmag, Gdir] = imgradient(Gx, Gy);
axes(handles.imgshow);
imshow(im);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% reset button
global im
axes(handles.imgshow);
imshow(im)

% --- Executes on button press in graylevel.
function graylevel_Callback(hObject, eventdata, handles)
% hObject    handle to graylevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% converts into the gray scale
global Igray im_write
im_write = Igray; % for 'save to file' option
axes(handles.imgshow);
imshow(Igray);

% --- Executes on button press in histogram.
function histogram_Callback(hObject, eventdata, handles)
% hObject    handle to histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% shows the histogram of the image
global Igray
axes(handles.imgshow);
imhist(Igray)

% --- Executes on button press in canny.
function canny_Callback(hObject, eventdata, handles)
% hObject    handle to canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% using canny edge detector
% Apply Canny Edge Detector to the image
global Igray im_write
BW_canny = edge(Igray,'canny');
im_write = BW_canny; % for 'save to file' option
axes(handles.imgshow);
imshow(BW_canny);

% --- Executes on button press in sobel.
function sobel_Callback(hObject, eventdata, handles)
% hObject    handle to sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Sobel operator
global Igray im_write
BW_sobel = edge(Igray,'Sobel');
im_write = BW_sobel;% for 'save to file' option
axes(handles.imgshow);
imshow(BW_sobel);

% --- Executes on button press in prewitt.
function prewitt_Callback(hObject, eventdata, handles)
% hObject    handle to prewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prewitt operator
global Igray im_write
BW_prewitt = edge(Igray,'Prewitt');
im_write = BW_prewitt ;% for 'save to file' option
axes(handles.imgshow);
imshow(BW_prewitt);

% --- Executes on button press in roberts.
function roberts_Callback(hObject, eventdata, handles)
% hObject    handle to roberts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Igray im_write
BW_roberts = edge(Igray,'Roberts');
im_write = BW_roberts ; % for 'save to file' option
axes(handles.imgshow);
imshow(BW_roberts);

% --- Executes on slider movement.
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Igray im im_write
thres = get(hObject,'Value'); % gets threshold value
set(handles.text3,'String',num2str(thres));
level = graythresh(im) ; % using OTSU method
set(handles.text4,'String',num2str(level*255));
threshed = Igray >= thres ; % if the input value is greater than thres value sets as 1
im_write = threshed ; % for 'save to file' option
axes(handles.imgshow);
imshow(threshed);

% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object deletion, before destroying properties.
function text3_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in log.
function log_Callback(hObject, eventdata, handles)
% hObject    handle to log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Finds edges by looking for zero-crossings after filtering I with
% a Laplacian of Gaussian filter.
global Igray im_write
BW_log = edge(Igray,'Log');
im_write = BW_log;  % for 'save to file' option
axes(handles.imgshow);
imshow(BW_log);

% --- Executes on button press in inverse.
function inverse_Callback(hObject, eventdata, handles)
% hObject    handle to inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Igray im_write
inverse = 255-Igray;
im_write = inverse ; % for 'save to file' option
axes(handles.imgshow);
imshow(inverse);

% --- Executes on button press in Gx.
function Gx_Callback(hObject, eventdata, handles)
% hObject    handle to Gx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% directional gradient of image to locate breaks in uniform regions
global Gx im_write
axes(handles.imgshow);
im_write = Gx;  % for 'save to file' option
imshow (Gx,[]);

% --- Executes on button press in Gy.
function Gy_Callback(hObject, eventdata, handles)
% hObject    handle to Gy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Gy im_write
axes(handles.imgshow);
im_write = Gy;  % for 'save to file' option
imshow (Gy,[]); % [] means that the display range is min(Gy(:)) to max(Gy(:))


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close all;

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_write
imwrite(im_write,'result.png');

% --- Executes on button press in kirsch.
function kirsch_Callback(hObject, eventdata, handles)
% hObject    handle to kirsch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The Kirsch operator
global Igray im_write kirsch_im
% Igray is grayscale of the original image
im_double=double(Igray);
% Eight directions Kirsch edge masks. below masks are gettting from
% rotation of the one mask.
g1=[5,5,5; -3,0,-3; -3,-3,-3]; % South
g2=[5,5,-3; 5,0,-3; -3,-3,-3]; % Southeast
g3=[5,-3,-3; 5,0,-3; 5,-3,-3]; % East
g4=[-3,-3,-3; 5,0,-3; 5,5,-3]; %
g5=[-3,-3,-3; -3,0,-3; 5,5,5];
g6=[-3,-3,-3; -3,0,5;-3,5,5];
g7=[-3,-3,5; -3,0,5;-3,-3,5];
g8=[-3,5,5; -3,0,5;-3,-3,-3];
% filtering with Kirsch mask
% edges in all the direction
%     Each mask respondsmaximally to an edge oriented in a particular general
%     direction. The maximum value over all eight orientations
%     is the output value for the edge magnitude image.
x1=imfilter(im_double,g1,'replicate');
x2=imfilter(im_double,g2,'replicate');
x3=imfilter(im_double,g3,'replicate');
x4=imfilter(im_double,g4,'replicate');
x5=imfilter(im_double,g5,'replicate');
x6=imfilter(im_double,g6,'replicate');
x7=imfilter(im_double,g7,'replicate');
x8=imfilter(im_double,g8,'replicate');

y1=max(x1,x2);
y2=max(y1,x3);
y3=max(y2,x4);
y4=max(y3,x5);
y5=max(y4,x6);
y6=max(y5,x7);
kirsch_im=max(y6,x8); % result image
axes(handles.imgshow);
im_write = kirsch_im;  % for 'save to file' option
% image mapping in the interval of 0 to 255
kirsch_im = (255)*((kirsch_im-min(kirsch_im(:)))/(max(kirsch_im(:))-min(kirsch_im(:))));
imshow (kirsch_im,[]);

% --- Executes on button press in mag_of_grad.
function mag_of_grad_Callback(hObject, eventdata, handles)
% hObject    handle to mag_of_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_write Gmag
axes(handles.imgshow);
im_write = Gmag;  % for 'save to file' option
imshow(Gmag,[])

% --- Executes on slider movement.
function sliderkirsch_Callback(hObject, eventdata, handles)
% hObject    handle to sliderkirsch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im_write kirsch_im
thres = get(hObject,'Value'); % gets threshold value
set(handles.text3,'String',num2str(thres));
threshed = kirsch_im >= thres ; % if the input value is greater than thres value sets as 1
im_write = threshed ; % for 'save to file' option
axes(handles.imgshow);
imshow(threshed);

% --- Executes during object creation, after setting all properties.
function sliderkirsch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderkirsch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in dir_of_grad.
function dir_of_grad_Callback(hObject, eventdata, handles)
% hObject    handle to dir_of_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_write Gdir
axes(handles.imgshow);
im_write = Gdir;  % for 'save to file' option
imshow(Gdir,[])





% --- Executes on button press in twobytwosliding.
function twobytwosliding_Callback(hObject, eventdata, handles)
% hObject    handle to twobytwosliding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_write Idouble Gmag_SlidingMethod

% Mamdani FIS will be used to make decision on set edge or background
fis = newfis('2x2window');
% 2x2 sliding window has 4 pixel elemets
% first input
fis = addvar(fis, 'input', 'p1', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 1, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 1, 'white', 'trimf', [0 255 255]);
% second input
fis = addvar(fis, 'input', 'p2', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 2, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 2, 'white', 'trimf', [0 255 255]);
% third input
fis = addvar(fis, 'input', 'p3', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 3, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 3, 'white', 'trimf', [0 255 255]);
% fourth input
fis = addvar(fis, 'input', 'p4', [0 255]); % for gray level 0 to 255
fis = addmf(fis, 'input', 4, 'black', 'trimf', [0 0 255]);
fis = addmf(fis, 'input', 4, 'white', 'trimf', [0 255 255]);
% output
fis = addvar(fis, 'output', 'pout', [0 255]); % for gray level 0 to 1
fis = addmf(fis, 'output', 1, 'black', 'trimf', [0 0 70]);
fis = addmf(fis, 'output', 1, 'edge', 'trimf', [90 130 170]);
fis = addmf(fis, 'output', 1, 'white', 'trimf', [200 255 255]);

% if there is 3B and 1W in the window or vice versa, set the output as edge
% 3B(3W) and 1W(1B) set the output as E
% if there is 2W and 2B in the window, set the output as edge
rules = [1 1 1 1 1 1 1; % B B B B -> B
    1 1 1 2 2 1 1; % B B B W -> E
    1 1 2 1 2 1 1; % B B W B -> E
    1 1 2 2 2 1 1; % B B W W -> E
    1 2 1 1 2 1 1; % B W B B -> E
    1 2 1 2 2 1 1; % B W B W -> E
    1 2 2 1 2 1 1; % B W W B -> E
    1 2 2 2 3 1 1; % B W W W -> W
    2 1 1 1 1 1 1; % W B B B -> E
    2 1 1 2 2 1 1; % W B B W -> E
    2 1 2 1 2 1 1; % W B W B -> E
    2 1 2 2 2 1 1; % W B W W -> E
    2 2 1 1 2 1 1; % W W B B -> E
    2 2 1 2 2 1 1; % W W B W -> E
    2 2 2 1 2 1 1; % W W W B -> E
    2 2 2 2 3 1 1];% W W W W -> W
fis = addrule(fis, rules);
% % optional
% % rules of the system
% showrule(fis)
% figure
% plotfis(fis)
% %  Open Rule Viewer
% ruleview(fis)
% %  Open Surface Viewer
% surfview(fis)
[m, n] = size(Idouble);
Iout = zeros(m-1, n-1);
for i=1: m-1
    for j=1: n-1
        sub_window = Idouble(i:i+1,j:j+1);
        p1(i,j) = sub_window(1,1);
        p2(i,j) = sub_window(1,2);
        p3(i,j) = sub_window(2,1);
        p4(i,j) = sub_window(2,2);
    end
end

for i = 1:size(p1,1)
    Iout(i,:) = evalfis([p1(i,:); p2(i,:); p3(i,:); p4(i,:)],fis);
end

% First derivative of the image
[Gmag_SlidingMethod, ~] = imgradient(Iout);
Gmag_SlidingMethod = (255)*((Gmag_SlidingMethod-min(Gmag_SlidingMethod(:)))/(max(Gmag_SlidingMethod(:))-min(Gmag_SlidingMethod(:)))); % map into the range of 0 to 255
% default threshold value is 30
thresh = 30; % threshold value for output of the 'evalfis'
% threshold value can be changed for the best reult
axes(handles.imgshow);
Ibin = Gmag_SlidingMethod<thresh; % binary
im_write = 1- Ibin;  % for 'save to file' option
imshow(1-Ibin,[])

% --- Executes on button press in gradientmethod.
function gradientmethod_Callback(hObject, eventdata, handles)
% hObject    handle to gradientmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Idouble Igray im_write Ieval
[m, n] = size(Idouble);
% First step:
% Gradient of an image and mapping into 0 to 100

[Gx,Gy] = imgradientxy(Idouble,'Sobel'); % directional gradient of the image
% Calculate the gradient magnitude and direction using the directional gradients
[Gmag, Gdir] = imgradient(Gx, Gy);

% mapping Gmag into the 0 to 100
Gmag = (100)*((Gmag-min(Gmag(:)))/(max(Gmag(:))-min(Gmag(:)))); % map into the range of 0 to 100

% Second step:
% SD of each pixel and mapping into 0 to 100
SD = stdfilt(Igray);
% Brighter pixels in the filtered image correspond to neighborhoods in the
% original image with larger standard deviations.

% mapping Isd into the 0 to 100
SD = (100)*((SD-min(SD(:)))/(max(SD(:))-min(SD(:)))); % map into the range of 0 to 100

% Third step
% Create a fuzzy inference system (FIS)using two inputs
% There will two inputs and each of them will have three fuzzy sets that
% describe the edginess

fis = newfis('EdgeDetection');
% interval mapping
% First Input
% Specify the image magnitude of the gradient
fis = addvar(fis,'input','Gmag',[0 100]);
fis = addmf(fis,'input',1,'low','trapmf',[0 0 20 40]);
fis = addmf(fis,'input',1,'medium','trapmf',[20 40 60 80]);
fis = addmf(fis,'input',1,'high','trapmf',[60 80 100 100]);

title('using gradient magnitude to create first input variable')
% Standart Deviation of each pixel
fis = addvar(fis,'input','SD',[0 100]);
fis = addmf(fis,'input',2,'low','trapmf',[0 0 20 40]);
fis = addmf(fis,'input',2,'medium','trapmf',[20 40 60 80]);
fis = addmf(fis,'input',2,'high','trapmf',[60 80 100 100]);
title('using Standart Deviatione to create second input variable')
% output of the FIS
fis = addvar(fis,'output','edginess',[0 1]);
fis = addmf(fis,'output',1,'black','trapmf',[0 0 .25 .5]);
fis = addmf(fis,'output',1,'gray','trimf',[.25 .5 .75]);
fis = addmf(fis,'output',1,'white','trapmf',[.5 .75 1 1]);

% Fourth step:
% Specify and apply rules to the system
rules = [1 1 1 1 1; % L L -> L
        1 2 1 1 1; % L M -> L
        1 3 2 1 1; % L H -> M
        2 1 1 1 1; % M L -> L
        2 2 3 1 1; % M M -> M
        2 3 3 1 1; % M H -> H
        3 1 2 1 1; % H L -> M
        3 2 3 1 1; % H M -> H
        3 3 3 1 1];% L H -> H

fis = addrule(fis, rules);
% Evaluate the output of the edge detector for each row of pixels in I using
% corresponding rows of Gmag and SD as inputs.
Ieval = zeros(m, n);
for i = 1:m
    Ieval(i,:) = evalfis([(Gmag(i,:)); (SD(i,:));]',fis);
end
Ieval = (255)*((Ieval-min(Ieval(:)))/(max(Ieval(:))-min(Ieval(:)))); % map into the range of 0 to 255

axes(handles.imgshow);
Ithre = Ieval < 30; % make binary with threshold value (30)
im_write = 1 - Ithre;  % for 'save to file' option
imshow(1-Ithre,[])


% --- Executes on slider movement.
function slider15_Callback(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im_write Gmag_SlidingMethod
thres = get(hObject,'Value'); % gets threshold value
set(handles.text3,'String',num2str(thres));
threshed = Gmag_SlidingMethod <= thres ; % if the input value is greater than thres value sets as 1
im_write = 1- threshed ; % for 'save to file' option
axes(handles.imgshow);
imshow(1-threshed,[]);

% --- Executes during object creation, after setting all properties.
function slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderforgradient_Callback(hObject, eventdata, handles)
% hObject    handle to sliderforgradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im_write Ieval
thres = get(hObject,'Value'); % gets threshold value
set(handles.text3,'String',num2str(thres));
threshed = Ieval <= thres ; % if the input value is greater than thres value sets as 1
im_write = 1- threshed ; % for 'save to file' option
axes(handles.imgshow);
imshow(1-threshed,[]);

% --- Executes during object creation, after setting all properties.
function sliderforgradient_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderforgradient (see GCBO)
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
