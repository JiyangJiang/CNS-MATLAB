
function wmhmask_dat = cns2_wmh_ud_classification (cns2param)

curr_cmd = mfilename;

parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
% for i = 1 : cns2param.n_subjs

	diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

	try
		fprintf ('%s : start classification for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

		switch cns2param.classification.ud.ext_space

		case 'dartel'

			flair  = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_brn.nii');
			t1     = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wt1_brn.nii');
			%
			% apply WM mask if necessary in the future
			%
			if ~ isfile (flair)
				ME = MException ('CNS2:classification:wrflair_brnNotFound', ...
								 '%s''s wrflair_brn.nii is not found. This may be because preprocessing finished with ERROR.', ...
								 cns2param.lists.subjs{i,1});
				throw (ME);
			end
			if ~ isfile (t1)
				ME = MException ('CNS2:classification:wt1_brnNotFound', ...
								 '%s''s wt1_brn.nii is not found. This may be because preprocessing finished with ERROR.', ...
								 cns2param.lists.subjs{i,1});
				throw (ME);
			end

		case 'native'

			% if extracting WMH in native space
			% refer to example above 'dartel'

		end

		% 1st-level clusters
		% ++++++++++++++++++
		[lv1clstrs_dat,cns2param] = cns2_wmh_ud_classification_1stlvclstrs (cns2param, ...
																			flair, ...
																			fullfile (cns2param.dirs.subjs, ...
																					  cns2param.lists.subjs{i,1}, ...
																					  'lv1clstrs.nii'), ...
																			i);
		% 2nd-level clusters
		% ++++++++++++++++++
		lv2clstrs_struct = cns2_wmh_ud_classification_2ndlvclstrs (cns2param, ...
																   lv1clstrs_dat, ...
																   spm_vol(flair), ...
																   fullfile (cns2param.dirs.subjs, ...
																   			 cns2param.lists.subjs{i,1}, ...
																   			 'lv2clstrs.nii'), ...
																   i);
		% extract features
		% ++++++++++++++++
		f_tbl = cns2_wmh_ud_classification_extFeatures (cns2param, ...
														flair, ...
														t1, ...
														lv2clstrs_struct, ...
														i);

		% predict
		% +++++++++++++++
		mdl = loadLearnerForCoder(fullfile (cns2param.dirs.cns2, 'wmh', 'cns2_wmh_ud_classification_knnMdl.mat'));
		[~, wmhmask_dat] = cns2_wmh_ud_classification_predict  (cns2param,...
																lv2clstrs_struct,...
																f_tbl,...
																mdl,...
																spm_vol(flair),...
																i);


		fprintf ('%s : %s finished classification without error.\n', curr_cmd, cns2param.lists.subjs{i,1});


	catch ME

		switch ME.identifier
			case 'CNS2:classification:wrflair_brnNotFound'
				fprintf (2,'\nCNS2 exception thrown\n');
				fprintf (2,'++++++++++++++++++++++\n');
				fprintf (2,'identifier:%s\n', ME.identifier);
				fprintf (2,'message:%s\n\n', ME.message);
			otherwise
				fprintf (2,'\nUnknown exception thrown\n');
				fprintf (2,'++++++++++++++++++++++\n');
				fprintf (2,'identifier: %s\n', ME.identifier);
				fprintf (2,'message: %s\n\n', ME.message);
		end

		fprintf ('%s : %s finished classification with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off

end
