function cns2_wmh_ud_postproc (cns2param,i)

curr_cmd = mfilename;

fprintf ('%s : start postprocessing for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

% which flair/t1 to use for wmh segmentation
switch cns2param.classification.ud.ext_space
case 'dartel'
	flair  = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wrflair_brn.nii');
	t1     = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wt1_brn.nii');
	% apply WM mask if necessary in the future
case 'native'
	% if extracting WMH in native space
	% refer to example above 'dartel'
end

% preproc failure may result in error in finding flair/t1 for wmh segmentation
if ~ isfile (flair)
	ME = MException ('CNS2:postproc:preprocFlairNotFound', ...
					 '%s''s preprocessed FLAIR is not found. This may be because preprocessing finished with ERROR.', ...
					 cns2param.lists.subjs{i,1});
	throw (ME);
end
if ~ isfile (t1)
	ME = MException ('CNS2:postproc:preprocT1NotFound', ...
					 '%s''s preprocessed T1 is not found. This may be because preprocessing finished with ERROR.', ...
					 cns2param.lists.subjs{i,1});
	throw (ME);
end


% 1. classification
% +++++++++++++++++++++
[~,wmhmask_dat] = cns2_wmh_ud_postproc_classification (cns2param,flair,t1,i);

