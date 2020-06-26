function lv1clstrs_dat = cns2_wmh_ud_classification_1stlvclstrs (cns2param, in_nii, out_nii, varargin)
curr_cmd = mfilename;

if nargin == 4
	idx = varargin{1};
end

if cns2param.exe.verbose && nargin==4
	fprintf ('%s : generating %s''s 1st-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end

hdr = spm_vol (in_nii);
dat = spm_read_vols (hdr);

% zero nan
dat(isnan(dat)) = 0;

% volume segmentation using k-means (1st-level clusters)
lv1clstrs_dat = imsegkmeans3 (single(dat), cns2param.classification.ud.k4kmeans, 'NormalizeInput', true);

% write out k-means clusters (1st-level clusters)
if  ~cns2param.exe.save_dskspc
	if cns2param.exe.verbose && nargin==4
		fprintf ('%s : writing %s''s 1st-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
	elseif cns2param.exe.verbose && nargin==3
		fprintf ('%s : writing 1st-level clusters.\n', curr_cmd);
	end
	cns2_scripts_writeNii (cns2param, ...
						   hdr, ...
						   lv1clstrs_dat, ...
						   out_nii);
end