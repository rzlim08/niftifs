function filecell = cartesian(~, filepath, entry, only_dir)
% named as such because it gets the cartesian product between
% the filepath and the values returned by entry. filepath is a
% cell list of paths, entry is the name of a folder, file, or
% wildcard, and only_dir is a flag which if set filters out
% non-directory entries. Could be renamed.
filecell = cell(0,1);
if size(filepath,1)==0
    filecell = entry;
    return
end
if size(entry,1)==0
    filecell = filepath;
    return
end
for i = 1:size(filepath)
    for j = 1:size(entry)
        if strfind(entry{j}, '*')
            dirs = dir([filepath{i} filesep entry{j}]);
            dirs=dirs(~ismember({dirs.name},{'.','..'}));
            if only_dir
                isub = [dirs(:).isdir]; %# returns logical vector
                dirs = {dirs(isub).name}';
            else
                dirs = {dirs.name}';
            end
            for k = 1:size(dirs)
                filecell{end+1, 1} = [filepath{i} filesep dirs{k}];
            end
            
        else
            filecell{end+1, 1} = [filepath{i} filesep entry{j}];
        end
        
    end
end
end