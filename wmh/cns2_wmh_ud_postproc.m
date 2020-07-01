function cns2_wmh_ud_postproc (cns2param,i)

curr_cmd = mfilename;

fprintf ('%s : start postprocessing for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

% postprocessing starts here
%
% 1. classification
[~,wmhmask_dat] = cns2_wmh_ud_postproc_classification (cns2param,i);

