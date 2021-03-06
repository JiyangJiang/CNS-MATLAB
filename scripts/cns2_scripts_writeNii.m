% varargin{1} = '4d'
function cns2_scripts_writeNii (cns2param, vol, dat, out, varargin)
	
	curr_cmd = mfilename;
		
	[outdir,fname,ext] = fileparts (out);

	if cns2param.exe.verbose
		fprintf ('%s : writing nifti %s.\n', curr_cmd, [fname ext]);
	end

	% write 4D nii
	if nargin == 5 && strcmp (varargin{1},'4d')
		if cns2param.exe.verbose
			curr_cmd = mfilename;
			fprintf ('%s : ... %s is 4D.\n', curr_cmd, [fname ext]);
		end
		for i = 1:size (dat,4)
			split_vols{i,1} = fullfile (outdir, [fname '_' num2str(i) ext]);
			writeNii (vol, dat(:,:,:,i), split_vols{i,1});
		end
		spm_file_merge (split_vols,out);
	% write 3D nii
	elseif nargin == 4
		writeNii (vol, dat, out);
	end

end


function writeNii (vol, dat, out)
	vol.fname = out;
	vol.private.dat.fname = out;
	spm_write_vol (vol,dat);
end