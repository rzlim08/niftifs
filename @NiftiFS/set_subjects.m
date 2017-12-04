function set_subjects(obj)
% sets the 'subjects' variable to the folders that match the
% subject_strmatch in the position as given by the dirstruct
ndir = strsplit(obj.functional_dirstruct, [filesep '{subjects}' filesep]);
subjects =  expand_folders(obj, [strsplit(ndir{1}, filesep) '{subjects}']);

%%
obj.path_to_subjects = subjects;
obj.subjects = unique(obj.get_files(obj.path_to_subjects));
%% 
obj.subject_array = SubjectArray();
cellfun(@(x) obj.subject_array.add(Subject(get_last_folder(x),x,obj.functional_dirstruct)), subjects);
end

function last = get_last_folder(str)
    split = strsplit(str, filesep);
    last = split{end};
end