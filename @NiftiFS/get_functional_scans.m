function scans = get_functional_scans(obj)
% gets all functional scans for all subjects, runs and groups.
% This can be a bit time consuming if you have a lot of
% subjects
scans = expand_folders(obj, strsplit(obj.functional_dirstruct, filesep));
obj.functional_scans = scans;
end