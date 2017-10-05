function set_runs(obj)
% see set_subjects
if(~obj.run_strmatch)
    obj.runs = cell(0);
    return;
end
ndir = strsplit(obj.functional_dirstruct, [filesep '{runs}' filesep]);
obj.path_to_runs = expand_folders(obj, [strsplit(ndir{1}, filesep) '{runs}']);
obj.runs = unique(obj.get_files(obj.path_to_runs));
end