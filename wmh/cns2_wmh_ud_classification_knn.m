function cns2_wmh_ud_classification_knn (cns2param, dat)
curr_cmd = mfilename;
if cns2param.exe.verbose
	fprintf ('%s : running kNN.\n', curr_cmd);
end