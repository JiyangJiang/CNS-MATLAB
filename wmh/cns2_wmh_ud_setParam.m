fprintf ('Note that nifti must be gunzipped.\n')

clear all
global cns2param

% study directory
% cns2param.study_dir = 'C:\Users\jiang\Downloads\test';
cns2param.study_dir = '/Users/z3402744/Work';
% CNS2 directory
cns2param.cns2_dir = '/Users/z3402744/GitHub/CNS2';
% template
cns2param.template = {'existing'; '70to80'};

% num of cpus for parallel processing
cns2param.n_cpus = 2;

% create subjects dir and subdir
[s,m] = mkdir (cns2param.study_dir, 'subjects');
cns2param.subjs_dir = fullfile (cns2param.study_dir, 'subjects');

% SPM12 path
cns2param.spm_path = spm ('Dir');
addpath (cns2param.spm_path);

% subjects
t1_dir = dir (fullfile (cns2param.study_dir, 'T1', '*.nii'));
flair_dir = dir (fullfile (cns2param.study_dir, 'FLAIR', '*.nii'));
cns2param.n_subjs = size(t1_dir,1);

for i = 1 : cns2param.n_subjs
	cns2param.t1_list{i,1} = t1_dir(i).name;
	cns2param.flair_list{i,1} = flair_dir(i).name;
	tmp = strsplit (t1_dir(i).name, '_');
	cns2param.subjs_list{i,1} = tmp{1};
end
