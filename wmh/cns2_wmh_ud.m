% study_dir = '/Users/z3402744/Work';
study_dir = 'C:\Users\jiang\OneDrive\Documents\GitHub\CNS2\example_data';
% study_dir = 'D:\GitHub\CNS2\example_data';

% cns2_dir = '/Users/z3402744/GitHub/CNS2';
cns2_dir = 'C:\Users\jiang\OneDrive\Documents\GitHub\CNS2';
% cns2_dir = 'D:\GitHub\CNS2';

% spm_dir = '/Applications/spm12';
spm_dir = 'C:\Users\jiang\Downloads\test\spm12';
% spm_dir = 'C:\Program Files\spm12';


n_cpus = 2;
save_dskspc = false;
save_more_dskspc = false;
verbose = true;

temp_opt = {'existing'; '70to80'};

% lv1clstMethod = 'kmeans';
lv1clstMethod = 'superpixel';
k4kmeans = 6;
k4knn    = 5;
n4superpixel = 5000;
probthr = 0.7;
extSpace = 'dartel';

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
	cns2param = cns2_wmh_ud_cns2param  (study_dir, ...
									    cns2_dir, ...
									    spm_dir, ...
									    n_cpus, ...
									    save_dskspc, ...
									    save_more_dskspc, ...
									    verbose, ...
									    temp_opt, ...
									    lv1clstMethod, ...
									    k4kmeans, ...
									    n4superpixel, ...
									    k4knn, ...
									    probthr, ...
									    extSpace, ...
									    pvmag, ...
									    sizthr);

	cns2_wmh_ud_initDirFile (cns2param);


	% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
	for i = 1 : cns2param.n_subjs
		diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'scripts', 'cns2_ud.log'))

		try
			
			cns2_wmh_ud_preproc (cns2param,i);                   % preprocessing
			quant_tbl_subj = cns2_wmh_ud_postproc (cns2param,i); % postprocessing, including 
																 % classification and quantification

			% TO-DO : accumulate subject-level quantification table (quant_tbl_subj)
			%         into cohort-level (quant_tbl_coh)

			fprintf ('%s : %s finished UBO Detector without error.\n', curr_cmd, cns2param.lists.subjs{i,1});

		catch ME
			
			fprintf (2,'\nException thrown\n');
			fprintf (2,'++++++++++++++++++++++\n');
			fprintf (2,'identifier: %s\n', ME.identifier);
			fprintf (2,'message: %s\n\n', ME.message);
			
			fprintf ('%s : %s finished UBO Detector with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});
		end

		diary off
	end

	% TO-DO : write out cohort-level quantification table (quant_tbl_coh)

catch ME
	fprintf (2,'\nException thrown\n');
	fprintf (2,'++++++++++++++++++++++\n');
	fprintf (2,'identifier: %s\n', ME.identifier);
	fprintf (2,'message: %s\n\n', ME.message);

	fprintf ('%s : UBO Detector aborted from initialisation.\n', curr_cmd);
	fprintf ('%s : Error at either setting cns2param or organising dirs/files.\n', curr_cmd);
end

