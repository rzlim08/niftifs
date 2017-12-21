function set_structural_scans(obj)
% gets all structural scans for all subjects

obj.structural_scans = obj.structural_directory.get_structurals;
add_structural_to_subject(obj.subject_array.subjects,obj.structural_scans)

end

function add_structural_to_subject(subjects, structurals)
for i = 1:size(subjects)
    id = subjects{i}.get_id();
    for j = 1:size(structurals)
        structural_cell = strsplit(structurals{j},filesep);
        if any(cellfun(@(x)strcmp(x, id), structural_cell)) %any(contains(structural_cell, id))
           subjects{i}.set_structural_path( structurals{j});
           break;
        end
    end
end
end