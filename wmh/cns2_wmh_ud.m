study_dir = '/Users/z3402744/Work';
cns2_dir = '/Users/z3402744/GitHub/CNS2';
spm_dir = '/Applications/spm12';

n_cpus = 2;
save_dskspc = false;
save_more_dskspc = false;
verbose = true;

temp_opt = {'existing'; '70to80'};

k4kmeans = 6;
k4knn    = 5;




addpath (genpath (cns2_dir));
addpath (spm_dir);

global Defaults
Defaults = spm_get_defaults;

		


cns2param = cns2_wmh_ud_cns2param (study_dir, ...
								   cns2_dir, ...
								   spm_dir, ...
								   n_cpus, ...
								   save_dskspc, ...
								   save_more_dskspc, ...
								   verbose, ...
								   temp_opt, ...
								   k4kmeans, ...
								   k4knn);
% cns2_wmh_ud_initDirFile (cns2param);
% cns2_wmh_ud_preproc (cns2param);
cns2_wmh_ud_classification (cns2param);




