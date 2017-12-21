function counts = count_runs(obj)
% if subjects contain runs, counts the number of runs for a
% given subject
counts = cellfun(@(x) sum(~cellfun('isempty', strfind(obj.path_to_runs,x))),obj.subjects);
counts = [obj.subjects num2cell(counts)];
end