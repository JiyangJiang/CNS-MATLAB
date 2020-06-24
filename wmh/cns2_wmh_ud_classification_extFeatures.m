function cns2_wmh_ud_classification_extFeatures (cns2param, dat, idx)
curr_cmd = mfilename;
if cns2param.exe.verbose
	fprintf ('%s : extracting features for %s.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end