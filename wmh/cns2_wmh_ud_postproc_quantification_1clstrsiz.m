% varargin{1} = subject's id in cns2
function clstrSiz_tbl = cns2_wmh_ud_postproc_quantification_clstrSiz (cns2param,wmhmask_dat,varargin)

curr_cmd = mfilename;

if cns2param.exe.verbose && nargin==3
	fprintf ('%s : quantifying variance in WMH cluster sizes for %s.\n', curr_cmd, varargin{1});
end

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26); % divide into 26-conn clusters

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								'Volume');

clstrSiz_tbl = table (mean(wmhclstrs_props.Volume),...
					  std (wmhclstrs_props.Volume),...
					  var (wmhclstrs_props.Volume));

clstrSiz_tbl.Properties.VariableNames = {'avg_clstrSiz'
										 'std_clstrSiz'
										 'var_clstrSiz'};
