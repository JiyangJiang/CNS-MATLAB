function arterial_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_arterial (cns2param,x,y,z,siz,thr)

arterial_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.arterial));


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

switch arterial_atlas_dat(x,y,z)
	case 1
		raah_noc = raah_noc + 1;
		if siz <= thr(1)
			raah_noc_p = raah_noc_p + 1;
      	elseif siz > thr(1) && siz <= thr(2)
      		raah_noc_f = raah_noc_f + 1;
		elseif siz > thr(2) && siz <= thr(3)
			raah_noc_m = raah_noc_m + 1;
		else
			raah_noc_c = raah_noc_c + 1;
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


raah_noc,...
laah_noc,...
rmah_noc,...
lmah_noc,...
raaml_noc,...
laaml_noc,...
raac_noc,...
laac_noc,...
rmall_noc,...
lmall_noc,...
rpatmp_noc,...
lpatmp_noc,...
rpah_noc,...
lpah_noc,...
rpac_noc,...
lpac_noc,...
unid_art_noc,...