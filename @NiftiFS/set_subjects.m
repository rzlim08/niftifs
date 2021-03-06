function set_subjects(obj)
% sets the 'subjects' variable to the folders that match the
% subject_strmatch in the position as given by the dirstruct
subjects = obj.functional_directory.set_subjects;
obj.subject_array = SubjectArray();
cellfun(@(x) obj.subject_array.add(Subject(get_last_folder(x),x,obj.functional_directory.get_dirstruct)), subjects);
end

function last = get_last_folder(str)
    split = strsplit(str, filesep);
    last = split{end};
end