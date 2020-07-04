function noc_tbl = cns2_wmh_ud_postproc_quantification_noc (cns2param,wmhmask_dat,flair,i)

curr_cmd = mfilename;

if cns2param.exe.verbose
	fprintf ('%s : quantifying noc for %s.\n', curr_cmd, cns2param.lists.subjs{i,1});
end

thr = [3 9 15]; % cut-off in number of voxels between punctuate, focal, medium, and confluent

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26); % divide into 26-conn clusters

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								spm_read_vols(spm_vol(flair)),...
								{'WeightedCentroid','Volume'});

wbwmh_noc   = wmhclstrs_struct.NumObjects; % whole brain noc
wbwmh_noc_p = 0;
wbwmh_noc_f = 0;
wbwmh_noc_m = 0;
wbwmh_noc_c = 0;


for i = 1:wbwmh_noc
	
	% noc with/without considering size
	% =================================

	% coordinates
	x = wmhclstrs_props.WeightedCentroid(i,1);
	y = wmhclstrs_props.WeightedCentroid(i,2);
	z = wmhclstrs_props.WeightedCentroid(i,3);

	% size in num of voxels
	siz = wmhclstrs_props.Volume(i);

	% quantify whole brain noc of different sizes
	if siz <= thr(1)
		wbwmh_noc_p = wbwmh_noc_p + 1;
  	elseif siz > thr(1) && siz <= thr(2)
  		wbwmh_noc_f = wbwmh_noc_f + 1;
	elseif siz > thr(2) && siz <= thr(3)
		wbwmh_noc_m = wbwmh_noc_m + 1;
	else
		wbwmh_noc_c = wbwmh_noc_c + 1;
	end

	% quantify lobar noc
	lobar_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_lobar (cns2param,x,y,z,siz,thr);

	% quantify arterial noc
	arterial_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_arterial (cns2param,x,y,z,siz,thr);

end

noc_tbl =  [table(wbwmh_noc, wbwmh_noc_p, wbwmh_noc_f, wbwmh_noc_m, wbwmh_noc_c) ...
			lobar_noc_tbl ...
			arterial_noc_tbl];

