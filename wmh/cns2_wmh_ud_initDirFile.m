
parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)

	mkdir (cns2param.dirs.subjs, cns2param.lists.subjs{i,1});

	copyfile (fullfile (cns2param.dirs.study, 'T1', cns2param.lists.t1{i,1}), ...
			  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 't1.nii'));

	copyfile (fullfile (cns2param.dirs.study, 'FLAIR', cns2param.lists.flair{i,1}), ...
			  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'flair.nii'));
	
end