
parfor (i = 1 : cns2param.n_subjs, cns2param.n_cpus)

	t1 = fullfile(cns2param.subjs_dir, cns2param.subjs_list{i,1}, 't1.nii');
	flair = fullfile(cns2param.subjs_dir, cns2param.subjs_list{i,1}, 'flair.nii');

	% coregistration
	rflair = cns2_spmbatch_coregistration (flair, t1, 'same_dir');

	% t1 segmentation
	[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (t1);


end