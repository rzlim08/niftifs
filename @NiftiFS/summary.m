function s = summary(obj)
%SUMMARY Summarizes a study
%   Detailed explanation goes here
sa = obj.subject_array;
ids =  cellfun(@get_id, sa.get_subjects, 'UniformOutput', 0);

structural_scan =  cellfun(@get_structural_path, sa.get_subjects, 'UniformOutput', 0);
runs = cellfun(@get_runs, sa.get_subjects, 'UniformOutput', 0);

no_runs = cellfun(@(x)(size(x,1)), runs);
scans = get_scans(runs);
no_scans = cellfun(@(x)(size(x,1)), scans);

s = table(no_runs, runs, no_scans, scans, structural_scan, 'VariableNames', ...
    {'NumberRuns', 'Runs', 'NumberScans', 'Scans', 'StructuralScan'},...
    'RowNames', ids);

end

function scans = get_scans(runs)
scans = cell(size(runs));
for i = 1:size(runs,1)
   subj_runs = runs{i}; 
   run_cell = cell(size(subj_runs));
   for j = 1:size(subj_runs,1)
      run_cell{j} = subj_runs(j).get_scans; 
   end
   scans{i} = vertcat(run_cell{:});
end

end
