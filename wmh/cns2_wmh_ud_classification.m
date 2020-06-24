
function cns2_wmh_ud_classification (cns2param)

curr_cmd = mfilename;
fprintf ('%s : start classification.\n', curr_cmd);

% parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)
for i = 1 : cns2param.n_subjs

	diary (fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'log'));

	try
		wrflair_brn = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_brn.nii');

		if ~ isfile (wrflair_brn)
			ME = MException ('CNS2:classification:wrflair_brnNotFound', ...
							 '%s''s wrflair_brn.nii is not found. This may be because preprocessing finished with ERROR.', ...
							 cns2param.lists.subjs{i,1});
			throw (ME);
		end

		wrflair_brn_hdr = spm_vol (wrflair_brn);
		wrflair_brn_dat = spm_read_vols (wrflair_brn_hdr);

		% zero nan
		wrflair_brn_dat (isnan(wrflair_brn_dat)) = 0;


		% 1st-level clusters
		% ++++++++++++++++++
		wrflair_lv1clstrs_dat = cns2_wmh_ud_classification_1stlvclstrs (cns2param, ...
																		wrflair_brn_dat, ...
																		wrflair_brn_hdr, ...
																		i);

		% 2nd-level clusters
		% ++++++++++++++++++
		wrflair_lv2clstrs_dat = cns2_wmh_ud_classification_2ndlvclstrs (cns2param, ...
																		wrflair_lv1clstrs_dat, ...
																		wrflair_brn_hdr, ...
																		i);

		% extract features
		cns2_wmh_ud_classification_extFeatures (cns2param, ...
												wrflair_lv2clstrs_dat, ...
												i);

		fprintf ('%s : %s finished classification without error.\n', curr_cmd, cns2param.lists.subjs{i,1});


	catch ME

		switch ME.identifier
			case 'CNS2:classification:wrflair_brnNotFound'
				fprintf (2,'\nCNS2 exception thrown\n');
				fprintf (2,'++++++++++++++++++++++\n');
				fprintf (2,'\nidentifier:\n%s\n', ME.identifier);
				fprintf (2,'\nmessage:\n%s\n\n', ME.message);
			otherwise
				fprintf (2,'\nUnknown exception thrown\n');
				fprintf (2,'++++++++++++++++++++++\n');
				fprintf (2,'identifier: %s\n', ME.identifier);
				fprintf (2,'message: %s\n', ME.message);
		end

		fprintf ('%s : %s finished classification with ERROR.\n', curr_cmd, cns2param.lists.subjs{i,1});

	end

	diary off

end
