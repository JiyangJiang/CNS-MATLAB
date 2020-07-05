function arterial_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_arterial (cns2param,wmhclstrs_struct,flair)

arterial_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.arterial));

thr = cns2param.quantification.ud.sizthr;

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								spm_read_vols(spm_vol(flair)),...
								{'WeightedCentroid','Volume'});

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


for i = 1:wmhclstrs_struct.NumObjects

	% coordinates
	% NOTE that the 1st and 2nd dimension need to
	%      be flipped after visual inspection, to
	%      correspond to the correct position on
	%      nifti images
	x = round(wmhclstrs_props.WeightedCentroid(i,2));
	y = round(wmhclstrs_props.WeightedCentroid(i,1));
	z = round(wmhclstrs_props.WeightedCentroid(i,3));

	% size in num of voxels
	siz = wmhclstrs_props.Volume(i);


	% count arterial noc with and without
	% considering size
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
		   		laah_noc_p = laah_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		laah_noc_f = laah_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				laah_noc_m = laah_noc_m + 1;
			else
				laah_noc_c = laah_noc_c + 1;
			end
		case 3
		   	rmah_noc = rmah_noc + 1;
		   	if siz <= thr(1)
		   		rmah_noc_p = rmah_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		rmah_noc_f = rmah_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rmah_noc_m = rmah_noc_m + 1;
			else
				rmah_noc_c = rmah_noc_c + 1;
			end
		case 6
		   	lmah_noc = lmah_noc + 1;
		   	if siz <= thr(1)
		   		lmah_noc_p = lmah_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		lmah_noc_f = lmah_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lmah_noc_m = lmah_noc_m + 1;
			else
				lmah_noc_c = lmah_noc_c + 1;
			end
		case 13
		  	raaml_noc = raaml_noc + 1;
		  	if siz <= thr(1)
		  		raaml_noc_p = raaml_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		raaml_noc_f = raaml_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				raaml_noc_m = raaml_noc_m + 1;
			else
				raaml_noc_c = raaml_noc_c + 1;
			end
		case 14
		  	laaml_noc = laaml_noc + 1;
		  	if siz <= thr(1)
		  		laaml_noc_p = laaml_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		laaml_noc_f = laaml_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				laaml_noc_m = laaml_noc_m + 1;
			else
				laaml_noc_c = laaml_noc_c + 1;
			end
		case 7
		   	raac_noc = raac_noc + 1;
		   	if siz <= thr(1)
		   		raac_noc_p = raac_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		raac_noc_f = raac_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				raac_noc_m = raac_noc_m + 1;
			else
				raac_noc_c = raac_noc_c + 1;
			end
		case 8
		   	laac_noc = laac_noc + 1;
		   	if siz <= thr(1)
		   		laac_noc_p = laac_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		laac_noc_f = laac_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				laac_noc_m = laac_noc_m + 1;
			else
				laac_noc_c = laac_noc_c + 1;
			end
		case 9
		  	rmall_noc = rmall_noc + 1;
		  	if siz <= thr(1)
		  		rmall_noc_p = rmall_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		rmall_noc_f = rmall_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rmall_noc_m = rmall_noc_m + 1;
			else
				rmall_noc_c = rmall_noc_c + 1;
			end
		case 10
		  	lmall_noc = lmall_noc + 1;
		  	if siz <= thr(1)
		  		lmall_noc_p = lmall_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		lmall_noc_f = lmall_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lmall_noc_m = lmall_noc_m + 1;
			else
				lmall_noc_c = lmall_noc_c + 1;
			end
		case 11
		 	rpatmp_noc = rpatmp_noc + 1;
		 	if siz <= thr(1)
		 		rpatmp_noc_p = rpatmp_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		rpatmp_noc_f = rpatmp_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rpatmp_noc_m = rpatmp_noc_m + 1;
			else
				rpatmp_noc_c = rpatmp_noc_c + 1;
			end
		case 12
		 	lpatmp_noc = lpatmp_noc + 1;
		 	if siz <= thr(1)
		 		lpatmp_noc_p = lpatmp_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		lpatmp_noc_f = lpatmp_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lpatmp_noc_m = lpatmp_noc_m + 1;
			else
				lpatmp_noc_c = lpatmp_noc_c + 1;
			end
		case 4
		   	rpah_noc = rpah_noc + 1;
		   	if siz <= thr(1)
		   		rpah_noc_p = rpah_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		rpah_noc_f = rpah_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rpah_noc_m = rpah_noc_m + 1;
			else
				rpah_noc_c = rpah_noc_c + 1;
			end
		case 5
		   	lpah_noc = lpah_noc + 1;
		   	if siz <= thr(1)
		   		lpah_noc_p = lpah_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		lpah_noc_f = lpah_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lpah_noc_m = lpah_noc_m + 1;
			else
				lpah_noc_c = lpah_noc_c + 1;
			end
		case 15
		   	rpac_noc = rpac_noc + 1;
		   	if siz <= thr(1)
		   		rpac_noc_p = rpac_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		rpac_noc_f = rpac_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				rpac_noc_m = rpac_noc_m + 1;
			else
				rpac_noc_c = rpac_noc_c + 1;
			end
		case 16
		   	lpac_noc = lpac_noc + 1;
		   	if siz <= thr(1)
		   		lpac_noc_p = lpac_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		lpac_noc_f = lpac_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				lpac_noc_m = lpac_noc_m + 1;
			else
				lpac_noc_c = lpac_noc_c + 1;
			end
	   	otherwise
	   		unid_art_noc = unid_art_noc + 1;
	   		if siz <= thr(1)
	   			unid_art_noc_p = unid_art_noc_p + 1;
	      	elseif siz > thr(1) && siz <= thr(2)
	      		unid_art_noc_f = unid_art_noc_f + 1;
			elseif siz > thr(2) && siz <= thr(3)
				unid_art_noc_m = unid_art_noc_m + 1;
			else
				unid_art_noc_c = unid_art_noc_c + 1;
			end
	end
