
for i = 224:size(ptr)
    path = strsplit(ptr{i}, filesep);
    IPPED{i,1} = path{7};
    dcm = dir([ptr{i} filesep 'Original dcm files' filesep '*-0001.dcm']);
    if ~isempty(dcm)
        dcm_name = [dcm(1).folder filesep dcm(1).name];
        hdr = dicominfo(dcm_name);
        IPPED{i,2} = hdr.InPlanePhaseEncodingDirection;
    end
end