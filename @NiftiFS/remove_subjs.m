function remove_subjs(obj, pattern)
% removes all subjects that match a string, pattern. eg.
% (remove_subjs(obj, 's01'))
obj.rm_list.rm_subjects{end+1} = pattern;
obj.subject_array.remove_strmatch(pattern);
end