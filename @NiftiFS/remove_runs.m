function remove_runs(obj, pattern)
% removes all runs that match a string, pattern. eg.
% (remove_runs(obj, 'run01');
obj.rm_list.rm_runs{end+1} = pattern;
obj.path_to_runs = ...
    obj.path_to_runs(find(cellfun(@isempty, strfind(obj.path_to_runs, pattern))));
obj.runs = obj.runs(find(cellfun(@isempty, strfind(obj.runs, pattern))));
end