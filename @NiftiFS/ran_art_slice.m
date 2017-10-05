function ran_art_slice(obj)
% flag to show that art_slice has been run. Also resets the
% scan_strmatch to add the prefix
obj.art_slice = 1;
obj.reset_scan_strmatch([obj.art_slice_prefix obj.scan_strmatch]);
end