function varargout = decompress_gui(varargin)
% GUI_DEC MATLAB code for gui_dec.fig
%      GUI_DEC, by itself, creates a new GUI_DEC or raises the existing
%      singleton*.
%
%      H = GUI_DEC returns the handle to a new GUI_DEC or the handle to
%      the existing singleton*.
%
%      GUI_DEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DEC.M with the given input arguments.
%
%      GUI_DEC('Property','Value',...) creates a new GUI_DEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_dec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_dec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_dec

% Last Modified by GUIDE v2.5 16-Apr-2017 23:41:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_dec_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_dec_OutputFcn, ...
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


% --- Executes just before gui_dec is made visible.
function gui_dec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_dec (see VARARGIN)

% Choose default command line output for gui_dec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_dec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_dec_OutputFcn(hObject, eventdata, handles) 
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
% function mov = decode_file
fileID = fopen('cmpt365.mrg','rb');
% 
w = fread(fileID, 1, 'uint8');
h = fread(fileID, 1, 'uint8');
nf = fread(fileID, 1, 'uint8');
% Loop over frames
pf = [];
wb = waitbar(0,'Please wait...', 'Name', 'Decompressing');
for i = 1:nf    
    ftype = char(fread(fileID, 1, 'int8'));   
    f = decode_frame(fileID,ftype,pf,w,h);
    pf = f;
    f = ycc2rgb(f);
    % Store frame
    mov(:,:,:,i) = uint8(f);
    waitbar(i/nf);    
end
close(wb);
fclose(fileID);

for i = 1:size(mov,4)
    m(i).cdata = uint8([mov(:,:,:,i)]);
    m(i).colormap = [];
end

movie(m, 5000, 30);