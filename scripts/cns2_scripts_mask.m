% DESCRIPTION:
% 	mask with voxels with intensity larger than 0
%
% USAGE:
% 	in = path to in nii
% 	mask = path to mask nii
% 	out = path to out nii

function cns2_spmscripts_mask (cns2param, in, mask, out)

curr_cmd = mfilename;

if cns2param.exe.verbose
	fprintf ('%s : masking %s with %s, and outputing as %s\n', curr_cmd, in, mask, out);
end

in_dat   = spm_read_vols (spm_vol (in));
mask_dat = spm_read_vols (spm_vol (mask));

% whether in and mask are of same dimension
if ~(size(in_dat,1)==size(mask_dat,1) && ...
	 size(in_dat,2)==size(mask_dat,2) && ...
	 size(in_dat,3)==size(mask_dat,3))
	error ('%s and %s are not of the same dimension.\n', in, mask);
end

out_dat = in_dat;
out_dat (mask_dat <= 0) = 0;

cns2_scripts_writeNii (cns2param, spm_vol(in), out_dat, out);
