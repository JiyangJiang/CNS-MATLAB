study_dir = '/Users/z3402744/GitHub/CNS2/example_data';
% study_dir = 'C:\Users\jiang\OneDrive\Documents\GitHub\CNS2\example_data';
% study_dir = 'D:\GitHub\CNS2\example_data';

cns2_dir = '/Users/z3402744/GitHub/CNS2';
% cns2_dir = 'C:\Users\jiang\OneDrive\Documents\GitHub\CNS2';
% cns2_dir = 'D:\GitHub\CNS2';

spm_dir = '/Applications/spm12';
% spm_dir = 'C:\Users\jiang\Downloads\test\spm12';
% spm_dir = 'C:\Program Files\spm12';


n_cpus = 2;
save_dskspc = false;
save_more_dskspc = false;
verbose = true;

temp_opt = {'creating'; '70to80'};

% lv1clstMethod = 'kmeans';
lv1clstMethod = 'superpixel';
k4kmeans = 6;
k4knn    = 5;
n4superpixel = 5000;
probthr = 0.7;
extSpace = 'native';

pvmag = 12;
sizthr = [3 9 15];


addpath (genpath (cns2_dir));
addpath (spm_dir);

global Defaults
Defaults = spm_get_defaults;

curr_cmd=mfilename;

% +++++++++++++
% Run from here
% +++++++++++++

try
	% general cns2param
	cns2param = cns2_scripts_cns2param  (study_dir, ...
							             cns2_dir, ...
							             spm_dir, ...
							             n_cpus, ...
							             save_dskspc, ...
							             save_more_dskspc, ...
							             verbose, ...
							             temp_opt);

	% ubo detector-specific cns2param
	cns2param = cns2_wmh_ud_cns2param  (cns2param, ...
										lv1clstMethod, ...
									    k4kmeans, ...
									    n4superpixel, ...
									    k4knn, ...
									    probthr, ...
									    extSpace, ...
									    pvmag, ...
									    sizthr);

	% initialising/organising directories/files
	cns2_wmh_ud_initDirFile (cns2param);

	% initialise cohort-level quantification table
	quant_tbl_coh = cns2_wmh_ud_initCohQuantTbl (cns2param);

	% creating template
	if strcmp(cns2param.templates.options{1},'creating') % creating templates
		[flowmaps,cns2param] = cns2_wmh_ud_crtDartelTemp (cns2param);
	end

	% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
	for i = 1 : cns2param.n_subjs
		
		diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'scripts', 'cns2_ud.log'))

		try
			switch cns2param.templates.options{1}
			    case 'existing'
					cns2_wmh_ud_preproc (cns2param,i);           % preprocessing (existing templates)
				case 'creating'
					cns2_wmh_ud_preproc (cns2param,i,flowmaps);  % preprocessing (creating templates - 
																 % flowmaps are generated during creating
																 % templates).
			end
			
			quant_tbl_subj = cns2_wmh_ud_postproc (cns2param,i); % postprocessing, including 
																 % classification and quantification

		catch ME
			
			fprintf (2,'\nException thrown\n');
			fprintf (2,'++++++++++++++++++++++\n');
			fprintf (2,'identifier: %s\n', ME.identifier);
			fprintf (2,'message: %s\n\n', ME.message);

			% assign NaN values if errors.
			quant_tbl_coh (i,1)     = table (cns2param.lists.subjs(i,1));
			quant_tbl_coh (i,2:end) = table (NaN);
			
			fprintf ('%s : %s finished UBO Detector with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

			diary off

			continue; % jump to next iteration (for i)

		end

		quant_tbl_coh (i,:) = quant_tbl_subj; % accumulate into cohort-level results

		fprintf ('%s : %s finished UBO Detector without error.\n', curr_cmd, cns2param.lists.subjs{i,1});

		diary off
	end

	% save cohort results
	writetable (quant_tbl_coh, ...
				fullfile (cns2param.dirs.subjs,'cns2_wmh_ud.csv')); % write out cohort-level quantification table
	
	if ~cns2param.exe.save_dskspc
		save (fullfile (cns2param.dirs.subjs,'cns2_wmh_ud.mat'), 'quant_tbl_coh'); % save matlab .mat file
	end

catch ME
	fprintf (2,'\nException thrown\n');
	fprintf (2,'++++++++++++++++++++++\n');
	fprintf (2,'identifier: %s\n', ME.identifier);
	fprintf (2,'message: %s\n\n', ME.message);

	fprintf ('%s : UBO Detector aborted from initialisation.\n', curr_cmd);
	fprintf ('%s : Error at either setting cns2param or organising dirs/files.\n', curr_cmd);
end

