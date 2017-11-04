function new_obj = move_functionals(obj, new_dir, subjs)
% moves functional scans to a new directory specified by
% new_dir
if ~exist(new_dir, 'dir')
    error('directory does not exist');
end
tl = obj.top_level;
for i = 1:size(subjs)
    
    for k= 1:size(subjs(i).subject_scans)
        new_path = strrep(subjs(i).subject_scans{k}, tl, new_dir);
        new_folder = fileparts(new_path);
        if ~exist(new_folder, 'dir')
            mkdir(new_folder);
        end
        copyfile(subjs(i).subject_scans{k}, new_path);
    end
end

new_obj = copy(obj);
new_obj.top_level = new_dir;
new_obj.clear_subjects;
new_obj.clear_runs;
new_obj.set_subjects;
new_obj.set_runs;
new_obj.get_functional_scans;
new_obj.set_structural_dirstruct(strrep(obj.structural_dirstruct, '{top_level}', tl));
end