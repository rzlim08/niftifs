function reset_top_level(obj, path)
obj.top_level = path;
clear_subjects(obj);
clear_runs(obj);
set_subjects(obj);
set_runs(obj);
set_functional_scans(obj);
set_structural_scans(obj);
end