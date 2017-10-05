function ran_unwarping(obj)
% flag to show that unwarping has been run. Also resets the
% scan_strmatch to add the prefix
obj.unwarping = 1;
obj.reset_scan_strmatch([obj.unwarping_prefix obj.scan_strmatch]);
end