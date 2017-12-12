function set_runs(obj)
% see set_subjects
if(~obj.run_strmatch)
    obj.runs = cell(0);
    return;
end

set_runs_class(obj)
end
function set_runs_class(obj)
cellfun(@(x)(x.set_runs(obj)), get_subjects(obj.subject_array));
end
