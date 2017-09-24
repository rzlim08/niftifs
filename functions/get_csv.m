function csv = read_csv(scans)
csv = cell(size(scans));
for i = 1:size(scans,1)
   fold = fileparts(scans{i,:});
   csv{i} = dir([fold filesep '*.csv']);
end
end