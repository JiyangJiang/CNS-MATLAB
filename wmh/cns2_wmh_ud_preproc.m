% varargin{1} = cell array of flow maps. 'creating templates' will generate
%				flow maps in addition to Template 0-6.

function cns2_wmh_ud_preproc (cns2param,i,varargin)

curr_cmd = mfilename;

fprintf ('%s : start preprocessing %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

if nargin==3 && strcmp(cns2param.templates.options{1},'creating')
	flowmaps = varargin{1}; % creating templates will also generate flowmaps
							% which are passed as a cell array in the 3rd
							% argument.
end

t1    = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 't1.nii');
flair = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'flair.nii');

% coregistration
% ==============
if cns2param.classification.ud.ext_space == 'dartel'
	rflair = cns2_spmbatch_coregistration (cns2param, flair, t1, 'same_dir');
end

switch cns2param.templates.options{1}

    case 'existing'

    	% t1 segmentation
    	% ===============
		[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (cns2param, t1);

		% run DARTEL
		% ==========
		flowmap = cns2_spmbatch_runDARTELe (cns2param, ...
											rcGM, rcWM, rcCSF, ...
											cns2param.templates.temp1_6{1,1}, ...
											cns2param.templates.temp1_6{2,1}, ...
											cns2param.templates.temp1_6{3,1}, ...
											cns2param.templates.temp1_6{4,1}, ...
											cns2param.templates.temp1_6{5,1}, ...
											cns2param.templates.temp1_6{6,1});
	case 'creating'
		flowmap = flowmaps{i};
end


switch cns2param.classification.ud.ext_space
case 'dartel'
	% bring t1, flair, gm, wm, csf to DARTEL space (create warped)
	% ============================================================
	wt1     = cns2_spmbatch_nativeToDARTEL (cns2param, t1,     flowmap);
	wrflair = cns2_spmbatch_nativeToDARTEL (cns2param, rflair, flowmap);
	wcGM    = cns2_spmbatch_nativeToDARTEL (cns2param, cGM,    flowmap);
	wcWM    = cns2_spmbatch_nativeToDARTEL (cns2param, cWM,    flowmap);
	wcCSF   = cns2_spmbatch_nativeToDARTEL (cns2param, cCSF,   flowmap);

	% mask wrflair and wt1
	% ====================
	cns2_scripts_mask  (cns2param, ...
						wt1, ...
						cns2param.templates.brnmsk, ...
						fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wt1_brn.nii'));
	cns2_scripts_mask  (cns2param, ...
						wrflair, ...
						cns2param.templates.brnmsk, ...
						fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wrflair_brn.nii'));
case 'native'
	% preprocessing if extracting in native space
	% - reverse flowmap
	% - reverse templates to native (cns2_spmbatch_DARTELtoNative + cns2_spmbatch_revReg.m)
	% - reverse brain mask to native (cns2_spmbatch_DARTELtoNative + cns2_spmbatch_revReg.m)
	% - mask native flair and t1
end
