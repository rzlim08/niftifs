function rm(obj, patterns)
% takes a cell list of patterns, and removes each one. eg.
% (rm(obj, {'run01';'s01'}))
for i = 1:size(patterns)
    remove_runs(obj, patterns{i});
    remove_subjs(obj, patterns{i});
end
end