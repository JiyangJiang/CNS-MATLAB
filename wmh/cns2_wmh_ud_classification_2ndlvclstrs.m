function wrflair_lv2clstrs_dat = cns2_wmh_ud_classification_2ndlvclstrs (cns2param, ...
																		 wrflair_lv1clstrs_dat, ...
																		 wrflair_brn_hdr, ...
																		 idx)
curr_cmd = mfilename;
if cns2param.exe.verbose
	fprintf ('%s : generating %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end

% initialise to resolve the parfor classification issue
wrflair_lv2clstrs_dat = zeros ([size(wrflair_lv1clstrs_dat) cns2param.classification.k4kmeans]);

for k = 1 : cns2param.classification.k4kmeans
	tmp = wrflair_lv1clstrs_dat;
	tmp (tmp ~= k) = 0;
	tmp (tmp == k) = 1;
	wrflair_lv2clstrs_dat (:,:,:,k) = labelmatrix (bwconncomp (tmp, 6)); % 6-connectivity
end

% write out 2nd-level clusters
if  ~cns2param.exe.save_dskspc && ~cns2param.exe.save_more_dskspc
	if cns2param.exe.verbose
		fprintf ('%s : writing %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
	end
	cns2_scripts_writeNii (cns2param, ...
						   wrflair_brn_hdr, ...
						   wrflair_lv2clstrs_dat, ...
						   fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{idx,1}, 'wrflair_lv2clstrs.nii'), ...
						   '4d');
end