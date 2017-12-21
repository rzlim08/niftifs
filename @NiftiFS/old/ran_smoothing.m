function ran_smoothing(obj)
% flag to show that smoothing has been run. Also resets the
% scan_strmatch to add the prefix
obj.smoothing = 1;
obj.reset_scan_strmatch([obj.smoothing_prefix obj.scan_strmatch]);
end