function subject_struct = get_random_subj(obj, number)
% returns a subject struct of size number. Basically used for testing purposes.
subject_struct = get_subj_scans(obj);
vec = randperm(size(subject_struct,1), number);
subject_struct = subject_struct(vec);
end