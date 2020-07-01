function [wmhprob_dat,wmhmask_dat] = cns2_wmh_ud_classification_predict (cns2param,lv2clstrs_struct,f_tbl,mdl,hdr,idx)

curr_cmd=mfilename;
subjid = cns2param.lists.subjs{idx,1};

if cns2param.exe.verbose
	fprintf ('%s : predicting wmh for %s.\n', curr_cmd, subjid);
end

% only use 3:11 columns as 1:2 columns are 1st-level and 2nd-level
% cluster index, and 12:14 columns are centroid coordinates
[~,score,~] = predict (mdl, f_tbl(:,3:11));

% add the probability to the last column of feature table
wmhprob = score (:,2);
fd_tbl = [f_tbl table(wmhprob)];
if ~cns2param.exe.save_more_dskspc
	fprintf ('%s : saving feature+decision table for %s.\n', curr_cmd, subjid);
	save (fullfile (cns2param.dirs.subjs, subjid, 'fd_tbl.mat'), 'fd_tbl');
end

% assign label to 2nd-level clusters
switch cns2param.classification.ud.lv1clstr_method
case 'kmeans'
	Nlv1clstrs = cns2param.classification.ud.k4kmeans;
case 'superpixel'
	Nlv1clstrs = cns2param.classification.ud.n4superpixel_actual;
end

% initialise
wmhprob_dat=zeros(size(labelmatrix(lv2clstrs_struct(1))));

for i = 1 : Nlv1clstrs

	lv2clstrs = single(labelmatrix(lv2clstrs_struct(i)));
	
	switch cns2param.classification.ud.lv1clstr_method
	case 'kmeans'
		Nlv2clstrs = lv2clstrs_struct(i).NumObjects;
	case 'superpixel'
		Nlv2clstrs = 1;
	end

	for j = 1 : Nlv2clstrs
		lin_idx = j + sum([lv2clstrs_struct(1:(i-1)).NumObjects]);
		lv2clstrs(lv2clstrs==j)=wmhprob(lin_idx);
	end

	wmhprob_dat=wmhprob_dat+lv2clstrs;
end

% write to wmhprob nifti
cns2_scripts_writeNii (cns2param, ...
					   hdr, ...
					   wmhprob_dat, ...
					   fullfile (cns2param.dirs.subjs, subjid, 'wmhprob.nii'));

% write wmhmask nifti
wmhmask_dat = wmhprob_dat > cns2param.classification.ud.probthr;
cns2_scripts_writeNii (cns2param, ...
					   hdr, ...
					   wmhmask_dat, ...
					   fullfile (cns2param.dirs.subjs, subjid, 'wmhmask.nii'));