function cns2param = cns2_wmh_ud_cns2param (study_dir, ...
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

curr_cmd = mfilename;


% Directories
% +++++++++++++++++++++++++++++++++++++++++++++++++
% study directory
cns2param.dirs.study = study_dir;
% subjects dir
cns2param.dirs.subjs = fullfile (cns2param.dirs.study, 'subjects');
% CNS2 directory
cns2param.dirs.cns2 = cns2_dir;
% SPM12 path
cns2param.dirs.spm = spm_dir;


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
cns2param.exe.n_cpus = n_cpus;
cns2param.exe.save_dskspc = save_dskspc;
cns2param.exe.save_more_dskspc = save_more_dskspc;
cns2param.exe.verbose = verbose;

if cns2param.exe.save_more_dskspc == true
	cns2param.exe.save_dskspc = true;
end


% templates
% ++++++++++++++++++++++++++++++++++++++++++++
cns2param.templates.options = temp_opt;

switch cns2param.templates.options{1}

    case 'existing'
    	age_range = cns2param.templates.options{2};

		cns2param.templates.temp1_6{1,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_1.nii');
		cns2param.templates.temp1_6{2,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_2.nii');
		cns2param.templates.temp1_6{3,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_3.nii');
		cns2param.templates.temp1_6{4,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_4.nii');
		cns2param.templates.temp1_6{5,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_5.nii');
		cns2param.templates.temp1_6{6,1} = fullfile (cns2param.dirs.cns2,'templates','DARTEL_0to6_templates',age_range,'Template_6.nii');

		cns2param.templates.brnmsk = fullfile (cns2param.dirs.cns2,'templates','DARTEL_brain_mask',age_range,'DARTEL_brain_mask.nii');
        
        cns2param.templates.gmavg = fullfile (cns2param.dirs.cns2,'templates','DARTEL_GM_WM_CSF_prob_maps',age_range,'DARTEL_GM_prob_map_thr0_8.nii');
        cns2param.templates.wmavg = fullfile (cns2param.dirs.cns2,'templates','DARTEL_GM_WM_CSF_prob_maps',age_range,'DARTEL_WM_prob_map_thr0_8.nii');

        cns2param.templates.gmprob = fullfile (cns2param.dirs.cns2,'templates','DARTEL_GM_WM_CSF_prob_maps',age_range,'DARTEL_GM_prob_map.nii');
        cns2param.templates.wmprob = fullfile (cns2param.dirs.cns2,'templates','DARTEL_GM_WM_CSF_prob_maps',age_range,'DARTEL_WM_prob_map.nii');
        cns2param.templates.csfprob = fullfile (cns2param.dirs.cns2,'templates','DARTEL_GM_WM_CSF_prob_maps',age_range,'DARTEL_CSF_prob_map.nii');

    case 'creating'
        % GM_average_mask_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_GM_probability_map_thr0_8.nii.gz']);
        % WM_average_mask_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_WM_probability_map_thr0_8.nii.gz']);
        % WM_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_WM_probability_map.nii']);
        % GM_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_GM_probability_map.nii']);
        % CSF_prob_map_nii = load_nii ([subj_dir '/cohort_probability_maps/cohort_CSF_probability_map.nii']);

end

cns2param.templates.ventdst = fullfile (cns2param.dirs.cns2,'templates','DARTEL_ventricle_distance_map','DARTEL_ventricle_distance_map.nii');




% classification
% +++++++++++++++++++++++++++++++++++++++++++++
cns2param.classification.ud.lv1clstr_method = lv1clstMethod;
cns2param.classification.ud.k4kmeans        = k4kmeans;
cns2param.classification.ud.n4superpixel    = n4superpixel;
cns2param.classification.ud.k4knn           = k4knn;
cns2param.classification.ud.probthr         = probthr;
cns2param.classification.ud.ext_space       = extSpace;
