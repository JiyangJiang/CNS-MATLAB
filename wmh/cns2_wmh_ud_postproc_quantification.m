% varargin{1} = index used in cns2
%
% flair is used for 2 purposes: 1) calculate voxel size (spatial resolution)
%                               2) find weighted centroid
function quant_tbl_subj = cns2_wmh_ud_postproc_quantification (cns2param,wmhmask_dat,flair,varargin)

curr_cmd=mfilename;

if nargin==4

	subjid = cns2param.lists.subjs{varargin{1},1};
	fprintf ('%s : start quantification for %s.\n', curr_cmd, subjid);

	% quantify volume
	vol_tbl = cns2_wmh_ud_postproc_quantification_vol (cns2param,wmhmask_dat,flair,subjid);

	% quantify number of clusters
	noc_tbl = cns2_wmh_ud_postproc_quantification_noc (cns2param,wmhmask_dat,flair,subjid);

	% quantify distance
	dist_tbl = cns2_wmh_ud_postproc_quantification_clstrDist (cns2param,wmhmask_dat,flair,subjid);

	% quantify cluster size distribution
	clstrSiz_tbl = cns2_wmh_ud_postproc_quantification_clstrSiz (cns2param,wmhmask_dat,subjid);

	% combine measures into one table
	quant_tbl_subj = [table({subjid}) ...
					  vol_tbl ...
					  noc_tbl ...
					  dist_tbl ...
					  clstrSiz_tbl];

	quant_tbl_subj.Properties.VariableNames{'Var1'} = 'subjID';

elseif nargin==3
	
	fprintf ('%s : start quantification.', curr_cmd);

	% quantify volume
	vol_tbl = cns2_wmh_ud_postproc_quantification_vol (cns2param,wmhmask_dat,flair);

	% quantify number of clusters
	noc_tbl = cns2_wmh_ud_postproc_quantification_noc (cns2param,wmhmask_dat,flair);

	% quantify distance
	dist_tbl = cns2_wmh_ud_postproc_quantification_clstrDist (cns2param,wmhmask_dat,flair);

	% quantify cluster size distribution
	clstrSiz_tbl = cns2_wmh_ud_postproc_quantification_clstrSiz (cns2param,wmhmask_dat);

	% combine measures into one table
	quant_tbl_subj = [vol_tbl ...
				 	  noc_tbl ...
				 	  dist_tbl ...
				 	  clstrSiz_tbl];
end

