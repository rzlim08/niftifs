function entry = replace_entry(obj,entry)
% replaces the value in a path with an appropriate matcher
switch lower(entry)
    case '{top_level}'
        entry =  {obj.top_level};
    case '{subjects}'
        entry = {obj.subject_strmatch};
    case '{runs}'
        entry = {obj.run_strmatch};
    case '{groups}'
        entry = {obj.group_strmatch};
    case '{structs}'
        entry = {obj.structural_strmatch};
    case '{structurals}'
        entry = {obj.structural_strmatch};
    case '{scans}'
        if ~obj.is_custom_suffix && ~obj.is_nii && isempty(strfind(obj.scan_strmatch, '.img')) ...
                && isempty(strfind(obj.scan_strmatch, '.nii'))
            entry = {[obj.scan_strmatch '.img']};
        elseif ~obj.is_custom_suffix && obj.is_nii && isempty(strfind(obj.scan_strmatch, '.nii')) ...
                && isempty(strfind(obj.scan_strmatch, '.img'))
            entry = {[obj.scan_strmatch '.nii']};
        else
            entry = {obj.scan_strmatch};
        end
    otherwise
        entry = {entry};
end
end