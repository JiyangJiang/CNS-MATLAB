
parfor (i = 1 : cns2param.n_subjs, cns2param.n_cpus)
	mkdir (cns2param.subjs_dir, cns2param.subjs_list{i,1});

	copyfile (fullfile (cns2param.study_dir, 'T1', cns2param.t1_list{i,1}), ...
				fullfile(cns2param.subjs_dir, cns2param.subjs_list{i,1}, 't1.nii'));

	copyfile (fullfile (cns2param.study_dir, 'FLAIR', cns2param.flair_list{i,1}), ...
				fullfile(cns2param.subjs_dir, cns2param.subjs_list{i,1}, 'flair.nii'));
end