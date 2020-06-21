
% preprocessing
parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)

	t1 = fullfile(cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 't1.nii');
	flair = fullfile(cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'flair.nii');

	% coregistration
	rflair = cns2_spmbatch_coregistration (flair, t1, 'same_dir');

	% t1 segmentation
	[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (t1);

	% run DARTEL
	flowmap = cns2_spmbatch_runDARTELe (rcGM, rcWM, rcCSF, template1, template2, template3, template4, template5, template6);

	% bring t1, flair, gm, wm, csf to DARTEL space (create warped)
	wt1 = cns2_spmbatch_nativeToDARTEL (t1, flowmap);
	wrflair = cns2_spmbatch_nativeToDARTEL (rflair, flowmap);
	wcGM = cns2_spmbatch_nativeToDARTEL (cGM, flowmap);
	wcWM = cns2_spmbatch_nativeToDARTEL (cWM, flowmap);
	wcCSF = cns2_spmbatch_nativeToDARTEL (cCSF, flowmap);
end