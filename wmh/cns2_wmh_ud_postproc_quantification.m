
% SENARIO 1
%
% 	Standard call for CNS2 UBO Detector. In this case, 4 arguments are required:
% 	a) 'wmhmask_dat' through calling spm_read_vols and spm_vol, b) path to 'flair',
% 	c) varargin{1} = cns2param, and d) varargin{2} = index used in cns2. The script 
% 	will quantify measures for the index in defined in cns2param.
%
%
% SENARIO 2
%
% 	WMH masks are extracted by other software, e.g. BIANCA, and this script is called
% 	only for extracting global WMH measures, including whole brain WMH volumes, total
% 	number of WMH clusters, average WMH cluster distance, and variance in size between
% 	WMH clusters. In this case, only 'wmhmask_dat' through calling spm_read_vols and
% 	spm_vol, and path to 'flair' are required as arguments.
%
%
% SENARIO 3
%
% 	WMH masks are extracted by other software, e.g. BIANCA, and this scripts is called
% 	to extract the full array of measures as standard UBO Detector. In this case,
%   ---=== TBC ===---
% 	
%
% flair is used for 2 purposes: 1) calculate voxel size (spatial resolution)
%                               2) find weighted centroid


function quant_tbl_subj = cns2_wmh_ud_postproc_quantification (wmhmask_dat,flair,varargin)

curr_cmd=mfilename;


% ++++++++++++++++++++++++
% standard call in CNS2 UD
% ++++++++++++++++++++++++
if nargin==4

	cns2param = varargin{1};
	idx       = varargin{2};

	subjid = cns2param.lists.subjs{idx,1};
	fprintf ('%s : start quantification for %s.\n', curr_cmd, subjid);

	% quantify volume
	vol_tbl = cns2_wmh_ud_postproc_quantification_vol (wmhmask_dat,flair,cns2param,subjid);

	% quantify number of clusters
	noc_tbl = cns2_wmh_ud_postproc_quantification_noc (wmhmask_dat,flair,cns2param,subjid);

	% quantify distance
	dist_tbl = cns2_wmh_ud_postproc_quantification_clstrDist (wmhmask_dat,flair,cns2param,subjid);

	% quantify cluster size distribution
	clstrSiz_tbl = cns2_wmh_ud_postproc_quantification_clstrSiz (wmhmask_dat,cns2param,subjid);

	% combine measures into one table
	quant_tbl_subj = [table({subjid}) ...
					  vol_tbl ...
					  noc_tbl ...
					  dist_tbl ...
					  clstrSiz_tbl];

	quant_tbl_subj.Properties.VariableNames{'Var1'} = 'subjID';


% +++++++++++++++++++++++++++++++++++++++++++++++++++++
% only global measures on wmh segmented by any software
% +++++++++++++++++++++++++++++++++++++++++++++++++++++
elseif nargin==2
	
	fprintf ('%s : start quantification.\n', curr_cmd);

	% quantify volume
	vol_tbl = cns2_wmh_ud_postproc_quantification_vol (wmhmask_dat,flair);

	% quantify number of clusters
	noc_tbl = cns2_wmh_ud_postproc_quantification_noc (wmhmask_dat,flair);

	% quantify distance
	dist_tbl = cns2_wmh_ud_postproc_quantification_clstrDist (wmhmask_dat,flair);

	% quantify cluster size distribution
	clstrSiz_tbl = cns2_wmh_ud_postproc_quantification_clstrSiz (wmhmask_dat);

	% combine measures into one table
	quant_tbl_subj = [vol_tbl ...
				 	  noc_tbl ...
				 	  dist_tbl ...
				 	  clstrSiz_tbl];

% ++++++++++++++++++++++++++++++++++++++++++++++++++
% both global and regional measures on wmh segmented
% by any software
% ++++++++++++++++++++++++++++++++++++++++++++++++++
elseif nargin==3 && strcmp(varargin{1},'allMeas')
	% run preproc
	% reverse flowmap
	% bring templates/atlas to native
	% set cns2param
end

