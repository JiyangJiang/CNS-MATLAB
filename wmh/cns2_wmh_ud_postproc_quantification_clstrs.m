function ct_tbl = cns2_wmh_ud_postproc_quantification_clstrs (cns2param,wmhmask_dat,flair)

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26);

% whole brain noc
wbwmh_noc = wmhclstrs_struct.NumObjects;

wmh_cent_tbl = regionprops3(wmhclstrs_struct,...
							spm_read_vols(spm_vol(flair)),...
							'WeightedCentroid');

Ncent = size(wmh_cent_tbl,1);

ventdst_dat = spm_read_vols(spm_vol(cns2param.templates.ventdst));
pv_mask = ventdst_dat > cns2param.quantification.ud.pvmag;

lobar_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.lobar));
arterial_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.arterial));

% pv noc
pvwmh_noc  = 0;

% lobar noc
lfron_noc  = 0;
rfron_noc  = 0;
ltemp_noc  = 0;
rtemp_noc  = 0;
lpari_noc  = 0;
rpari_noc  = 0;
locci_noc  = 0;
rocci_noc  = 0;
lcere_noc  = 0;
rcere_noc  = 0;
brnstm_noc = 0;

% arterial noc
raah_noc   = 0;
laah_noc   = 0;
rmah_noc   = 0;
lmah_noc   = 0;
raaml_noc  = 0;
laaml_noc  = 0;
raac_noc   = 0;
laac_noc   = 0;
rmall_noc  = 0;
lmall_noc  = 0;
rpatmp_noc = 0;
lpatmp_noc = 0;
rpah_noc   = 0;
lpah_noc   = 0;
rpac_noc   = 0;
lpac_noc   = 0;


for i = 1:wbwmh_noc
	x = wmh_cent_tbl.WeightedCentroid(i,1);
	y = wmh_cent_tbl.WeightedCentroid(i,2);
	z = wmh_cent_tbl.WeightedCentroid(i,3);

	if pv_mask(x,y,z)==1
		pvwmh_noc = pvwmh_noc + 1;
	end

	switch lobar_atlas_dat(x,y,z)
      case 7
      	lfron_noc = lfron_noc + 1;
      case 6
      	rfron_noc = rfron_noc + 1;
      case 4
      	ltemp_noc = ltemp_noc + 1;
      case 5
      	rtemp_noc = rtemp_noc + 1;
      case 17
      	lpari_noc = lpari_noc + 1;
      case 16
      	rpari_noc = rpari_noc + 1;
      case 12
      	locci_noc = locci_noc + 1;
      case 11
      	rocci_noc = rocci_noc + 1;
      case 2
      	lcere_noc = lcere_noc + 1;
      case 1
      	rcere_noc = rcere_noc + 1;
      case 3
      	brnstm_noc = brnstm_noc + 1;
	end

	switch arterial_atlas_dat(x,y,z)
		case 1
			raah_noc = raah_noc + 1;
		case 2
		   	laah_noc = laah_noc + 1;
		case 3
		   	rmah_noc = rmah_noc + 1;
		case 6
		   	lmah_noc = lmah_noc + 1;
		case 13
		  	raaml_noc = raaml_noc + 1;
		case 14
		  	laaml_noc = laaml_noc + 1;
		case 7
		   	raac_noc = raac_noc + 1;
		case 8
		   	laac_noc = laac_noc + 1;
		case 9
		  	rmall_noc = rmall_noc + 1;
		case 10
		  	lmall_noc = lmall_noc + 1;
		case 11
		 	rpatmp_noc = rpatmp_noc + 1;
		case 12
		 	lpatmp_noc = lpatmp_noc + 1;
		case 4
		   	rpah_noc = rpah_noc + 1;
		case 5
		   	lpah_noc = lpah_noc + 1;
		case 15
		   	rpac_noc = rpac_noc + 1;
		case 16
		   	lpac_noc = lpac_noc + 1;
	end
end
