% This example quantifies WMH global measures from UKB.
% WMH and corresponding FLAIR have been copied to
% part_XX folders

addpath ('/usr/share/spm12');

for i = 1:59
	allwmh = dir (['/data_int/jiyang/UKB/WMH/part_' num2str(i) '/*_WMH.nii']);
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

	parfor (j = 1:Nwmh,22)
		wmh = fullfile(allwmh(j).folder,allwmh(j).name);
		t=strsplit(allwmh(j).name,'_');
		subjid=t{1};
		flair = fullfile(allwmh(j).folder,[subjid '_FLAIR.nii']);

		qtbl_subj = cns2_wmh_ud_postproc_quantification (spm_read_vols(spm_vol(wmh)),flair);
		qtbl(j,:) = [table({subjid}) qtbl_subj];
	end

	writetable (qtbl,['/data_int/jiyang/UKB/WMH/part_' num2str(i) '/new_wmh_measures.csv']);

	save (['/data_int/jiyang/UKB/WMH/part_' num2str(i) '/new_wmh_measures.mat'], 'qtbl');
end