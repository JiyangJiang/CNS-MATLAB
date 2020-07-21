function [flowMapCellArr,cns2param] = cns2_wmh_ud_crtDartelTemp (cns2param)

curr_cmd = mfilename;

if cns2param.exe.verbose
    fprintf ('%s : Creating cohort-specific DARTEL template.\n', curr_cmd);
end

rcGMcellArr_col  = cell (cns2param.n_subjs,1);
rcWMcellArr_col  = cell (cns2param.n_subjs,1);
rcCSFcellArr_col = cell (cns2param.n_subjs,1);

cGMcellArr_col  = cell (cns2param.n_subjs,1);
cWMcellArr_col  = cell (cns2param.n_subjs,1);
cCSFcellArr_col = cell (cns2param.n_subjs,1);

% deal with parfor's 'unable to classify' issue
subjs_dir = cns2param.dirs.subjs;
subjid_arr = cns2param.lists.subjs;
crtTempFailSeg = cell (cns2param.n_subjs,1);

parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus)

	diary (fullfile (subjs_dir, subjid_arr{i,1}, 'ud', 'scripts', 'cns2_ud.log'))

	temp = [];
	temp.exe.verbose = true;
	% t1 = fullfile (cns2param.dirs.subjs, cns2param.lists.subjs{i,1}, 'ud', 'preproc', 't1.nii');
	% t1 = fullfile (temp.dirs.subjs, temp.lists.subjs{i,1}, 'ud', 'preproc', 't1.nii');
	t1 = fullfile (subjs_dir, subjid_arr{i,1}, 'ud', 'preproc', 't1.nii');

	try
		% t1 segmentation
		% ===============
		[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (temp, t1);

	catch ME

		fprintf (2,'\nException thrown\n');
		fprintf (2,'++++++++++++++++++++++\n');
		fprintf (2,'identifier: %s\n', ME.identifier);
		fprintf (2,'message: %s\n\n', ME.message);

		fprintf ('%s : %s'' T1 failed segmentation therefore was excluded from creating cohort-specific templates.\n\n', curr_cmd, subjid_arr{i,1});

		rcGMcellArr_col{i,1}  = 'N/A';
		rcWMcellArr_col{i,1}  = 'N/A';
		rcCSFcellArr_col{i,1} = 'N/A';

		cGMcellArr_col{i,1}  = 'N/A';
		cWMcellArr_col{i,1}  = 'N/A';
		cCSFcellArr_col{i,1} = 'N/A';

		crtTempFailSeg{i,1} = subjid_arr{i,1};

		continue;
	end
	
	rcGMcellArr_col{i,1}  = rcGM;
	rcWMcellArr_col{i,1}  = rcWM;
	rcCSFcellArr_col{i,1} = rcCSF;

	cGMcellArr_col{i,1}  = cGM;
	cWMcellArr_col{i,1}  = cWM;
	cCSFcellArr_col{i,1} = cCSF;

	diary off

end

% eliminate elements with empty. the rest is IDs failed seg. assign to 
% cns2param.lists.crtTempFailSeg
cns2param.lists.crtTempFailSeg = crtTempFailSeg(find(~cellfun(@isempty,crtTempFailSeg)));

% deal with situations where there are segmentation failures
rcGMcellArr_col_noFail  = rcGMcellArr_col  (~strcmp(rcGMcellArr_col, 'N/A'));
rcWMcellArr_col_noFail  = rcWMcellArr_col  (~strcmp(rcWMcellArr_col, 'N/A'));
rcCSFcellArr_col_noFail = rcCSFcellArr_col (~strcmp(rcCSFcellArr_col,'N/A'));
cGMcellArr_col_noFail   = cGMcellArr_col   (~strcmp(cGMcellArr_col,  'N/A'));
cWMcellArr_col_noFail   = cWMcellArr_col   (~strcmp(cWMcellArr_col,  'N/A'));
cCSFcellArr_col_noFail  = cCSFcellArr_col  (~strcmp(cCSFcellArr_col, 'N/A'));

[flowMapCellArr,...
          temp0,...
          temp1,...
          temp2,...
          temp3,...
          temp4,...
          temp5,...
          temp6]    = cns2_spmbatch_runDARTELc (cns2param, ...
                                                size(rcGMcellArr_col_noFail,1), ...
                                                rcGMcellArr_col_noFail, ...
                                                rcWMcellArr_col_noFail, ...
                                                rcCSFcellArr_col_noFail);

coh_temp_dir = fullfile(cns2param.dirs.subjs,'coh_temp');

if ~ isfolder (coh_temp_dir)
	mkdir (cns2param.dirs.subjs,'coh_temp');
end
movefile (temp0,fullfile(coh_temp_dir,'Template_0.nii'));
movefile (temp1,fullfile(coh_temp_dir,'Template_1.nii'));
movefile (temp2,fullfile(coh_temp_dir,'Template_2.nii'));
movefile (temp3,fullfile(coh_temp_dir,'Template_3.nii'));
movefile (temp4,fullfile(coh_temp_dir,'Template_4.nii'));
movefile (temp5,fullfile(coh_temp_dir,'Template_5.nii'));
movefile (temp6,fullfile(coh_temp_dir,'Template_6.nii'));

cns2param.templates.temp1_6{1,1} = fullfile(coh_temp_dir,'Template_1.nii');
cns2param.templates.temp1_6{2,1} = fullfile(coh_temp_dir,'Template_2.nii');
cns2param.templates.temp1_6{3,1} = fullfile(coh_temp_dir,'Template_3.nii');
cns2param.templates.temp1_6{4,1} = fullfile(coh_temp_dir,'Template_4.nii');
cns2param.templates.temp1_6{5,1} = fullfile(coh_temp_dir,'Template_5.nii');
cns2param.templates.temp1_6{6,1} = fullfile(coh_temp_dir,'Template_6.nii');

% generate cohort-specific prob maps
wcGMcellArr  = cell (size(cGMcellArr_col_noFail));
wcWMcellArr  = cell (size(cWMcellArr_col_noFail));
wcCSFcellArr = cell (size(cCSFcellArr_col_noFail));

parfor (i = 1 : size(cGMcellArr_col_noFail,1), cns2param.exe.n_cpus)
	temp = [];
	temp.exe.verbose = true;
	wcGMcellArr{i,1}  = cns2_spmbatch_nativeToDARTEL (temp, cGMcellArr_col_noFail{i,1},  flowMapCellArr{i,1});
	wcWMcellArr{i,1}  = cns2_spmbatch_nativeToDARTEL (temp, cWMcellArr_col_noFail{i,1},  flowMapCellArr{i,1});
	wcCSFcellArr{i,1} = cns2_spmbatch_nativeToDARTEL (temp, cCSFcellArr_col_noFail{i,1}, flowMapCellArr{i,1});
end

GMavg  = cns2_spmbatch_imgCal   (cns2param, ...
								 'avg', ...
                                 coh_temp_dir, ...
                                 'coh_GMprob', ...
                                 size(wcGMcellArr,1), ...
                                 wcGMcellArr);
WMavg  = cns2_spmbatch_imgCal   (cns2param, ...
								 'avg', ...
                                 coh_temp_dir, ...
                                 'coh_WMprob', ...
                                 size(wcWMcellArr,1), ...
                                 wcWMcellArr);
CSFavg = cns2_spmbatch_imgCal   (cns2param, ...
								 'avg', ...
                                 coh_temp_dir, ...
                                 'coh_CSFprob', ...
                                 size(wcCSFcellArr,1), ...
                                 wcCSFcellArr);

cns2param.templates.gmprob  = GMavg;
cns2param.templates.wmprob  = WMavg;
cns2param.templates.csfprob = CSFavg;
