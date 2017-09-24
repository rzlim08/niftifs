function IPPED = get_dicom_info(ptr)
IPPED = cell(size(ptr, 1), 2);
for i = 1:size(ptr)
    path = strsplit(ptr{i}, filesep);
    IPPED{i,1} = path{7};
    dcm = dir([ptr{i} filesep 'Original dcm files' filesep '*-0001.dcm']);
    if ~isempty(dcm)
        dcm_name = [dcm.folder filesep dcm.name];
        hdr = dicominfo(dcm_name);
        IPPED{i,2} = hdr.InPlanePhaseEncodingDirection;
    end
end

end