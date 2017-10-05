function ran_normalization(obj)
% flag to show that normalizing has been run. Also resets the
% scan_strmatch to add the prefix
obj.normalization = 1;
obj.reset_scan_strmatch([obj.normalization_prefix obj.scan_strmatch]);
end