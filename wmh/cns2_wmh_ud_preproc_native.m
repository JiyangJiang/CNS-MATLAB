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

function cns2param = cns2_wmh_ud_preproc_native (flag,varargin)

curr_cmd = mfilename;

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

	% templates used in classification back to native space
	gmmsk_t1spc   = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.gmmsk,   flowmap      );
	wmmsk_t1spc   = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.wmmsk,   flowmap      );
	gmprob_t1spc  = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.gmprob,  flowmap      );
	wmprob_t1spc  = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.wmprob,  flowmap      );
	csfprob_t1spc = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.csfprob, flowmap      );
	brnmsk_t1spc  = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.brnmsk,  flowmap, 'NN');

	gmmsk_flairSpc   = cns2_scripts_revReg (cns2param, flair, t1, gmmsk_t1spc,   'Tri');
	wmmsk_flairSpc   = cns2_scripts_revReg (cns2param, flair, t1, wmmsk_t1spc,   'Tri');
	gmprob_flairSpc  = cns2_scripts_revReg (cns2param, flair, t1, gmprob_t1spc,  'Tri');
	wmprob_flairSpc  = cns2_scripts_revReg (cns2param, flair, t1, wmprob_t1spc,  'Tri');
	csfprob_flairSpc = cns2_scripts_revReg (cns2param, flair, t1, csfprob_t1spc, 'Tri');
	brnmsk_flairSpc  = cns2_scripts_revReg (cns2param, flair, t1, brnmsk_t1spc        );

	% mask native flair and t1
	cns2_scripts_mask  (cns2param, flair, brnmsk_flairSpc, ...
						fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'flair_brn.nii'));
	cns2_scripts_mask  (cns2param, t1, brnmsk_t1spc, ...
						fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 't1_brn.nii'));

	% rename to be more self-explanatory
	movefile (gmmsk_t1spc,     fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'gmmsk_t1spc.nii'     ));
	movefile (wmmsk_t1spc,     fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wmmsk_t1spc.nii'     ));
	movefile (gmprob_t1spc,    fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'gmprob_t1spc.nii'    ));
	movefile (wmprob_t1spc,    fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wmprob_t1spc.nii'    ));
	movefile (csfprob_t1spc,   fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'csfprob_t1spc.nii'   ));
	movefile (brnmsk_t1spc,    fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'brnmsk_t1spc.nii'    ));
	movefile (gmmsk_flairSpc,  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'gmmsk_flairSpc.nii'  ));
	movefile (wmmsk_flairSpc,  fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wmmsk_flairSpc.nii'  ));
	movefile (gmprob_flairSpc, fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'gmprob_flairSpc.nii' ));
	movefile (wmprob_flairSpc, fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wmprob_flairSpc.nii' ));
	movefile (csfprob_flairSpc,fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'csfprob_flairSpc.nii'));
	movefile (brnmsk_flairSpc, fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'brnmsk_flairSpc.nii' ));

	% update cns2param
	cns2param.templates.gmmsk   = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'gmmsk_flairSpc.nii'  );
	cns2param.templates.wmmsk   = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wmmsk_flairSpc.nii'  );
	cns2param.templates.gmprob  = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'gmprob_flairSpc.nii' );
	cns2param.templates.wmprob  = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'wmprob_flairSpc.nii' );
	cns2param.templates.csfprob = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'csfprob_flairSpc.nii');
	cns2param.templates.brnmsk  = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'brnmsk_flairSpc.nii' );

	

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


% Templates for quantification to native space
ventdst_t1spc  = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.ventdst,  flowmap      );
lobar_t1spc    = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.lobar,    flowmap, 'NN');
arterial_t1spc = cns2_spmbatch_DARTELtoNative (cns2param, cns2param.templates.arterial, flowmap, 'NN');

ventdst_flairSpc  = cns2_scripts_revReg (cns2param, flair, t1, ventdst_t1spc,   'Tri');
lobar_flairSpc    = cns2_scripts_revReg (cns2param, flair, t1, lobar_t1spc           );
arterial_flairSpc = cns2_scripts_revReg (cns2param, flair, t1, arterial_t1spc        );

% rename to be more self-explanatory
movefile (ventdst_t1spc,    fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'ventdst_t1spc.nii'    ));
movefile (lobar_t1spc,      fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'lobar_t1spc.nii'      ));
movefile (arterial_t1spc,   fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'arterial_t1spc.nii'   ));
movefile (ventdst_flairSpc, fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'ventdst_flairSpc.nii' ));
movefile (lobar_flairSpc,   fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'lobar_flairSpc.nii'   ));
movefile (arterial_flairSpc,fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'arterial_flairSpc.nii'));

% update cns2param
cns2param.templates.ventdst  = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'ventdst_flairSpc.nii' );
cns2param.templates.lobar    = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'lobar_flairSpc.nii'   );
cns2param.templates.arterial = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 'arterial_flairSpc.nii');