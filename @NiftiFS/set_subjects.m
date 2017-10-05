function set_subjects(obj)
% sets the 'subjects' variable to the folders that match the
% subject_strmatch in the position as given by the dirstruct
ndir = strsplit(obj.functional_dirstruct, [filesep '{subjects}' filesep]);
obj.path_to_subjects = expand_folders(obj, [strsplit(ndir{1}, filesep) '{subjects}']);
obj.subjects = unique(obj.get_files(obj.path_to_subjects));
end