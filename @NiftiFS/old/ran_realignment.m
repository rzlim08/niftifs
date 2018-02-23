function ran_realignment(obj)
% flag to show that slice_timing has been run. Also resets the
% scan_strmatch to add the prefix
obj.realignment = 1;
obj.reset_scan_strmatch([obj.realignment_prefix obj.scan_strmatch]);
end