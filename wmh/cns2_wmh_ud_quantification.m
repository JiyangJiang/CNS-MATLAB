function cns2_wmh_ud_quantification (cns2param,wmhmask_dat)

curr_cmd=mfilename;

% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
for i = 1 : cns2param.n_subjs

	diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

	try
		fprintf ('%s : start classification for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});
		
		cns2param.templates.ventdst

	catch ME
		fprintf (2,'\nUnknown exception thrown\n');
		fprintf (2,'++++++++++++++++++++++\n');
		fprintf (2,'identifier: %s\n', ME.identifier);
		fprintf (2,'message: %s\n\n', ME.message);
	end

		fprintf ('%s : %s finished quantification with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off
end