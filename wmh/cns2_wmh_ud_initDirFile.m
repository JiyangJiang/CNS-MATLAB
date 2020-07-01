
function cns2_wmh_ud_initDirFile (cns2param)

curr_cmd = mfilename;
fprintf ('%s : start initializing directories/files.\n', curr_cmd);

% make study/subjects folder
if ~ isfolder (fullfile (cns2param.dirs.study, 'subjects'))
	mkdir (cns2param.dirs.study, 'subjects');
end

% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
for i = 1 : cns2param.n_subjs		

	subjsdir = cns2param.dirs.subjs;
	subjid   = cns2param.lists.subjs{i,1};

	% make each subject's folder
	if ~ isfolder (fullfile(subjsdir, subjid))
		mkdir (subjsdir, subjid);
	end
	if ~ isfolder (fullfile (subjsdir, subjid, 'ud'))
		mkdir (fullfile(subjsdir, subjid),'ud');
	end
	if ~ isfolder (fullfile (subjsdir, subjid, 'ud', 'scripts'))
		mkdir (fullfile(subjsdir, subjid, 'ud'), 'scripts');
	end
	if ~ isfolder (fullfile (subjsdir, subjid, 'ud', 'preproc'))
		mkdir (fullfile(subjsdir, subjid, 'ud'), 'preproc');
	end
	if ~ isfolder (fullfile (subjsdir, subjid, 'ud', 'postproc'))
		mkdir (fullfile(subjsdir, subjid, 'ud'), 'postproc');
	end
	if ~ isfolder (fullfile (subjsdir, subjid, 'ud', 'wmh'))
		mkdir (fullfile(subjsdir, subjid, 'ud'), 'wmh');
	end

	diary (fullfile (subjsdir, subjid, 'ud', 'scripts', 'cns2_ud.log'));

	if cns2param.exe.verbose
		fprintf ('%s : ... initializing %s.\n', curr_cmd, subjid);
	end

	orig_t1    = fullfile (cns2param.dirs.study, 'T1',    cns2param.lists.t1{i,1});
	orig_flair = fullfile (cns2param.dirs.study, 'FLAIR', cns2param.lists.flair{i,1});

	% copy original T1 to subject folder
	if isfile (orig_t1)
		copyfile (orig_t1, ...
				  fullfile (subjsdir, subjid, 'preproc', 't1.nii'));
	else
		ME = MException ('CNS2:initDirFile:origT1notFound', ...
						 '%s specified in cns2param but not found.', orig_t1);
		throw (ME);
	end

	% copy original FLAIR to subject folder
	if isfile (orig_flair)
		copyfile (orig_flair, ...
				  fullfile (subjsdir, subjid, 'preproc', 'flair.nii'));
	else
		ME = MException ('CNS2:initDirFile:origFLAIRnotFound', ...
						 '%s specified in cns2param but not found.', orig_flair);
		throw (ME);
	end
end
