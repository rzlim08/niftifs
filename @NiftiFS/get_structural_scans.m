function scans = get_structural_scans(obj)
% gets all structural scans for all subjects
scans = expand_folders(obj, strsplit(obj.structural_dirstruct, filesep));
obj.structural_scans = scans;
end