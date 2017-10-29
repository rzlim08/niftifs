function filepath = expand_folders(obj, cellpath)
% takes a dirstruct split by folder and returns the list of
% directories at the end. Expands based on strmatches and
% wildcard(*) selections

filepath = cell([0, 1]);
for i = 1:size(cellpath, 2)
    only_dir = i ~= size(cellpath,2);
    if strcmp(cellpath{i}, '{subjects}') && ~isempty(obj.path_to_subjects)
        filepath = obj.path_to_subjects;
        
    elseif strcmp(cellpath{i}, '{runs}') && ~isempty(obj.path_to_runs)
        filepath = obj.path_to_runs;
        
    else
        entry = obj.replace_entry(cellpath{i});
        filepath = obj.cartesian(filepath, entry, only_dir ||  ...
            any(strcmp(cellpath{i}, {'{subjects}';'{runs}';'{groups}'})));
    end
end
if strcmp(filepath, '*'); filepath = {}; end;
end