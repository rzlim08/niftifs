function set_subject_strmatch(obj, strmatch)
% sets a string to match for the subject (eg. 'WM*' for WM001,
% WM002, etc), can be left as * if all folders in the level are
% subjects
obj.functional_directory.set_subject_strmatch(strmatch);
obj.structural_directory.set_subject_strmatch(strmatch);
end