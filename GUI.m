function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 22-Feb-2018 15:02:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in subject_func.
function subject_button_Callback(hObject, eventdata, handles)
% hObject    handle to subject_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in run_func.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in scan_func.
function scan_button_Callback(hObject, eventdata, handles)
% hObject    handle to scan_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function structural_ds_Callback(hObject, eventdata, handles)
% hObject    handle to structural_ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of structural_ds as text
%        str2double(get(hObject,'String')) returns contents of structural_ds as a double


% --- Executes during object creation, after setting all properties.
function structural_ds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to structural_ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function struct_edit_Callback(hObject, eventdata, handles)
% hObject    handle to struct_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of struct_edit as text
%        str2double(get(hObject,'String')) returns contents of struct_edit as a double


% --- Executes during object creation, after setting all properties.
function struct_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to struct_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in subject_struct.
function subject_struct_Callback(hObject, eventdata, handles)
% hObject    handle to subject_struct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_string(handles.struct_edit, '{subjects}');

% --- Executes on button press in run_struct.
function run_struct_Callback(hObject, eventdata, handles)
% hObject    handle to run_struct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_string(handles.struct_edit, '{runs}');

% --- Executes on button press in scan_struct.
function scan_struct_Callback(hObject, eventdata, handles)
% hObject    handle to scan_struct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_string(handles.struct_edit, '{structurals}');

function func_edit_Callback(hObject, eventdata, handles)
% hObject    handle to func_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of func_edit as text
%        str2double(get(hObject,'String')) returns contents of func_edit as a double


% --- Executes during object creation, after setting all properties.
function func_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to func_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in subject_func.
function subject_func_Callback(hObject, eventdata, handles)
% hObject    handle to subject_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_string(handles.func_edit, '{subjects}');

% --- Executes on button press in run_func.
function run_func_Callback(hObject, eventdata, handles)
% hObject    handle to run_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_string(handles.func_edit, '{runs}');

% --- Executes on button press in scan_func.
function scan_func_Callback(hObject, eventdata, handles)
% hObject    handle to scan_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_string(handles.func_edit, '{scans}');

function add_string(handle, string)
% handle handle to add string to
% string string to add to end of handle
set(handle, 'String', [get(handle, 'String') string filesep])



function subject_strmatch_Callback(hObject, eventdata, handles)
% hObject    handle to subject_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subject_strmatch as text
%        str2double(get(hObject,'String')) returns contents of subject_strmatch as a double


% --- Executes during object creation, after setting all properties.
function subject_strmatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subject_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function run_strmatch_Callback(hObject, eventdata, handles)
% hObject    handle to run_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of run_strmatch as text
%        str2double(get(hObject,'String')) returns contents of run_strmatch as a double


% --- Executes during object creation, after setting all properties.
function run_strmatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scan_strmatch_Callback(hObject, eventdata, handles)
% hObject    handle to scan_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scan_strmatch as text
%        str2double(get(hObject,'String')) returns contents of scan_strmatch as a double


% --- Executes during object creation, after setting all properties.
function scan_strmatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scan_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subject_list.
function subject_list_Callback(hObject, eventdata, handles)
% hObject    handle to subject_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subject_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subject_list


% --- Executes during object creation, after setting all properties.
function subject_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subject_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in run_list.
function run_list_Callback(hObject, eventdata, handles)
% hObject    handle to run_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns run_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from run_list


% --- Executes during object creation, after setting all properties.
function run_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in scan_list.
function scan_list_Callback(hObject, eventdata, handles)
% hObject    handle to scan_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scan_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scan_list


% --- Executes during object creation, after setting all properties.
function scan_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scan_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in is_4D.
function is_4D_Callback(hObject, eventdata, handles)
% hObject    handle to is_4D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of is_4D


% --- Executes on button press in create_button.
function create_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% TODO: change this when you can change base directory
fs = NiftiFS(get(handles.working_directory, 'String'));
fs.set_is4D(get(handles.is_4D, 'Value'));
fs.set_functional_dirstruct(get(handles.func_edit, 'String'));
fs.set_structural_dirstruct(get(handles.struct_edit, 'String'));
fs.set_subject_strmatch(get(handles.subject_strmatch, 'String'));
fs.set_run_strmatch(get(handles.run_strmatch, 'String'));
fs.set_scan_strmatch(get(handles.scan_strmatch, 'String'));
fs.set_subjects;

set_lists(handles, fs);

handles.fs = fs;

guidata(hObject, handles);

function set_lists(handles, fs)
sa = fs.get_subject_array;
ids = sa.get_ids;
set(handles.subject_list, 'String', ids);

fs.set_runs;
run_ids = sa.get_run_ids;
run_ids = vertcat(run_ids{:});
set(handles.run_list, 'String', unique(run_ids));
scans = fs.get_functional_scans;
set(handles.scan_list, 'String',  strrep(scans, fs.top_level, ''));

structurals = fs.get_structural_scans;
set(handles.structural_list, 'String', strrep(structurals, fs.top_level, ''))


function structural_strmatch_Callback(hObject, eventdata, handles)
% hObject    handle to structural_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of structural_strmatch as text
%        str2double(get(hObject,'String')) returns contents of structural_strmatch as a double


% --- Executes during object creation, after setting all properties.
function structural_strmatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to structural_strmatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in structural_list.
function structural_list_Callback(hObject, eventdata, handles)
% hObject    handle to structural_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns structural_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from structural_list


% --- Executes during object creation, after setting all properties.
function structural_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to structural_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function working_directory_Callback(hObject, eventdata, handles)
% hObject    handle to working_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of working_directory as text
%        str2double(get(hObject,'String')) returns contents of working_directory as a double


% --- Executes during object creation, after setting all properties.
function working_directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to working_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', pwd);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
niftifs = handles.fs;
niftifs.saveas('niftifs');



function to_remove_Callback(hObject, eventdata, handles)
% hObject    handle to to_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to_remove as text
%        str2double(get(hObject,'String')) returns contents of to_remove as a double


% --- Executes during object creation, after setting all properties.
function to_remove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in to_remove_button.
function to_remove_button_Callback(hObject, eventdata, handles)
% hObject    handle to to_remove_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.to_remove, 'String');
handles.fs.rm({val});
set_lists(handles, handles.fs);
guidata(hObject, handles);