function set_groups(obj)
% see set_subjects
if(~obj.group_strmatch)
    obj.groups = cell(0);
end
ndir = strsplit(obj.functional_dirstruct, [filesep '{groups}' filesep]);
path_to_groups = expand_folders(obj, [strsplit(ndir{1}, filesep) '{groups}']);
obj.groups = unique(obj.get_files(path_to_groups));
end