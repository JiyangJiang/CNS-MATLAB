% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;9196f5f5.1006

% other = ref space image that will be mapped to src space by reversing src-to-ref transformation.

% varargin{1} = 'Tri' for trilinear interpolation. Default is nearest neighbour.


function varargout = cns2_scripts_revReg (cns2param, src, ref, other, varargin)

	[src_dir,   src_filename,   src_ext  ] = fileparts (src);
	[ref_dir,   ref_filename,   ref_ext  ] = fileparts (ref);
	[other_dir, other_filename, other_ext] = fileparts (other);

	if cns2param.exe.verbose
        curr_cmd = mfilename;
        fprintf ('%s : transforming %s to %s''s space by reversing %s-to-%s transformation.\n', ...
        			curr_cmd, other_filename, src_filename, src_filename, ref_filename);
    end

	src_vol = spm_vol (src);
	ref_vol = spm_vol (ref);
    other_vol = spm_vol (other);

    coregFlags = struct ('graphics', 'False');
    
	rot_par_src2ref = spm_coreg (ref_vol, src_vol, coregFlags);
    
	trans_mx_src2ref = spm_matrix (rot_par_src2ref);

    % equivalent to reorient
	% spm_get_space (src, trans_mx_src2ref * src_vol.mat);
	spm_get_space (other, trans_mx_src2ref * spm_get_space (other)); % Ref: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;f71e11b9.0710
																	 % spm_coreg returns a transformation from
																	 % reference to source, which is then inverted in spm_config_coreg
																	 % therefore, reverse transformation is inv(inv(Mx)), which equals Mx

    if nargin == 5 && strcmp (varargin{1}, 'Tri')
        interp = 1;
    elseif nargin == 4
        interp = 0; % nearest neighbour (default)
    end
    
	resliceFlags= struct('interp',interp,... % Nearest Neighbour
					'mask',1,...
					'mean',0,...
					'which',1,...
					'wrap',[0 0 0]);
	

	files = {src;other};

	spm_reslice(files, resliceFlags);

	varargout{1} = fullfile(other_dir, ['r' other_filename other_ext]);