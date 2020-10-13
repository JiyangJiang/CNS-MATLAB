% This example quantifies WMH global measures from UKB BIANCA results.

addpath ('/usr/share/spm12');
addpath ('/home/jiyang/Software/CNS2/wmh');


allwmh = dir ('/data_pri/jiyang/ukb/all_BIANCA_WMH_mask/*_bianca_mask.nii.gz');
Nwmh=size(allwmh,1);

% initialise result table
varTypes = cell (13,1);
varTypes (1)   = {'cellstr'};
varTypes (2:13) = {'single'};
qtbl = table ('Size',[Nwmh 13],'VariableTypes',varTypes);
qtbl.Properties.VariableNames = {'ID'
								 'wbwmh_vol'
								 'wbwmh_noc'
								 'wbwmh_noc_p'
								 'wbwmh_noc_f'
								 'wbwmh_noc_m'
								 'wbwmh_noc_c'
								 'avg_clstr_dist'
								 'std_clstr_dist'
								 'var_clstr_dist'
								 'avg_clstrSiz'
								 'std_clstrSiz'
								 'var_clstrSiz'};

% for j = 1:Nwmh
parfor (j = 1:Nwmh,22)
	wmh_gz = fullfile(allwmh(j).folder,allwmh(j).name);
	wmh = gunzip (wmh_gz); % gunzip one .nii.gz each time to save space

	t=strsplit(allwmh(j).name,'_');
	subjid=t{1};
	flair_gz = fullfile(allwmh(j).folder,[subjid '_flair_brain.nii.gz']);
	flair = gunzip (flair_gz);

	qtbl_subj = cns2_wmh_ud_postproc_quantification (spm_read_vols(spm_vol(wmh{1})),flair{1});
	qtbl(j,:) = [table({subjid}) qtbl_subj];

	delete (wmh{1}); % delete nii to save space
	delete (flair{1});
end

writetable (qtbl,['/data_pri/jiyang/ukb/all_BIANCA_WMH_mask/cns2_wmh_measures.csv']);

