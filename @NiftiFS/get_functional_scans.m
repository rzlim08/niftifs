function scans = get_functional_scans(obj)
% gets all functional scans for all subjects, runs and groups.
% This can be a bit time consuming if you have a lot of
% subjects
obj.set_functional_scans;
runs = obj.subject_array.get_runs;
scans = cellfun(@get_scans, runs, 'UniformOutput', 0);
scans = vertcat(scans{:});
end