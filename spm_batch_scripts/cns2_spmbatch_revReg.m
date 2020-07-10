% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;9196f5f5.1006

% other = ref space src, or ref space XXX that want to map back to src

% varargin{1} = 'Tri' for trilinear interpolation
% varargout{1} = other in src space

% will need add SPM to path

function varargout = cns2_spmbatch_revReg (cns2param, src, ref, other, varargin)

	[src_dir, src_filename, src_ext]       = fileparts (src);
	[ref_dir, ref_filename, ref_ext]       = fileparts (ref);
	[other_dir, other_filename, other_ext] = fileparts (other);

	if cns2param.exe.verbose
        curr_cmd = mfilename;
        fprintf ('%s : bring %s to %s''s space by reversing reg from %s to %s.\n',  curr_cmd, ...
        																			[other_filename other_ext], ...
        																			[src_filename src_ext], ...
        																			[src_filename src_ext], ...
        																			[ref_filename ref_ext]);
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

	% other_space = spm_get_space (other);
	% spm_get_space (other, trans_mx_src2ref \ other_space); % a\b is equivalent to inv(a)*b
    
    
%     CNSP_reorientImg (ref, inv(trans_mx_src2ref), '');
%     CNSP_reorientImg (other, inv(trans_mx_src2ref), '');

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
    
%     [srcPath, srcFilename, srcExt] = fileparts (src);
%     [otherPath, otherFilename, otherExt] = fileparts (other);
%     files = {ref;
%             [srcPath '/ro_' srcFilename srcExt];
%             [otherPath '/ro_' otherFilename otherExt]};
% 
	spm_reslice(files, resliceFlags);

	varargout{1} = fullfile(other_dir, ['r' other_filename other_ext]);
