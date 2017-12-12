function filepath = expand_folders(obj, cellpath)
% takes a dirstruct split by folder and returns the list of
% directories at the end. Expands based on strmatches and
% wildcard(*) selections

filepath = cell([0, 1]);
for i = 1:size(cellpath, 2)
    only_dir = i ~= size(cellpath,2);
    entry = obj.replace_entry(cellpath{i});
    filepath = obj.cartesian(filepath, entry, only_dir ||  ...
        any(strcmp(cellpath{i}, {'{subjects}';'{runs}';'{groups}'})));
    
end
if strcmp(filepath, '*'); filepath = {}; end;
end