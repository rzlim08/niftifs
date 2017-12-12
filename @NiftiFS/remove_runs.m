function remove_runs(obj, pattern)
% removes all runs that match a string, pattern. eg.
% (remove_runs(obj, 'run01');
obj.rm_list.rm_runs{end+1} = pattern;
end