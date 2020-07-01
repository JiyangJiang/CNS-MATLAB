function cns2_wmh_ud_postproc_quantification (cns2param,wmhmask_dat)

curr_cmd=mfilename;

fprintf ('%s : start classification for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

ventdst_dat = spm_read_vols(spm_vol(cns2param.templates.ventdst));

