function subject_struct = get_subj_scans(obj)
% gets scans but structured by subject -> scans, and
% subject->runs->scans
if(isempty(obj.subjects))
    error('no subjects');
end
if(isempty(obj.functional_scans))
    scans = get_functional_scans(obj);
else
    scans = obj.functional_scans;
end
path = strrep(obj.path_to_subjects, obj.top_level, '');
subject_struct = struct('name', {}, 'subject_scans', {}, 'subject_runs', {});
for i=1:size(path, 1)
    subject_struct(i).name = path{i, 1};
    subject_struct(i).subject_scans = scans(~cellfun(@isempty, strfind(scans, path{i,1})));
    if ~isempty(any(~cellfun(@isempty, strfind(obj.path_to_runs, path{i, 1}))))
        subj_runs = strrep(obj.path_to_runs(~cellfun(@isempty, ...
            strfind(obj.path_to_runs, path{i, 1}))), ...
            obj.top_level, '');
        for j = 1:size(subj_runs)
            subj_runs{j, 2} = scans(~cellfun(@isempty, strfind(scans, subj_runs{j,1})));
        end
        if size(subj_runs)>0
            subject_struct(i).subject_runs =subj_runs(~cellfun(@isempty, subj_runs(:,2)), :);
        end
    end
end
subject_struct = subject_struct';
end