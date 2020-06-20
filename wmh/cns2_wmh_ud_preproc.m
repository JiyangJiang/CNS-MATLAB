
% which template to use
if strcmp (cns2param.template{1},'existing')
	age_range = cns2param.template{2};
	template1 = fullfile (cns2param.cns2_dir,'templates','DARTEL_0to6_templates',age_range,'Template_1.nii');
	template2 = fullfile (cns2param.cns2_dir,'templates','DARTEL_0to6_templates',age_range,'Template_2.nii');
	template3 = fullfile (cns2param.cns2_dir,'templates','DARTEL_0to6_templates',age_range,'Template_3.nii');
	template4 = fullfile (cns2param.cns2_dir,'templates','DARTEL_0to6_templates',age_range,'Template_4.nii');
	template5 = fullfile (cns2param.cns2_dir,'templates','DARTEL_0to6_templates',age_range,'Template_5.nii');
	template6 = fullfile (cns2param.cns2_dir,'templates','DARTEL_0to6_templates',age_range,'Template_6.nii');
elseif strcmp (cns2param.template{1},'creating')
	% to do if creating template
end

% preprocessing
parfor (i = 1 : cns2param.n_subjs, cns2param.n_cpus)

	t1 = fullfile(cns2param.subjs_dir, cns2param.subjs_list{i,1}, 't1.nii');
	flair = fullfile(cns2param.subjs_dir, cns2param.subjs_list{i,1}, 'flair.nii');

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