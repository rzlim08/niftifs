function remove_runs(obj, pattern)
% removes all runs that match a string, pattern. eg.
% (remove_runs(obj, 'run01');
obj.rm_list.rm_runs{end+1} = pattern;
subjects = obj.subject_array.get_subjects;
for i = 1:size(subjects,1)
    subject = subjects{i}; 
    subject.remove_run(pattern);
    
    
end
end