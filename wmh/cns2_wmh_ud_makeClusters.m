curr_cmd = mfilename;

parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)


	wrflair_brn = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_brn.nii');

	wrflair_brn_hdr = spm_vol (wrflair_brn);
	wrflair_brn_dat = spm_read_vols (wrflair_brn_hdr);

	% zero nan
	wrflair_brn_dat (isnan(wrflair_brn_dat)) = 0;

	% volume segmentation using k-means
	fprintf ('%s : clusterizing %s''s wrflair_brn with k-means.\n', curr_cmd, cns2param.lists.subjs{i,1});
	wrflair_clstr_dat = imsegkmeans3 (single(wrflair_brn_dat), 6, 'NormalizeInput', true);

	% write out k-means clusters
	cns2_scripts_writeNii (wrflair_brn_hdr, wrflair_clstr_dat, ...
							fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_clstr.nii'));
end
