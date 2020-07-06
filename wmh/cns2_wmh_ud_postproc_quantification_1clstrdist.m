% distance between each pair of clusters
% varargin{1} = subject's id in cns2

function dist_tbl = cns2_wmh_ud_postproc_quantification_clstrDist (cns2param,wmhmask_dat,flair,varargin)

curr_cmd = mfilename;

if cns2param.exe.verbose && nargin==4
	fprintf ('%s : quantifying distance between WMH clusters for %s.\n', curr_cmd, varargin{1});
end

wmhclstrs_struct = bwconncomp (wmhmask_dat, 26); % divide into 26-conn clusters

wmhclstrs_props = regionprops3 (wmhclstrs_struct,...
								spm_read_vols(spm_vol(flair)),...
								'WeightedCentroid');

if wmhclstrs_struct.NumObjects <= 1
	dist_tbl = table (NaN, NaN, NaN);
elseif wmhclstrs_struct.NumObjects == 2
	clstr_dist = pdist (wmhclstrs_props.WeightedCentroid, 'euclidean');
	dist_tbl = table(mean(clstr_dist), NaN, NaN);
else
	clstr_dist = pdist (wmhclstrs_props.WeightedCentroid, 'euclidean');
	dist_tbl = table (mean(clstr_dist), std(clstr_dist), var(clstr_dist));
end

dist_tbl.Properties.VariableNames = {'avg_clstr_dist'
									 'std_clstr_dist'
									 'var_clstr_dist'};