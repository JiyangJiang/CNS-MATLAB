function cns2_wmh_ud_postproc_quantification (cns2param,wmhmask_dat,flair,i)

curr_cmd=mfilename;

fprintf ('%s : start quantification for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

% quantify volume
vol_tbl = cns2_wmh_ud_postproc_quantification_vol (cns2param,wmhmask_dat,flair,i);

% quantify number of clusters
noc_tbl = cns2_wmh_ud_postproc_quantification_noc (cns2param,wmhmask_dat,flair,i);