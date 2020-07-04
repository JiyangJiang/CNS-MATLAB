function noc_tbl = cns2_wmh_ud_postproc_quantification_noc (cns2param,wmhmask_dat,flair,i)

curr_cmd = mfilename;

if cns2param.exe.verbose
	fprintf ('%s : quantifying noc for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});
end

thr = [3 9 15]; % cut-off in number of voxels between punctuate, focal, medium, and confluent

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26); % divide into 26-conn clusters

wbwmh_noc = wmhclstrs_struct.NumObjects; % whole brain noc

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								spm_read_vols(spm_vol(flair)),...
								{'WeightedCentroid','Volume'});

ventdst_dat = spm_read_vols(spm_vol(cns2param.templates.ventdst));
pv_mask = ventdst_dat > cns2param.quantification.ud.pvmag;

lobar_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.lobar));
arterial_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.arterial));

% pv noc
% ==============
pvwmh_noc  = 0;
pvwmh_noc_c  = 0;
pvwmh_noc_m = 0;
pvwmh_noc_f  = 0;
pvwmh_noc_p  = 0;

% lobar noc
% ============
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
unid_lob_noc = 0;

lfron_noc_c = 0;
rfron_noc_c = 0;
ltemp_noc_c = 0;
rtemp_noc_c = 0;
lpari_noc_c = 0;
rpari_noc_c = 0;
locci_noc_c = 0;
rocci_noc_c = 0;
lcere_noc_c = 0;
rcere_noc_c = 0;
brnstm_noc_c = 0;
unid_lob_noc_c = 0;

lfron_noc_m = 0;
rfron_noc_m = 0;
ltemp_noc_m = 0;
rtemp_noc_m = 0;
lpari_noc_m = 0;
rpari_noc_m = 0;
locci_noc_m = 0;
rocci_noc_m = 0;
lcere_noc_m = 0;
rcere_noc_m = 0;
brnstm_noc_m = 0;
unid_lob_noc_m = 0;

lfron_noc_f = 0;
rfron_noc_f = 0;
ltemp_noc_f = 0;
rtemp_noc_f = 0;
lpari_noc_f = 0;
rpari_noc_f = 0;
locci_noc_f = 0;
rocci_noc_f = 0;
lcere_noc_f = 0;
rcere_noc_f = 0;
brnstm_noc_f = 0;
unid_lob_noc_f = 0;

lfron_noc_p = 0;
rfron_noc_p = 0;
ltemp_noc_p = 0;
rtemp_noc_p = 0;
lpari_noc_p = 0;
rpari_noc_p = 0;
locci_noc_p = 0;
rocci_noc_p = 0;
lcere_noc_p = 0;
rcere_noc_p = 0;
brnstm_noc_p = 0;
unid_lob_noc_p = 0;

% arterial noc
% ============
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
unid_art_noc = 0;

raah_noc_c = 0;
laah_noc_c = 0;
rmah_noc_c = 0;
lmah_noc_c = 0;
raaml_noc_c = 0;
laaml_noc_c = 0;
raac_noc_c = 0;
laac_noc_c = 0;
rmall_noc_c = 0;
lmall_noc_c = 0;
rpatmp_noc_c = 0;
lpatmp_noc_c = 0;
rpah_noc_c = 0;
lpah_noc_c = 0;
rpac_noc_c = 0;
lpac_noc_c = 0;
unid_art_noc_c = 0;

raah_noc_m = 0;
laah_noc_m = 0;
rmah_noc_m = 0;
lmah_noc_m = 0;
raaml_noc_m = 0;
laaml_noc_m = 0;
raac_noc_m = 0;
laac_noc_m = 0;
rmall_noc_m = 0;
lmall_noc_m = 0;
rpatmp_noc_m = 0;
lpatmp_noc_m = 0;
rpah_noc_m = 0;
lpah_noc_m = 0;
rpac_noc_m = 0;
lpac_noc_m = 0;
unid_art_noc_m = 0;

raah_noc_f = 0;
laah_noc_f = 0;
rmah_noc_f = 0;
lmah_noc_f = 0;
raaml_noc_f = 0;
laaml_noc_f = 0;
raac_noc_f = 0;
laac_noc_f = 0;
rmall_noc_f = 0;
lmall_noc_f = 0;
rpatmp_noc_f = 0;
lpatmp_noc_f = 0;
rpah_noc_f = 0;
lpah_noc_f = 0;
rpac_noc_f = 0;
lpac_noc_f = 0;
unid_art_noc_f = 0;

raah_noc_p = 0;
laah_noc_p = 0;
rmah_noc_p = 0;
lmah_noc_p = 0;
raaml_noc_p = 0;
laaml_noc_p = 0;
raac_noc_p = 0;
laac_noc_p = 0;
rmall_noc_p = 0;
lmall_noc_p = 0;
rpatmp_noc_p = 0;
lpatmp_noc_p = 0;
rpah_noc_p = 0;
lpah_noc_p = 0;
rpac_noc_p = 0;
lpac_noc_p = 0;
unid_art_noc_p = 0;


