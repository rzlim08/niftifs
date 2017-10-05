function set_functional_scans(obj)
% sets all functional scans for all subjects, runs and groups.
% This can be a bit time consuming if you have a lot of
% subjects
obj.functional_scans = expand_folders(obj, strsplit(obj.functional_dirstruct, filesep));
end