study_dir = '/Users/z3402744/Work';
% study_dir = 'C:\Users\jiang\Downloads\test';
cns2_dir = '/Users/z3402744/GitHub/CNS2';
% cns2_dir = 'C:\Users\jiang\OneDrive\Documents\GitHub\CNS2';
spm_dir = '/Applications/spm12';
% spm_dir = 'C:\Users\jiang\Downloads\test\spm12';


n_cpus = 2;
save_dskspc = false;
save_more_dskspc = false;
verbose = true;

temp_opt = {'existing'; '70to80'};

lv1clstMethod = 'kmeans';
% lv1clstMethod = 'superpixel';
k4kmeans = 6;
k4knn    = 5;
n4superpixel = 5000;
probthr = 0.7;
extSpace = 'dartel';


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
									    extSpace);

	cns2_wmh_ud_initDirFile (cns2param);


	% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
	for i = 1 : cns2param.n_subjs
		diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'scripts', 'cns2_ud.log'))

		try
			
			cns2_wmh_ud_preproc (cns2param,i);
			cns2_wmh_ud_postproc (cns2param,i);

			fprintf ('%s : %s finished UBO Detector without error.\n', curr_cmd, cns2param.lists.subjs{i,1});

		catch ME
			switch ME.identifier
				case 'CNS2:initDirFile:origFLAIRnotFound'
					fprintf (2,'\nCNS2 exception thrown\n');
					fprintf (2,'++++++++++++++++++++++\n');
					fprintf (2,'identifier:%s\n', ME.identifier);
					fprintf (2,'message:%s\n\n', ME.message);
				case 'CNS2:classification:wrflair_brnNotFound'
					fprintf (2,'\nCNS2 exception thrown\n');
					fprintf (2,'++++++++++++++++++++++\n');
					fprintf (2,'identifier:%s\n', ME.identifier);
					fprintf (2,'message:%s\n\n', ME.message);
				otherwise
					fprintf (2,'\nUnknown exception thrown\n');
					fprintf (2,'++++++++++++++++++++++\n');
					fprintf (2,'identifier: %s\n', ME.identifier);
					fprintf (2,'message: %s\n\n', ME.message);
			end

			fprintf ('%s : %s finished UBO Detector with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

		end

		diary off
	end

catch ME
	switch ME.identifier
	case 'CNS2:initDirFile:origT1notFound'
		fprintf (2,'\nCNS2 exception thrown\n');
		fprintf (2,'++++++++++++++++++++++\n');
		fprintf (2,'identifier:%s\n', ME.identifier);
		fprintf (2,'message:%s\n\n', ME.message);
	case 'CNS2:setParam:unmatchT1FLAIR'
		fprintf (2,'\nCNS2 exception thrown\n');
		fprintf (2,'++++++++++++++++++++++\n');
		fprintf (2,'identifier:%s\n', ME.identifier);
		fprintf (2,'message:%s\n\n', ME.message);
	otherwise
		fprintf (2,'\nUnknown exception thrown\n');
		fprintf (2,'++++++++++++++++++++++\n');
		fprintf (2,'identifier: %s\n', ME.identifier);
		fprintf (2,'message: %s\n\n', ME.message);
	end
	fprintf ('%s : UBO Detector aborted from initialisation.\n', curr_cmd);
	fprintf ('%s : Error at either setting cns2param or organising dirs/files.\n', curr_cmd);
end

