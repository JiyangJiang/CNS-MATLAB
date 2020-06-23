function cns2_scripts_writeNii (hdr, dat, out)
	
	if cns2param.exe.verbose
		curr_cmd = mfilename;
		[~,fname,ext] = fileparts (out);
		fprintf ('%s : writing nifti %s.\n', curr_cmd, [fname ext]);
	end

	hdr.fname = out;
	hdr.private.dat.fname = out;
	spm_write_vol (hdr,dat);