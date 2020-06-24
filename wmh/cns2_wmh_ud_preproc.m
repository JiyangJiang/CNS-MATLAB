
function cns2_wmh_ud_preproc (cns2param)

curr_cmd = mfilename;
fprintf ('%s : start preprocessing.\n', curr_cmd);

% preprocessing
% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
for i = 1 : cns2param.n_subjs

	diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

	fprintf ('%s : ... preprocessing %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

	t1    = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 't1.nii');
	flair = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'flair.nii');

	try
		% coregistration
		rflair = cns2_spmbatch_coregistration (cns2param, flair, t1, 'same_dir');

		% t1 segmentation
		[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (cns2param, t1);

		% run DARTEL
		flowmap = cns2_spmbatch_runDARTELe (cns2param, ...
											rcGM, rcWM, rcCSF, ...
											cns2param.templates.temp1_6{1,1}, ...
											cns2param.templates.temp1_6{2,1}, ...
											cns2param.templates.temp1_6{3,1}, ...
											cns2param.templates.temp1_6{4,1}, ...
											cns2param.templates.temp1_6{5,1}, ...
											cns2param.templates.temp1_6{6,1});

		% bring t1, flair, gm, wm, csf to DARTEL space (create warped)
		wt1     = cns2_spmbatch_nativeToDARTEL (cns2param, t1,     flowmap);
		wrflair = cns2_spmbatch_nativeToDARTEL (cns2param, rflair, flowmap);
		wcGM    = cns2_spmbatch_nativeToDARTEL (cns2param, cGM,    flowmap);
		wcWM    = cns2_spmbatch_nativeToDARTEL (cns2param, cWM,    flowmap);
		wcCSF   = cns2_spmbatch_nativeToDARTEL (cns2param, cCSF,   flowmap);

		% mask wrflair and wt1
		cns2_scripts_mask  (cns2param, ...
							wt1, ...
							cns2param.templates.brnmsk, ...
							fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wt1_brn.nii'));
		cns2_scripts_mask  (cns2param, ...
							wrflair, ...
							cns2param.templates.brnmsk, ...
							fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_brn.nii'));
	
		fprintf ('%s : %s finished preprocessing without errors.\n', curr_cmd, cns2param.lists.subjs{i,1});

	catch ME

		fprintf (2,'\nUnknown exception thrown\n');
		fprintf (2,'++++++++++++++++++++++\n');
		fprintf (2,'identifier: %s\n', ME.identifier);
		fprintf (2,'message: %s\n', ME.message);

		fprintf ('%s : %s finished preprocessing with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off

end