curr_cmd = mfilename;

% preprocessing
parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)

	diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

	t1    = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 't1.nii');
	flair = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'flair.nii');

	try
		% coregistration
		rflair = cns2_spmbatch_coregistration (flair, t1, 'same_dir');

		% t1 segmentation
		[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (t1);

		% run DARTEL
		flowmap = cns2_spmbatch_runDARTELe (rcGM, rcWM, rcCSF, ...
											cns2param.templates.temp1_6{1,1}, ...
											cns2param.templates.temp1_6{2,1}, ...
											cns2param.templates.temp1_6{3,1}, ...
											cns2param.templates.temp1_6{4,1}, ...
											cns2param.templates.temp1_6{5,1}, ...
											cns2param.templates.temp1_6{6,1});

		% bring t1, flair, gm, wm, csf to DARTEL space (create warped)
		wt1 = cns2_spmbatch_nativeToDARTEL (t1, flowmap);
		wrflair = cns2_spmbatch_nativeToDARTEL (rflair, flowmap);
		wcGM = cns2_spmbatch_nativeToDARTEL (cGM, flowmap);
		wcWM = cns2_spmbatch_nativeToDARTEL (cWM, flowmap);
		wcCSF = cns2_spmbatch_nativeToDARTEL (cCSF, flowmap);

		% mask wrflair and wt1
		cns2_scripts_mask  (wt1, ...
							cns2param.templates.brnmsk, ...
							fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wt1_brn.nii'));
		cns2_scripts_mask  (wrflair, ...
							cns2param.templates.brnmsk, ...
							fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_brn.nii'));
	
		fprintf ('%s : %s finished preprocessing without errors.\n', curr_cmd, cns2param.lists.subjs{i,1});

	catch preproc_err

		fprintf ('ERROR : %s\n', preproc_err);
		fprintf ('%s : %s finished preprocessing with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off

end