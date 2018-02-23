function set_functional_scans(obj)
% sets all functional scans for all subjects, runs and groups.
% This can be a bit time consuming if you have a lot of
% subjects
cellfun(@(x)(x.set_scans(obj.functional_directory)), get_subjects(obj.subject_array));
end