end


arterial_noc_tbl = table   (raah_noc,...
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
								raah_noc_p,...
								laah_noc_p,...
								rmah_noc_p,...
								lmah_noc_p,...
								raaml_noc_p,...
								laaml_noc_p,...
								raac_noc_p,...
								laac_noc_p,...
								rmall_noc_p,...
								lmall_noc_p,...
								rpatmp_noc_p,...
								lpatmp_noc_p,...
								rpah_noc_p,...
								lpah_noc_p,...
								rpac_noc_p,...
								lpac_noc_p,...
								unid_art_noc_p,...
									raah_noc_f,...
									laah_noc_f,...
									rmah_noc_f,...
									lmah_noc_f,...
									raaml_noc_f,...
									laaml_noc_f,...
									raac_noc_f,...
									laac_noc_f,...
									rmall_noc_f,...
									lmall_noc_f,...
									rpatmp_noc_f,...
									lpatmp_noc_f,...
									rpah_noc_f,...
									lpah_noc_f,...
									rpac_noc_f,...
									lpac_noc_f,...
									unid_art_noc_f,...
										raah_noc_m,...
										laah_noc_m,...
										rmah_noc_m,...
										lmah_noc_m,...
										raaml_noc_m,...
										laaml_noc_m,...
										raac_noc_m,...
										laac_noc_m,...
										rmall_noc_m,...
										lmall_noc_m,...
										rpatmp_noc_m,...
										lpatmp_noc_m,...
										rpah_noc_m,...
										lpah_noc_m,...
										rpac_noc_m,...
										lpac_noc_m,...
										unid_art_noc_m,...
											raah_noc_c,...
											laah_noc_c,...
											rmah_noc_c,...
											lmah_noc_c,...
											raaml_noc_c,...
											laaml_noc_c,...
											raac_noc_c,...
											laac_noc_c,...
											rmall_noc_c,...
											lmall_noc_c,...
											rpatmp_noc_c,...
											lpatmp_noc_c,...
											rpah_noc_c,...
											lpah_noc_c,...
											rpac_noc_c,...
											lpac_noc_c,...
											unid_art_noc_c);