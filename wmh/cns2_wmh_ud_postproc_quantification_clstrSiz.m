% varargin{1} = cns2param
% varargin{2} = subject's id in cns2
function clstrSiz_tbl = cns2_wmh_ud_postproc_quantification_clstrSiz (wmhmask_dat,flair,varargin)

if nargin==4
	cns2param = varargin{1};
	if cns2param.exe.verbose
		curr_cmd = mfilename;
		fprintf ('%s : quantifying variance in WMH cluster sizes for %s.\n', curr_cmd, varargin{2});
	end
end

% get voxel's spatial resolution
nii_info = niftiinfo(flair);
sptRes_x = nii_info.PixelDimensions(1);
sptRes_y = nii_info.PixelDimensions(2);
sptRes_z = nii_info.PixelDimensions(3);
sptRes = sptRes_x * sptRes_y * sptRes_z;

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26); % divide into 26-conn clusters

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								'Volume');

clstrSiz_tbl = table (mean(wmhclstrs_props.Volume * sptRes),...
					  std (wmhclstrs_props.Volume * sptRes),...
					  var (wmhclstrs_props.Volume * sptRes));

clstrSiz_tbl.Properties.VariableNames = {'avg_clstrSiz'
										 'std_clstrSiz'
										 'var_clstrSiz'};