for i = 1:wbwmh_noc
	
	% noc with/without considering size
	% =================================

	% coordinates
	x = wmhclstrs_props.WeightedCentroid(i,1);
	y = wmhclstrs_props.WeightedCentroid(i,2);
	z = wmhclstrs_props.WeightedCentroid(i,3);

	% size in num of voxels
	siz = wmhclstrs_props.Volume(i);

	if pv_mask(x,y,z)==1
		pvwmh_noc = pvwmh_noc + 1;
	else
		switch lobar_atlas_dat(x,y,z)
	      case 7
	      	lfron_noc = lfron_noc + 1;
	      	if siz <= thr(1)
	      		lfron_noc_p = lfron_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				lfron_noc_f = lfron_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lfron_noc_m = lfron_noc_m + 1;
			else
				lfron_noc_c = lfron_noc_c + 1;
			end
	      case 6
	      	rfron_noc = rfron_noc + 1;
	      	if siz <= thr(1)
	      		rfron_noc_p = rfron_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				rfron_noc_f = rfron_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rfron_noc_m = rfron_noc_m + 1;
			else
				rfron_noc_c = rfron_noc_c + 1;
			end
	      case 4
	      	ltemp_noc = ltemp_noc + 1;
	      	if siz <= thr(1)
	      		ltemp_noc_p = ltemp_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				ltemp_noc_f = ltemp_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				ltemp_noc_m = ltemp_noc_m + 1;
			else
				ltemp_noc_c = ltemp_noc_c + 1;
			end
	      case 5
	      	rtemp_noc = rtemp_noc + 1;
	      	if siz <= thr(1)
	      		rtemp_noc_p = rtemp_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				rtemp_noc_f = rtemp_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rtemp_noc_m = rtemp_noc_m + 1;
			else
				rtemp_noc_c = rtemp_noc_c + 1;
			end
	      case 17
	      	lpari_noc = lpari_noc + 1;
	      	if siz <= thr(1)
	      		lpari_noc_p = lpari_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				lpari_noc_f = lpari_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lpari_noc_m = lpari_noc_m + 1;
			else
				lpari_noc_c = lpari_noc_c + 1;
			end
	      case 16
	      	rpari_noc = rpari_noc + 1;
	      	if siz <= thr(1)
	      		rpari_noc_p = rpari_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				rpari_noc_f = rpari_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rpari_noc_m = rpari_noc_m + 1;
			else
				rpari_noc_c = rpari_noc_c + 1;
			end
	      case 12
	      	locci_noc = locci_noc + 1;
	      	if siz <= thr(1)
	      		locci_noc_p = locci_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				locci_noc_f = locci_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				locci_noc_m = locci_noc_m + 1;
			else
				locci_noc_c = locci_noc_c + 1;
			end
	      case 11
	      	rocci_noc = rocci_noc + 1;
	      	if siz <= thr(1)
	      		rocci_noc_p = rocci_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				rocci_noc_f = rocci_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rocci_noc_m = rocci_noc_m + 1;
			else
				rocci_noc_c = rocci_noc_c + 1;
			end
	      case 2
	      	lcere_noc = lcere_noc + 1;
	      	if siz <= thr(1)
	      		lcere_noc_p = lcere_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				lcere_noc_f = lcere_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lcere_noc_m = lcere_noc_m + 1;
			else
				lcere_noc_c = lcere_noc_c + 1;
			end
	      case 1
	      	rcere_noc = rcere_noc + 1;
	      	if siz <= thr(1)
	      		rcere_noc_p = rcere_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				rcere_noc_f = rcere_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rcere_noc_m = rcere_noc_m + 1;
			else
				rcere_noc_c = rcere_noc_c + 1;
			end
	      case 3
	      	brnstm_noc = brnstm_noc + 1;
	      	if siz <= thr(1)
	      		brnstm_noc_p = brnstm_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				brnstm_noc_f = brnstm_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				brnstm_noc_m = brnstm_noc_m + 1;
			else
				brnstm_noc_c = brnstm_noc_c + 1;
			end
	      otherwise
	      	unid_lob_noc = unid_lob_noc + 1;
	      	if siz <= thr(1)
	      		unid_lob_noc_p = unid_lob_noc_p + 1;
			elseif siz > thr(1) && siz <= thr(2)
				unid_lob_noc_f = unid_lob_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				unid_lob_noc_m = unid_lob_noc_m + 1;
			else
				unid_lob_noc_c = unid_lob_noc_c + 1;
			end
		end
	end

	switch arterial_atlas_dat(x,y,z)
		case 1
			raah_noc = raah_noc + 1;
			if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 2
		   	laah_noc = laah_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 3
		   	rmah_noc = rmah_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 6
		   	lmah_noc = lmah_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 13
		  	raaml_noc = raaml_noc + 1;
		  	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 14
		  	laaml_noc = laaml_noc + 1;
		  	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 7
		   	raac_noc = raac_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 8
		   	laac_noc = laac_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 9
		  	rmall_noc = rmall_noc + 1;
		  	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 10
		  	lmall_noc = lmall_noc + 1;
		  	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 11
		 	rpatmp_noc = rpatmp_noc + 1;
		 	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 12
		 	lpatmp_noc = lpatmp_noc + 1;
		 	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 4
		   	rpah_noc = rpah_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 5
		   	lpah_noc = lpah_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 15
		   	rpac_noc = rpac_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
		case 16
		   	lpac_noc = lpac_noc + 1;
		   	if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
	   	otherwise
	   		unid_art_noc = unid_art_noc + 1;
	   		if siz <= thr(1)
	      	elseif siz > thr(1) && siz <= thr(2)
			elseif siz > thr(2) && siz <= thr(3)
			else
			end
	end

end

noc_tbl = table (wbwmh_noc, pvwmh_noc, ...
				 lfron_noc,rfron_noc,ltemp_noc,rtemp_noc,lpari_noc,rpari_noc,locci_noc,rocci_noc,lcere_noc,rcere_noc,brnstm_noc,unid_lob_noc, ...
				 raah_noc,laah_noc,rmah_noc,lmah_noc,raaml_noc,laaml_noc,raac_noc,laac_noc,rmall_noc,lmall_noc,rpatmp_noc,lpatmp_noc,rpah_noc,lpah_noc,rpac_noc,lpac_noc,unid_art_noc);