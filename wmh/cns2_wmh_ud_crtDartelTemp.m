function [flowMapCellArr,cns2param] = cns2_wmh_ud_crtDartelTemp (cns2param)

	% T1 segmentation
	% creating templates
	% updates cns2param (templates 0-6)
	% output flowmaps

if cns2param.exe.verbose
    curr_cmd = mfilename;
    fprintf ('%s : Creating cohort-specific DARTEL template.\n', curr_cmd);
end

rcGMcellArr_col  = cell (cns2param.n_subjs,1);
rcWMcellArr_col  = cell (cns2param.n_subjs,1);
rcCSFcellArr_col = cell (cns2param.n_subjs,1);

parfor (i = 1 : cns2param.n_subjs, cns2param.exe.n_cpus);
	
	t1 = fullfile (cns2param.dirs.subjs, cns2param.lists.t1{i,1});

	% t1 segmentation
	% ===============
	[cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = cns2_spmbatch_segmentation (cns2param, t1);
	
	rcGMcellArr_col{i,1}  = rcGM;
	rcWMcellArr_col{i,1}  = rcWM;
	rcCSFcellArr_col{i,1} = rcCSF;

end

[flowMapCellArr,...
          temp0,...
          temp1,...
          temp2,...
          temp3,...
          temp4,...
          temp5,...
          temp6]    = cns2_spmbatch_runDARTELc (cns2param, ...
                                                cns2param.n_subjs, ...
                                                rcGMcellArr_col, ...
                                                rcWMcellArr_col, ...
                                                rcCSFcellArr_col);

coh_temp_dir = fullfile(cns2param.dirs.subjs,'coh_temp');

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
% see below copied from WMHextraction_preprocessing_Step4.m

% if strcmp (dartelTemplate,'creating template')

%             % create studyFolder/subjects/cohort_probability_maps
%             if exist([studyFolder '/subjects/cohort_probability_maps'],'dir') == 7
%                 rmdir ([studyFolder '/subjects/cohort_probability_maps'],'s');
%             end
%             mkdir ([studyFolder '/subjects'], 'cohort_probability_maps');


%             % average wcGM/wcWM/wcCSF
%             wcGMarr = cell (Nsubj,1);
%             wcWMarr = cell (Nsubj,1);
%             wcCSFarr = cell (Nsubj,1);

%             for j = 1:Nsubj
%                 T1imgNames = strsplit (T1folder(j).name, '_');   % split T1 image name, delimiter is underscore
%                 ID = T1imgNames{1};   % first section is ID
                
%                 wcGMarr{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wc1' T1folder(j).name];
%                 wcWMarr{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wc2' T1folder(j).name];
%                 wcCSFarr{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wc3' T1folder(j).name];
%             end

%             outputDir = [studyFolder '/subjects/cohort_probability_maps'];

%             GMavg = CNSP_imgCal ('avg', ...
%                                 outputDir, ...
%                                 'cohort_GM_probability_map', ...
%                                 Nsubj, ...
%                                 wcGMarr...
%                                 );
%             WMavg = CNSP_imgCal ('avg', ...
%                                 outputDir, ...
%                                 'cohort_WM_probability_map', ...
%                                 Nsubj, ...
%                                 wcWMarr...
%                                 );
%             CSFavg = CNSP_imgCal ('avg', ...
%                                 outputDir, ...
%                                 'cohort_CSF_probability_map', ...
%                                 Nsubj, ...
%                                 wcCSFarr...
%                                 );




%             % 10/02/2020 : nan issue
%             % ----------------------
%             system (['fslmaths ' outputDir '/cohort_GM_probability_map.nii ' ...
%                                 '-nan ' ...
%                                 outputDir '/cohort_GM_probability_map;' ...
%                      'gunzip -f ' outputDir '/cohort_GM_probability_map.nii.gz']);

%             system (['fslmaths ' outputDir '/cohort_WM_probability_map.nii ' ...
%                                 '-nan ' ...
%                                 outputDir '/cohort_WM_probability_map;' ...
%                      'gunzip -f ' outputDir '/cohort_WM_probability_map.nii.gz']);

%             system (['fslmaths ' outputDir '/cohort_CSF_probability_map.nii ' ...
%                                 '-nan ' ...
%                                 outputDir '/cohort_CSF_probability_map;' ...
%                      'gunzip -f ' outputDir '/cohort_CSF_probability_map.nii.gz']);




%             % cohort probability maps thr 0.8
% %             system (['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/cohortAvgProbMaps_thr0_8.sh']);
%             system ([CNSP_path '/WMH_extraction/WMHextraction/cohortAvgProbMaps_thr0_8.sh ' ...
%                                                                             GMavg ' ' ...
%                                                                             WMavg ' ' ...
%                                                                             CSFavg ' ' ...
%                                                                             outputDir...
%                                                                             ]);


%             % move generated Template0-6
%             cmd_mvTemplate_1 = ['if [ ! -d ' studyFolder '/subjects/DARTELtemplate ]; then mkdir ' studyFolder '/subjects/DARTELtemplate; fi'];
%             system (cmd_mvTemplate_1);
%             % SubjDirExistingFolders = dir (strcat(studyFolder, '/subjects'));
%             % firstID = SubjDirExistingFolders(3).name;
%             % cmd_mvTemplate_2 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_0.nii ' studyFolder '/subjects/DARTELtemplate'];
%             % cmd_mvTemplate_3 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_1.nii ' studyFolder '/subjects/DARTELtemplate'];
%             % cmd_mvTemplate_4 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_2.nii ' studyFolder '/subjects/DARTELtemplate'];
%             % cmd_mvTemplate_5 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_3.nii ' studyFolder '/subjects/DARTELtemplate'];
%             % cmd_mvTemplate_6 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_4.nii ' studyFolder '/subjects/DARTELtemplate'];
%             % cmd_mvTemplate_7 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_5.nii ' studyFolder '/subjects/DARTELtemplate'];
%             % cmd_mvTemplate_8 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_6.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_2 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_0.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_3 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_1.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_4 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_2.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_5 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_3.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_6 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_4.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_7 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_5.nii ' studyFolder '/subjects/DARTELtemplate'];
%             cmd_mvTemplate_8 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_6.nii ' studyFolder '/subjects/DARTELtemplate'];
%             system (cmd_mvTemplate_2);
%             system (cmd_mvTemplate_3);
%             system (cmd_mvTemplate_4);
%             system (cmd_mvTemplate_5);
%             system (cmd_mvTemplate_6);
%             system (cmd_mvTemplate_7);
%             system (cmd_mvTemplate_8);
 

%     end