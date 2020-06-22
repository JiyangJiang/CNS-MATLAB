function cns2_scripts_writeNii (hdr, dat, out)
	hdr.fname = out;
	hdr.private.dat.fname = out;
	spm_write_vol (hdr,dat);

	curr_cmd = mfilename;
	[~,fname,ext] = fileparts (out);
	fprintf ('%s : nifti %s is written.\n', curr_cmd, [fname ext]);