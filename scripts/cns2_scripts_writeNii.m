% varargin{1} = '4d'
function cns2_scripts_writeNii (cns2param, hdr, dat, out, varargin)

	cns2param = cns2_wmh_ud_setParam;

	[outdir,fname,ext] = fileparts (out);

	if cns2param.exe.verbose
		curr_cmd = mfilename;
		fprintf ('%s : writing nifti %s.\n', curr_cmd, [fname ext]);
	end

	% write 4D nii
	if nargin == 5 && strcmp (varargin{1},'4d')
		for i = 1:size (dat,4)
			if cns2param.exe.verbose
				curr_cmd = mfilename;
				fprintf ('%s : ... %s is 4D.\n', curr_cmd, [fname ext]);
			end
			split_vols{i,1} = fullfile (outdir, [fname '_' i ext]);
			writeNii (hdr, dat(:,:,:,i), split_vols{i,1});
		end
		spm_file_merge (split_vols,out);
	% write 3D nii
	elseif nargin == 4
		writeNii (hdr, dat, out);
	end

end


function writeNii (hdr, dat, out)
	hdr.fname = out;
	hdr.private.dat.fname = out;
	spm_write_vol (hdr,dat);
end