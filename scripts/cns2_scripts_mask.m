% DESCRIPTION:
% 	mask with voxels with intensity larger than 0
%
% USAGE:
% 	in = path to in nii
% 	mask = path to mask nii
% 	out = path to out nii

function cns2_spmscripts_mask (in, mask, out)

curr_cmd = mfilename;
fprintf ('%s : masking %s with %s, and outputing as %s\n', curr_cmd, in, mask, out);

in_dat   = spm_read_vols (spm_vol (in));
mask_dat = spm_read_vols (spm_vol (mask));

out_dat = in_dat;
out_dat (mask_dat <= 0) = 0;

out_hdr = spm_vol (in);
out_hdr.fname = out;
out_hdr.private.dat.fname = out;

spm_write_vol (out_hdr, out_dat);