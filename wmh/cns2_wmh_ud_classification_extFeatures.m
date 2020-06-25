function cns2_wmh_ud_classification_extFeatures (cns2param,...
												 wrflair_brn_dat,...
												 wrflair_lv2clstrs_struct,...
												 idx)
curr_cmd = mfilename;
if cns2param.exe.verbose
	fprintf ('%s : extracting features for %s.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end

% load essential images
wt1_brn_hdr = spm_vol (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{idx,1}, 'wt1_brn.nii'));
wt1_brn_dat = spm_read_vols (wt1_brn_hdr);

gmavg_dat = spm_read_vols (spm_vol (cns2param.templates.gmavg));
wmavg_dat = spm_read_vols (spm_vol (cns2param.templates.wmavg));

gmprob_dat  = spm_read_vols (spm_vol (cns2param.templates.gmprob));
wmprob_dat  = spm_read_vols (spm_vol (cns2param.templates.wmprob));
csfprob_dat = spm_read_vols (spm_vol (cns2param.templates.csfprob));

ventdst_dat = spm_read_vols (spm_vol (cns2param.templates.ventdst));

% mean intensities
meanInt_GMonT1    = mean(nonzeros(wt1_brn_dat     .* gmavg_dat));
meanInt_WMonT1    = mean(nonzeros(wt1_brn_dat     .* wmavg_dat));
meanInt_GMonFLAIR = mean(nonzeros(wrflair_brn_dat .* gmavg_dat));
meanInt_WMonFLAIR = mean(nonzeros(wrflair_brn_dat .* wmavg_dat));

for i = 1 : cns2param.classification.ud.k4kmeans
	lv2clstrs = labelmatrix (wrflair_lv2clstrs_struct(i));
	for j = 1 : wrflair_lv2clstrs_struct(i).NumObjects
		% linear_idx = wrflair_lv2clstrs_struct(i).PixelIdxList(j);
		clstr = lv2clstrs;
		clstr (clstr ~= j) = 0;
		clstr (clstr == j) = 1;

		f1 = mean(nonzeros(clstr .* wt1_brn_dat)) / meanInt_GMonT1;
	end
end
