function f_tbl = cns2_wmh_ud_postproc_classification_extFeatures (cns2param,flair,t1,lv2clstrs_struct,varargin)

etime_extFeatures = tic;
curr_cmd = mfilename;

if nargin == 5
	subjid = cns2param.lists.subjs{varargin{1},1};
end

if cns2param.exe.verbose && nargin==5
	fprintf ('%s : extracting features for %s.\n', curr_cmd, subjid);
end

% load essential images
t1_dat    = spm_read_vols (spm_vol (t1));
flair_dat = spm_read_vols (spm_vol (flair));
t1_dat    (isnan(t1_dat))    =0;
flair_dat (isnan(flair_dat)) =0;

gmavg_dat = spm_read_vols (spm_vol (cns2param.templates.gmavg));
wmavg_dat = spm_read_vols (spm_vol (cns2param.templates.wmavg));

gmprob_dat  = spm_read_vols (spm_vol (cns2param.templates.gmprob));
wmprob_dat  = spm_read_vols (spm_vol (cns2param.templates.wmprob));
csfprob_dat = spm_read_vols (spm_vol (cns2param.templates.csfprob));

ventdst_dat = spm_read_vols (spm_vol (cns2param.templates.ventdst));

% mean intensities
meanInt_GMonT1    = mean(nonzeros(t1_dat    .* gmavg_dat));
meanInt_WMonT1    = mean(nonzeros(t1_dat    .* wmavg_dat));
meanInt_GMonFLAIR = mean(nonzeros(flair_dat .* gmavg_dat));
meanInt_WMonFLAIR = mean(nonzeros(flair_dat .* wmavg_dat));

% initialise feature table
Nclstrs = sum([lv2clstrs_struct(:).NumObjects]);

f_names = {'1stLvClstrIdx'; '2ndLvClstrIdx'
		   'clstrOverGmOnT1'; 'clstrOverGmOnFLAIR'; 'clstrOverWmOnT1'; 'clstrOverWmOnFLAIR'
		   'logSize'
		   'avgGmProb'; 'avgWmProb'; 'avgCsfProb'
		   'avgVentDst'
		   'cent_x'; 'cent_y'; 'cent_z'};

f_varType = cell(14,1);
f_varType(:) = {'single'};

f_tbl = table ('Size', [Nclstrs 14], ...
			   'VariableTypes', f_varType, ...
			   'VariableNames', f_names);

if nargin==5
	f_tbl.Properties.Description = ['Feature table for ' subjid];
else
	f_tbl.Properties.Description = 'Feature table';
end

f_tbl.Properties.VariableDescriptions = {'index in 1st-level clusters'
										 'index in 2nd-level clusters'
										 'ratio of intensities between cluster and GM on T1'
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

f_tbl_rname = cell(Nclstrs, 1);

switch cns2param.classification.ud.lv1clstr_method
case 'kmeans'
	Nlv1clstrs = cns2param.classification.ud.k4kmeans;
case 'superpixel'
	Nlv1clstrs = cns2param.classification.ud.n4superpixel_actual;
end

% extract features
for i = 1 : Nlv1clstrs

	lv2clstrs = labelmatrix (lv2clstrs_struct(i));
	lv2clstrs_props = regionprops3(lv2clstrs_struct(i),flair_dat,'WeightedCentroid');

	switch cns2param.classification.ud.lv1clstr_method
	case 'kmeans'
		Nlv2clstrs = lv2clstrs_struct(i).NumObjects;
	case 'superpixel'
		Nlv2clstrs = 1;
	end

	for j = 1 : Nlv2clstrs

		lin_idx = j + sum([lv2clstrs_struct(1:(i-1)).NumObjects]);

		if cns2param.exe.verbose
			fprintf ('%s : %s/%s 1st-level clusters, %s/%s 2nd-level clusters, linear_idx=%s/%s', curr_cmd, ...
																								  num2str(i), ...
																								  num2str(Nlv1clstrs), ...
																								  num2str(j), ...
																								  num2str(lv2clstrs_struct(i).NumObjects), ...
																								  num2str(lin_idx), ...
																								  num2str(Nclstrs));
			if nargin==5
				fprintf (' (ID=%s).\n', subjid);
			else
				fprintf ('.\n');
			end
		end

		clstr = lv2clstrs;
		clstr (clstr ~= j) = 0;
		clstr (clstr == j) = 1;
		clstr = single (clstr);

		clstr_sz = nnz(clstr);

		f_tbl.(f_names{1})(lin_idx)  = i;
		f_tbl.(f_names{2})(lin_idx)  = j;
		f_tbl.(f_names{3})(lin_idx)  = mean(nonzeros(clstr .* t1_dat))    / meanInt_GMonT1;
		f_tbl.(f_names{4})(lin_idx)  = mean(nonzeros(clstr .* flair_dat)) / meanInt_GMonFLAIR;
		f_tbl.(f_names{5})(lin_idx)  = mean(nonzeros(clstr .* t1_dat))    / meanInt_WMonT1;
		f_tbl.(f_names{6})(lin_idx)  = mean(nonzeros(clstr .* flair_dat)) / meanInt_WMonFLAIR;
		f_tbl.(f_names{7})(lin_idx)  = log10(clstr_sz);
		f_tbl.(f_names{8})(lin_idx)  = sum(nonzeros(clstr .* gmprob_dat))  / clstr_sz;
		f_tbl.(f_names{9})(lin_idx)  = sum(nonzeros(clstr .* wmprob_dat))  / clstr_sz;
		f_tbl.(f_names{10})(lin_idx) = sum(nonzeros(clstr .* csfprob_dat)) / clstr_sz;
		f_tbl.(f_names{11})(lin_idx) = sum(nonzeros(clstr .* ventdst_dat)) / clstr_sz;
		f_tbl.(f_names{12})(lin_idx) = lv2clstrs_props.WeightedCentroid(j,1);
		f_tbl.(f_names{13})(lin_idx) = lv2clstrs_props.WeightedCentroid(j,2);
		f_tbl.(f_names{14})(lin_idx) = lv2clstrs_props.WeightedCentroid(j,3);

		f_tbl_rname{lin_idx,1} = [num2str(i) '_' num2str(j)];
	end
end

f_tbl.Properties.RowNames = f_tbl_rname;

elapsedTimeExtFeatures = toc (etime_extFeatures);

if cns2param.exe.verbose
	fprintf ('%s : %s minutes elapsed to extract features', curr_cmd, num2str(elapsedTimeExtFeatures/60));
	if nargin==5
		fprintf (' (ID=%s).\n', subjid);
	else
		fprintf ('.\n');
	end
end

% save f_tbl
if ~cns2param.exe.save_dskspc && nargin==5
	fprintf ('%s : saving feature table for %s.\n', curr_cmd, subjid);
	save (fullfile (cns2param.dirs.subjs, subjid, 'ud', 'postproc', 'f_tbl.mat'), 'f_tbl');
elseif ~cns2param.exe.save_dskspc && nargin==4
	[flair_dir,~,~] = fileparts (flair);
	fprintf ('%s : since no index is not passed as argument, feature table is saved to the dir containing flair: \n', curr_cmd);
	fprintf ('%s : %s.\n', curr_cmd, flair_dir);
	save (fullfile (flair_dir,'f_tbl.mat'), 'f_tbl');
end
