function files = get_files(~, full_files)
% given a cell list of filepaths gets the last entry, could be
% renamed
files = cell(size(full_files,1),1);
for i = 1:size(full_files,1)
    split = strsplit(full_files{i}, filesep);
    files{i} = split{end};
end
end