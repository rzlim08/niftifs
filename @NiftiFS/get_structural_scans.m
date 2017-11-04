function scans = get_structural_scans(obj)
% gets all structural scans for all subjects
if (isempty(obj.structural_scans))
    scans = expand_folders_structural(obj, strsplit(obj.structural_dirstruct, filesep));
    obj.structural_scans = scans;
else
    scans = obj.structural_scans;
end
end