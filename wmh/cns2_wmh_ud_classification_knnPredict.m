function cns2_wmh_ud_classification_knnPredict (cns2param,f_tbl)

knn_mdl = loadLearnerForCoder(fullfile (cns2param.dirs.cns2, 'wmh', 'cns2_wmh_ud_classification_defKnnMdl.mat'));

predict (knn_mdl, f_tbl(:,1:9));

% --== TBC ==--