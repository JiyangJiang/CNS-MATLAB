
function cns2_wmh_ud_initDirFile (cns2param)

curr_cmd = mfilename;
fprintf ('%s : start initializing directories/files.\n', curr_cmd);

mkdir (cns2param.dirs.study, 'subjects');

parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)

	try

		mkdir (cns2param.dirs.subjs, cns2param.lists.subjs{i,1});

		diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

		if cns2param.exe.verbose
			fprintf ('%s : ... initializing %s.\n', curr_cmd, cns2param.lists.subjs{i,1});
		end

		orig_t1    = fullfile (cns2param.dirs.study, 'T1',    cns2param.lists.t1{i,1});
		orig_flair = fullfile (cns2param.dirs.study, 'FLAIR', cns2param.lists.flair{i,1});

		% copy original T1 to subject folder
		if isfile (orig_t1)
			copyfile (orig_t1, ...
					  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 't1.nii'));
		else
			ME = MException ('CNS2:initDirFile:origT1notFound', ...
							 '%s specified in cns2param but not found.', orig_t1);
			throw (ME);
		end

		% copy original FLAIR to subject folder
		copyfile (, ...
				  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'flair.nii'));

		% finish message
		fprintf ('%s : %s finished initializing without error.\n', curr_cmd, cns2param.lists.subjs{i,1});

	catch ME

		switch ME.identifier
			
		fprintf ('%s : %s finished initializing with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off
end