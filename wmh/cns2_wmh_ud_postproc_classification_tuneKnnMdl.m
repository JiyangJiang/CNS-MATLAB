function cns2_wmh_ud_postproc_classification_knn (cns2param)

t_dat = load (fullfile (cns2param.dirs.cns2, ...
						'wmh', ...
						'cns2_wmh_ud_postproc_classification_builtInTrainTbl.mat'));
t_tbl = t_dat.tbl;

knn_mdl = fitcknn (t_tbl(:,1:9), t_tbl(:,13), ...
				   'NSMethod',       'exhaustive', ...
				   'Distance',       'seuclidean', ...
				   'DistanceWeight', 'equal', ...
				   'NumNeighbors',   cns2param.classification.ud.k4knn, ...
				   'Standardize',    true);

% cross-validation
partitionedMdl = crossval (knn_mdl, 'KFold', 10);
[validationPredictions, validationScores] = kfoldPredict (partitionedMdl);
validationAccuracy = 1 - kfoldLoss (partitionedMdl, 'LossFun', 'ClassifError');

saveLearnerForCoder (knn_mdl, ...
					 fullfile (cns2param.dirs.cns2, ...
					 		   'wmh', ...
					 		   'cns2_wmh_ud_postproc_classification_knnMdl.mat');