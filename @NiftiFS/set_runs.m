function set_runs(obj)
cellfun(@(x)(x.set_runs(obj.functional_directory, obj.get_is4D)), get_subjects(obj.subject_array));
end