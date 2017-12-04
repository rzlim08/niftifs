function remove_subjs(obj, pattern)
% removes all subjects that match a string, pattern. eg.
% (remove_subjs(obj, 's01'))
obj.rm_list.rm_subjects{end+1} = pattern;
obj.subject_array.remove_strmatch(pattern);
obj.path_to_subjects = ...
    obj.path_to_subjects(find(cellfun(@isempty, strfind(obj.path_to_subjects, pattern))));
obj.subjects = obj.subjects(find(cellfun(@isempty, strfind(obj.subjects, pattern))));
end