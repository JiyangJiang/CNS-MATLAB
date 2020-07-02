function cns2_wmh_ud_postproc_quantification (cns2param,wmhmask_dat,flair)

curr_cmd=mfilename;

fprintf ('%s : start classification for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

% voxel size
hdr=spm_vol(flair);
voxsiz = abs(det(hdr.mat));

% whole brain WMH vol
wbwmh_vol = sum(nonzeros(wmhmask_dat)) * voxsiz;

% separation between PVWMH and DWMH
ventdst_dat = spm_read_vols(spm_vol(cns2param.templates.ventdst));
pv_mask = ventdst > cns2param.quantification.ud.pvmag;
pvwmh_dat = wmhmask_dat .* pv_mask;
dwmh_dat = wmhmask_dat - pvwmh_dat; % NOTE that dwmh vol calculated this way may be
									% larger than summing all ROIs together as some
									% wmh voxels may not fall in ROI atlas.
pvwmh_vol = sum(nonzeros(pvwmh_dat)) * voxsiz;
dwmh_vol  = sum(nonzeros(dwmh_dat))  * voxsiz;

% lobar measures
lobar_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.lobar));
dwmh_lobar_dat = dwmh_dat .* lobar_atlas_dat;

lfron_dat = dwmh_lobar_dat==7;
rfron_dat = dwmh_lobar_dat==6;
ltemp_dat = dwmh_lobar_dat==4;
rtemp_dat = dwmh_lobar_dat==5;
lpari_dat = dwmh_lobar_dat==17;
rpari_dat = dwmh_lobar_dat==16;
locci_dat = dwmh_lobar_dat==12;
rocci_dat = dwmh_lobar_dat==11;
lcere_dat = dwmh_lobar_dat==2;
rcere_dat = dwmh_lobar_dat==1;
brnstm_dat = dwmh_lobar_dat==3;

lfron_vol = sum(nonzeros(lfron_dat)) * voxsiz;
