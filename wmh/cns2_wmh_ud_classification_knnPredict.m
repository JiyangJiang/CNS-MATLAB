function cns2_wmh_ud_classification_knnPredict (cns2param,f_tbl,lv2clstrs_struct)

knn_mdl = loadLearnerForCoder(fullfile (cns2param.dirs.cns2, 'wmh', 'cns2_wmh_ud_classification_knnMdl.mat'));

% only use 3:11 columns as 1:2 columns are 1st-level and 2nd-level
% cluster index, and 12:14 columns are centroid coordinates
[label,score,cost] = predict (knn_mdl, f_tbl(:,3:11));

% add the probability to the last column of feature table
fd_tbl = [f_tbl score];??????

% assign label to 2nd-level clusters
switch cns2param.classification.ud.lv1clstr_method
case 'kmeans'
	Nlv1clstrs = cns2param.classification.ud.k4kmeans;
case 'superpixel'
	Nlv1clstrs = cns2param.classification.ud.n4superpixel_actual;
end