function run_spm_realign_and_unwarp(P, flags, unwarp_estimate_flags, unwarp_write_flags, vdm_file)
spm_realign(P, flags);
uweflags.sfP = vdm_file;
P1 = deblank(P{1}(1,:));
% if isempty(spm_file(P1,'number'))
%     P1 = spm_file(P1,'number',1);
% end
VP1 = spm_vol(P1);
uweflags.M = VP1.mat;
ds = spm_uw_estimate(P{1},unwarp_estimate_flags);
spm_uw_apply(cat(2,ds),unwarp_write_flags);
end