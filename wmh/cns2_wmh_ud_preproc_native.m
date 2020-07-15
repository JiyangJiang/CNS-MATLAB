% varargin{1} = cell array of flow maps. 'creating templates' will generate
%				flow maps in addition to Template 0-6.

% switch flag
% 	case 'cns2_ud'
% 		standard CNS2 UBO Detector call
% 		(cns2param,i) as input if using 'existing' templates
% 		(cns2param,i,flowmaps) as input if using 'creating' templates
% 	case 'general'
% 		wmh extracted from other software but full array of measures
% 		are required. Therefore, preproc is needed to bring all templates
% 		and atlases to native space. (t1,flair) as input in this case.
% end

function cns2_wmh_ud_preproc_native (flag,varargin)

curr_cmd = mfilename;

fprintf ('%s : start preprocessing %s.\n', curr_cmd, cns2param.lists.subjs{i,1});


switch flag

case 'cns2_ud'
	cns2param = varargin{1};
	        i = varargin{2};
	
	t1    = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 't1.nii');
	flair = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'flair.nii');

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

	case 'creating' && nargin==4 && strcmp(cns2param.templates.options{1},'creating')
		flowmaps = varargin{3}; % creating templates will also generate flowmaps
								% which are passed as a cell array in the 3rd
								% argument.
		flowmap = flowmaps{i};
	end

case 'general'
	cns2_templates06_dir = fullfile(fileparts(fileparts(mfilename)),'templates','DARTEL_0to6_templates','65to75');
	t1    = varargin{1};
	flair = varargin{2};
	cns2param.exe.verbose = true;

	% t1 segmentation
	% ===============
	[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (cns2param, t1);
	% run DARTEL
	% ==========
	flowmap = cns2_spmbatch_runDARTELe (cns2param, ...
										rcGM, rcWM, rcCSF, ...
										fullfile(cns2_templates06_dir,'Template_1.nii'), ...
										fullfile(cns2_templates06_dir,'Template_2.nii'), ...
										fullfile(cns2_templates06_dir,'Template_3.nii'), ...
										fullfile(cns2_templates06_dir,'Template_4.nii'), ...
										fullfile(cns2_templates06_dir,'Template_5.nii'), ...
										fullfile(cns2_templates06_dir,'Template_6.nii'));
end


% what to bring bach to native ??
% call NativeImg = cns2_spmbatch_DARTELtoNative (DARTELimg, flowMap);
% - reverse templates to native (cns2_spmbatch_DARTELtoNative + cns2_spmbatch_revReg.m)
% - reverse brain mask to native (cns2_spmbatch_DARTELtoNative + cns2_spmbatch_revReg.m)
% - mask native flair and t1

