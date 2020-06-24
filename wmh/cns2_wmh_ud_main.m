
cns2param = setParam;
cns2_wmh_ud_initDirFile (cns2param);
cns2_wmh_ud_preproc (cns2param);





function cns2param = setParam

	curr_cmd = mfilename;

	try
		% fprintf ('Note that nifti must be gunzipped.\n');

		% Directories
		% +++++++++++++++++++++++++++++++++++++++++++++++++
		% study directory
		% cns2param.dirs.study = 'C:\Users\jiang\Downloads\test';
		cns2param.dirs.study = '/Users/z3402744/Work';
		% subjects dir
		cns2param.dirs.subjs = fullfile (cns2param.dirs.study, 'subjects');
		% CNS2 directory
		% cns2param.dirs.cns2 = 'C:\Users\jiang\OneDrive\Documents\GitHub\CNS2';
		cns2param.dirs.cns2 = '/Users/z3402744/GitHub/CNS2';
		addpath (genpath (cns2param.dirs.cns2));
		% SPM12 path
		% cns2param.dirs.spm = 'C:\Users\jiang\Downloads\test\spm12';
		cns2param.dirs.spm = '/Applications/spm12';
		% cns2param.dirs.spm = spm ('Dir');
		addpath (cns2param.dirs.spm);

		global Defaults
		Defaults = spm_get_defaults;

		% Lists
		% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		% t1, flair, subjs
		t1_dir = dir (fullfile (cns2param.dirs.study, 'T1', '*.nii'));
		flair_dir = dir (fullfile (cns2param.dirs.study, 'FLAIR', '*.nii'));
		for i = 1 : size(t1_dir,1)
			cns2param.lists.t1{i,1}    = t1_dir(i).name;
			cns2param.lists.flair{i,1} = flair_dir(i).name;
			tmp = strsplit (t1_dir(i).name, '_');
			cns2param.lists.subjs{i,1} = tmp{1};

			% check if t1 and flair pair
			if  ~ startsWith (cns2param.lists.flair{i,1}, [cns2param.lists.subjs{i,1} '_'])

				ME = MException ('CNS2:setParam:unmatchT1FLAIR', ...
								 '%s''s T1 does not have corresponding FLAIR.', cns2param.lists.subjs{i,1});
				throw (ME);
			end
		end


		% Numbers
		% ++++++++++++++++++++++++++++++++++++++++
		cns2param.n_subjs = size(t1_dir,1);


		% Execution options
		% ++++++++++++++++++++++++++++++++++++
		% num of cpus for parallel processing
		cns2param.exe.n_cpus = 2;
		cns2param.exe.save_dskspc = false;
		cns2param.exe.save_more_dskspc = false;
		cns2param.exe.verbose = true;


		% templates
		% ++++++++++++++++++++++++++++++++++++++++++++
		cns2param.templates.options = {'existing'; '70to80'};
		if strcmp (cns2param.templates.options{1},'existing')

			age_range = cns2param.templates.options{2};

			cns2param.templates.temp1_6{1,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_1.nii');
			cns2param.templates.temp1_6{2,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_2.nii');
			cns2param.templates.temp1_6{3,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_3.nii');
			cns2param.templates.temp1_6{4,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_4.nii');
			cns2param.templates.temp1_6{5,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_5.nii');
			cns2param.templates.temp1_6{6,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_6.nii');

			cns2param.templates.brnmsk = fullfile (cns2param.dirs.cns2,'templates','DARTEL_brain_mask',age_range,'DARTEL_brain_mask.nii');
			
		elseif strcmp (cns2param.templates.options{1},'creating')
			% templates if creating template
		end

		fprintf ('%s : setting cns2param finished without error.\n', curr_cmd);

	catch ME

		switch ME.identifier
			case 'CNS2:setParam:unmatchT1FLAIR'
				fprintf (2,'\nCNS2 exception thrown\n');
				fprintf (2,'++++++++++++++++++++++\n');
				fprintf (2,'\nidentifier:\n%s\n', ME.identifier);
				fprintf (2,'\nmessage:\n%s\n\n', ME.message);
			otherwise
				fprintf (2,'\nUnknown exception thrown\n');
				fprintf (2,'++++++++++++++++++++++\n');
				fprintf (2,'identifier: %s\n', ME.identifier);
				fprintf (2,'message: %s\n', ME.message);
		end

		fprintf ('%s : setting cns2param finished with ERROR.\n', curr_cmd);

	end
end