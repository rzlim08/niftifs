function ran_slice_timing(obj)
% flag to show that slice_timing has been run. Also resets the
% scan_strmatch to add the prefix
obj.slice_timing = 1;
obj.reset_scan_strmatch([obj.slice_timing_prefix obj.scan_strmatch]);
end