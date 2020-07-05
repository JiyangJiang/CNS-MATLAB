function lobar_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_lobar (cns2param,wmhclstrs_struct,flair)

ventdst_dat = spm_read_vols(spm_vol(cns2param.templates.ventdst));
pv_mask = ventdst_dat > cns2param.quantification.ud.pvmag;
lobar_atlas_dat = spm_read_vols(spm_vol(cns2param.templates.lobar));

thr = cns2param.quantification.ud.sizthr;

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								spm_read_vols(spm_vol(flair)),...
								{'WeightedCentroid','Volume'});

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

	% count PV and lobar noc with and without
	% considering size
	% =======================================
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
end

lobar_noc_tbl = table (pvwmh_noc, ...
					   lfron_noc,...
					   rfron_noc,...
					   ltemp_noc,...
					   rtemp_noc,...
					   lpari_noc,...
					   rpari_noc,...
					   locci_noc,...
					   rocci_noc,...
					   lcere_noc,...
					   rcere_noc,...
					   brnstm_noc,...
					   unid_lob_noc,...
						    pvwmh_noc_p,...
						    lfron_noc_p,...
							rfron_noc_p,...
							ltemp_noc_p,...
							rtemp_noc_p,...
							lpari_noc_p,...
							rpari_noc_p,...
							locci_noc_p,...
							rocci_noc_p,...
							lcere_noc_p,...
							rcere_noc_p,...
							brnstm_noc_p,...
							unid_lob_noc_p,...
								pvwmh_noc_f,...
								lfron_noc_f,...
								rfron_noc_f,...
								ltemp_noc_f,...
								rtemp_noc_f,...
								lpari_noc_f,...
								rpari_noc_f,...
								locci_noc_f,...
								rocci_noc_f,...
								lcere_noc_f,...
								rcere_noc_f,...
								brnstm_noc_f,...
								unid_lob_noc_f,...
									pvwmh_noc_m,...
									lfron_noc_m,...
									rfron_noc_m,...
									ltemp_noc_m,...
									rtemp_noc_m,...
									lpari_noc_m,...
									rpari_noc_m,...
									locci_noc_m,...
									rocci_noc_m,...
									lcere_noc_m,...
									rcere_noc_m,...
									brnstm_noc_m,...
									unid_lob_noc_m,...
										pvwmh_noc_c,...
										lfron_noc_c,...
										rfron_noc_c,...
										ltemp_noc_c,...
										rtemp_noc_c,...
										lpari_noc_c,...
										rpari_noc_c,...
										locci_noc_c,...
										rocci_noc_c,...
										lcere_noc_c,...
										rcere_noc_c,...
										brnstm_noc_c,...
										unid_lob_noc_c);