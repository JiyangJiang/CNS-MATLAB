
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

		% volume segmentation using k-means (1st-level clusters)
		if cns2param.exe.verbose
			fprintf ('%s : generating %s''s 1st-level clusters.\n', curr_cmd, cns2param.lists.subjs{i,1});
		end

		wrflair_lv1clstrs_dat = imsegkmeans3 (single(wrflair_brn_dat), ...
											  cns2param.classification.k4kmeans, ...
											  'NormalizeInput', true);

		% write out k-means clusters (1st-level clusters)
		if  ~cns2param.exe.save_dskspc
			if cns2param.exe.verbose
				fprintf ('%s : writing %s''s 1st-level clusters.\n', curr_cmd, cns2param.lists.subjs{i,1});
			end
			cns2_scripts_writeNii (cns2param, ...
								   wrflair_brn_hdr, ...
								   wrflair_lv1clstrs_dat, ...
								   fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_lv1clstrs.nii'));
		end

		% form 2nd-level clusters using 6-connectivity
		if cns2param.exe.verbose
			fprintf ('%s : generating %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{i,1});
		end

			% initialise to resolve the parfor classification issue
		wrflair_lv2clstrs_dat = zeros ([size(wrflair_lv1clstrs_dat) cns2param.classification.k4kmeans]);
		
		for k = 1 : cns2param.classification.k4kmeans
			tmp = wrflair_lv1clstrs_dat;
			tmp (tmp ~= k) = 0;
			tmp (tmp == k) = 1;
			wrflair_lv2clstrs_dat (:,:,:,k) = labelmatrix (bwconncomp (tmp, 6)); % 6-connectivity
		end

		% write out 2nd-level clusters
		if  ~cns2param.exe.save_dskspc && ~cns2param.exe.save_more_dskspc
			if cns2param.exe.verbose
				fprintf ('%s : writing %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{i,1});
			end
			cns2_scripts_writeNii (cns2param, ...
								   wrflair_brn_hdr, ...
								   wrflair_lv2clstrs_dat, ...
								   fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'wrflair_lv2clstrs.nii'), ...
								   '4d');
		end

		fprintf ('%s : %s finished classification without error.\n', curr_cmd, cns2param.lists.subjs{i,1})


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
