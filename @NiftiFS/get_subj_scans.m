function subject_struct = get_subj_scans(obj)
% gets scans but structured by subject -> scans, and
% subject->runs->scans

check_if_subjects(obj);

scans = get_scans(obj);

path = strrep(obj.path_to_subjects, obj.top_level, '');
subject_struct = struct('name', {}, 'subject_scans', {}, 'subject_runs', {});

for i=1:size(path, 1)
    subject_struct(i).name = path{i, 1};
    subject_struct(i).subject_scans = scans(~cellfun(@isempty, strfind(scans, path{i,1}))); 
    if subject_has_runs(obj, path, i)
        subj_runs = create_run_struct(obj, path, i, subject_struct(i).subject_scans);
        if size(subj_runs)>0
            subject_struct(i).subject_runs =subj_runs(~cellfun(@isempty, subj_runs(:,2)), :);
        end
    end
end
subject_struct = subject_struct';
end

function subj_runs = create_run_struct(obj, path, i, scans)
subj_runs = strrep(obj.path_to_runs(subject_runs(obj, path, i)), obj.top_level, '');
for j = 1:size(subj_runs)
    scan_cells = strfind(scans, subj_runs{j,1}); 
    subj_runs{j, 2} = scans(~cellfun(@isempty, scan_cells));
end
end

function check_if_subjects(obj)
if(isempty(obj.subjects))
    error('no subjects');
end
end

function scans = get_scans(obj)
if(isempty(obj.functional_scans))
    scans = get_functional_scans(obj);
else
    scans = obj.functional_scans;
end
end

function bool = subject_has_runs(obj, path, i)
bool = ~isempty(any(subject_runs(obj, path, i)));
end

function runs = subject_runs(obj, path, i)
runs = ~cellfun(@isempty, strfind(obj.path_to_runs, path{i, 1}));
end