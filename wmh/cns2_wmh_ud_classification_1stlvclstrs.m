function [lv1clstrs_dat, cns2param] = cns2_wmh_ud_classification_1stlvclstrs (cns2param, in_nii, out_nii, varargin)
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
switch cns2param.classification.ud.lv1clstr_method
	case 'kmeans'
		lv1clstrs_dat = imsegkmeans3 (single(dat), cns2param.classification.ud.k4kmeans, ...
										'NormalizeInput', true);
	case 'superpixel'
		[lv1clstrs_dat,Nlabels] = superpixels3 (dat, cns2param.classification.ud.n4superpixel);

		% exclude superpixel regions with mean intensity in the bottom 95%
		msk = zeros(size(lv1clstrs_dat));
		idxList = label2idx (lv1clstrs_dat);
		for sp = 1 : Nlabels
			msk(idxList{sp}) = mean(dat(idxList{sp}));
		end
		thr = prctile (msk,95,'all');
		msk(msk<thr) = 0;
		msk(msk>=thr) = 1;
		lv1clstrs_dat = lv1clstrs_dat .* msk;

		% assign serial numbers to intensity (1,2,3 ....)
		uniq = unique(lv1clstrs_dat);
		for i = 1:size(uniq,1)
			lv1clstrs_dat(lv1clstrs_dat==uniq(i))=i;
		end
		lv1clstrs_dat = lv1clstrs_dat - 1; % smallest in uniq was 0, and was assigned with 1.
										   % therefore minus 1.
		cns2param.classification.ud.n4superpixel_actual = size(uniq,1) - 1;
end

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