% varargin{1} = subject's id in cns2

function noc_tbl = cns2_wmh_ud_postproc_quantification_noc (cns2param,wmhmask_dat,flair,varargin)

curr_cmd = mfilename;

if cns2param.exe.verbose && nargin==4
	fprintf ('%s : quantifying noc for %s.\n', curr_cmd, varargin{1});
end

thr = cns2param.quantification.ud.sizthr;

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26); % divide into 26-conn clusters

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								spm_read_vols(spm_vol(flair)),...
								{'WeightedCentroid','Volume'});

wbwmh_noc   = wmhclstrs_struct.NumObjects; % whole brain noc
wbwmh_noc_p = 0;
wbwmh_noc_f = 0;
wbwmh_noc_m = 0;
wbwmh_noc_c = 0;


% quantify whole brain noc of different sizes
% ===========================================
for i = 1:wbwmh_noc

	% coordinates
	% NOTE that the 1st and 2nd dimension need to
	%      be flipped after visual inspection, to
	%      correspond to the correct position on
	%      nifti images.
	x = round(wmhclstrs_props.WeightedCentroid(i,2));
	y = round(wmhclstrs_props.WeightedCentroid(i,1));
	z = round(wmhclstrs_props.WeightedCentroid(i,3));

	% size in num of voxels
	siz = wmhclstrs_props.Volume(i);

	if siz <= thr(1)
		wbwmh_noc_p = wbwmh_noc_p + 1;
  	elseif siz > thr(1) && siz <= thr(2)
  		wbwmh_noc_f = wbwmh_noc_f + 1;
	elseif siz > thr(2) && siz <= thr(3)
		wbwmh_noc_m = wbwmh_noc_m + 1;
	else
		wbwmh_noc_c = wbwmh_noc_c + 1;
	end

end

% quantify lobar noc
% ===================
lobar_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_lobar (cns2param,wmhclstrs_struct,flair);

% quantify arterial noc
% =====================
arterial_noc_tbl = cns2_wmh_ud_postproc_quantification_noc_arterial (cns2param,wmhclstrs_struct,flair);

% output table
% =============
noc_tbl =  [table(wbwmh_noc, wbwmh_noc_p, wbwmh_noc_f, wbwmh_noc_m, wbwmh_noc_c) ...
			lobar_noc_tbl ...
			arterial_noc_tbl];

