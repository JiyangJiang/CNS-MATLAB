function f_tbl = cns2_wmh_ud_classification_extFeatures (cns2param,...
														 wrflair_brn_dat,...
														 wrflair_lv2clstrs_struct,...
														 idx)
etime_extFeatures = tic;
curr_cmd = mfilename;

if cns2param.exe.verbose
	fprintf ('%s : extracting features for %s.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end

% load essential images
wt1_brn_hdr = spm_vol (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{idx,1}, 'wt1_brn.nii'));
wt1_brn_dat = spm_read_vols (wt1_brn_hdr);

gmavg_dat = spm_read_vols (spm_vol (cns2param.templates.gmavg));
wmavg_dat = spm_read_vols (spm_vol (cns2param.templates.wmavg));

gmprob_dat  = spm_read_vols (spm_vol (cns2param.templates.gmprob));
wmprob_dat  = spm_read_vols (spm_vol (cns2param.templates.wmprob));
csfprob_dat = spm_read_vols (spm_vol (cns2param.templates.csfprob));

ventdst_dat = spm_read_vols (spm_vol (cns2param.templates.ventdst));

% mean intensities
meanInt_GMonT1    = mean(nonzeros(wt1_brn_dat     .* gmavg_dat));
meanInt_WMonT1    = mean(nonzeros(wt1_brn_dat     .* wmavg_dat));
meanInt_GMonFLAIR = mean(nonzeros(wrflair_brn_dat .* gmavg_dat));
meanInt_WMonFLAIR = mean(nonzeros(wrflair_brn_dat .* wmavg_dat));

% initialise feature table
f_names = {'clstrOverGmOnT1'; 'clstrOverGmOnFLAIR'; 'clstrOverWmOnT1'; 'clstrOverWmOnFLAIR'
		   'logSize'
		   'avgGmProb'; 'avgWmProb'; 'avgCsfProb'
		   'avgVentDst'
		   'cent_x'; 'cent_y'; 'cent_z'};

f_varType = cell(12,1);
f_varType(:) = {'single'};

f_tbl = table ('Size', [sum([wrflair_lv2clstrs_struct(:).NumObjects]) 12], ...
			   'VariableTypes', f_varType, ...
			   'VariableNames', f_names);

f_tbl.Properties.Description = ['Feature table for ' cns2param.lists.subjs{idx,1}];
f_tbl.Properties.VariableDescriptions = {'ratio of intensities between cluster and GM on T1'
										 'ratio of intensities between cluster and GM on FLAIR'
										 'ratio of intensities between cluster and WM on T1'
										 'ratio of intensities between cluster and WM on FLAIR'
										 'log-transformed cluster size'
										 'average GM probabilities of the cluster'
										 'average WM probabilities of the cluster'
										 'average CSF probabilities of the cluster'
										 'average distance of the cluster from lateral ventricles'
										 'centroid''s x coordinate'
										 'centroid''s y coordinate'
										 'centroid''s z coordinate'};

f_tbl_rname = cell(sum([wrflair_lv2clstrs_struct(:).NumObjects]), 1);

% extract features
for i = 1 : cns2param.classification.ud.k4kmeans

	lv2clstrs = labelmatrix (wrflair_lv2clstrs_struct(i));
	lv2clstrs_props = regionprops3(wrflair_lv2clstrs_struct(i),'Centroid');

	for j = 1 : wrflair_lv2clstrs_struct(i).NumObjects

		lin_idx = j + sum([wrflair_lv2clstrs_struct(1:(i-1)).NumObjects]);

		if cns2param.exe.verbose
			fprintf ('%s : %s/%s 1st-level clusters, %s/%s 2nd-level clusters, linear_idx=%s (ID = %s).\n', curr_cmd, ...
																											num2str(i), ...
																											num2str(cns2param.classification.ud.k4kmeans), ...
																											num2str(j), ...
																											num2str(wrflair_lv2clstrs_struct(i).NumObjects), ...
																											num2str(lin_idx), ...
																											cns2param.lists.subjs{idx,1});
		end

		clstr = lv2clstrs;
		clstr (clstr ~= j) = 0;
		clstr (clstr == j) = 1;
		clstr = single (clstr);

		clstr_sz = nnz(clstr);
		
		f_tbl.(f_names{1})(lin_idx) = mean(nonzeros(clstr .* wt1_brn_dat))     / meanInt_GMonT1;
		f_tbl.(f_names{2})(lin_idx) = mean(nonzeros(clstr .* wrflair_brn_dat)) / meanInt_GMonFLAIR;
		f_tbl.(f_names{3})(lin_idx) = mean(nonzeros(clstr .* wt1_brn_dat))     / meanInt_WMonT1;
		f_tbl.(f_names{4})(lin_idx) = mean(nonzeros(clstr .* wrflair_brn_dat)) / meanInt_WMonFLAIR;
		f_tbl.(f_names{5})(lin_idx) = log10(clstr_sz);
		f_tbl.(f_names{6})(lin_idx) = sum(nonzeros(clstr .* gmprob_dat))  / clstr_sz;
		f_tbl.(f_names{7})(lin_idx) = sum(nonzeros(clstr .* wmprob_dat))  / clstr_sz;
		f_tbl.(f_names{8})(lin_idx) = sum(nonzeros(clstr .* csfprob_dat)) / clstr_sz;
		f_tbl.(f_names{9})(lin_idx) = sum(nonzeros(clstr .* ventdst_dat)) / clstr_sz;
		f_tbl.(f_names{10})(lin_idx) = lv2clstrs_props.Centroid(j,1);
		f_tbl.(f_names{11})(lin_idx) = lv2clstrs_props.Centroid(j,2);
		f_tbl.(f_names{12})(lin_idx) = lv2clstrs_props.Centroid(j,3);

		f_tbl_rname{lin_idx,1} = [num2str(i) '_' num2str(j)];
	end
end

f_tbl.Properties.RowNames = f_tbl_rname;

elapsedTimeExtFeatures = toc (etime_extFeatures);

if cns2param.exe.verbose
	fprintf ('%s : %s minutes elapsed to extract %s''s features.\n', curr_cmd, ...
																	num2str(elapsedTimeExtFeatures/60), ...
																	cns2param.lists.subjs{idx,1});
end
