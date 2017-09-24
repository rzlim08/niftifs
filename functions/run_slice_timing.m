function run_slice_timing(P)
sample = spm_vol(P{1});
num_slice = min(sample.dim);
TR = 2;
TA = 2-(2/num_slice);
if mod(num_slice,2)~=0
slice_order = [1:2:num_slice 2:2:num_slice-1];
else
slice_order = [1:2:num_slice-1 2:2:num_slice];
end
ref_slice = floor(num_slice/2);
timing(1) = TA/(num_slice-1);
timing(2) = TR-TA;
spm_slice_timing(char(P), slice_order, ref_slice, timing);
end