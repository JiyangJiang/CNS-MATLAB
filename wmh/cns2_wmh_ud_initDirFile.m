curr_cmd = mfilename;
fprintf ('%s : start initializing directories/files.\n', curr_cmd);

parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)

	diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

	try

		if cns2param.exe.verbose
			fprintf ('%s : ... initializing %s.\n', curr_cmd, cns2param.lists.subjs{i,1});
		end

		mkdir (cns2param.dirs.subjs, cns2param.lists.subjs{i,1});

		copyfile (fullfile (cns2param.dirs.study, 'T1', cns2param.lists.t1{i,1}), ...
				  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 't1.nii'));

		copyfile (fullfile (cns2param.dirs.study, 'FLAIR', cns2param.lists.flair{i,1}), ...
				  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'flair.nii'));

		fprintf ('%s : %s finished initializing without error.\n', curr_cmd, cns2param.lists.subjs{i,1});

	catch intDirFile_err

		fprintf ('ERROR : %s\n', intDirFile_err);
		fprintf ('%s : %s finished initializing with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off
end