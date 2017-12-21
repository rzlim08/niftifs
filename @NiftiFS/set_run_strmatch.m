function set_run_strmatch(obj, strmatch)
% sets a string to match for the run (eg. 'WM*' for WM001,
% WM002, etc), can be left as * if all folders in the level are
% runs
obj.functional_directory.set_run_strmatch(strmatch);
obj.structural_directory.set_run_strmatch(strmatch);
end