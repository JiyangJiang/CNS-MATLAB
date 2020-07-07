% ---------------------
% cns2_scripts_getLatVent
% ---------------------

% DESCRIPTION
% -----------
% Get lateral ventricles from low resolution images.
% Used OATS 65to75 template, so may not work well for young brains.
%
%
% USAGE
% -----
% img = any modality MRI
% T1 = T1-weighted image of the same individual
% outputFolder = output path
% spm12path = spm12 directory
% 
%
% OTHER INFO
% ----------
% Use whole head for img and T1, not NBTR
%
%
% Written by Dr. Jiyang Jiang. December 2017.
%

function ventricle_native = cns2_scripts_getLatVent (cns2param, img, T1, outputFolder)

if cns2param.exe.verbose
    curr_cmd = mfilename;
    fprintf ('%s : segmenting lateral ventricles from %s.\n', curr_cmd, img);
end

% get T1 folder
[T1folder, ~, ~] = fileparts (T1);

% img register to T1
rimg = cns2_spmbatch_coregistration (cns2param, img, T1, outputFolder);

% T1 segmentation
[cGM,cWM,cCSF,rcGM,rcWM,rcCSF,mat] = cns2_spmbatch_segmentation (cns2param,T1);

% T1 to DARTEL
template1 = fullfile(cns2param.dirs.cns2,'templates','DARTEL_0to6_templates','65to75','Template_1.nii');
template2 = fullfile(cns2param.dirs.cns2,'templates','DARTEL_0to6_templates','65to75','Template_2.nii');
template3 = fullfile(cns2param.dirs.cns2,'templates','DARTEL_0to6_templates','65to75','Template_3.nii');
template4 = fullfile(cns2param.dirs.cns2,'templates','DARTEL_0to6_templates','65to75','Template_4.nii');
template5 = fullfile(cns2param.dirs.cns2,'templates','DARTEL_0to6_templates','65to75','Template_5.nii');
template6 = fullfile(cns2param.dirs.cns2,'templates','DARTEL_0to6_templates','65to75','Template_6.nii');

% run DARTEL to get flow map
flowMap = cns2_spmbatch_runDARTELe (cns2param, ...
                                    rcGM, rcWM, rcCSF, ...
                                    template1, template2, template3, template4, template5, template6);

% bring ventricle to T1 space
copyfile (fullfile (cns2param.dirs.cns2,'templates',...
                    'DARTEL_ventricle_distance_map','DARTEL_ventricle_65to75.nii'),...
          fullfile (outputFolder,'dartel_vent.nii'));

T1space_vent = cns2_spmbatch_DARTELtoNative (fullfile (outputFolder,'dartel_vent.nii'), ...
                                             flowMap, ...
                                             'NN');

% reslice T1space_vent to the same dimension as T1
files = {T1;T1space_vent};
resliceFlags= struct('interp',1,... % B-spline
					'mask',1,...
					'mean',0,...
					'which',1,...
					'wrap',[0 0 0],...
                    'prefix','t1SpcDim_');
spm_reslice (files,resliceFlags);

% refine ventricular mask in T1 space
t1SpcDim_vent_struct = dir(fullfile(T1folder, 't1SpcDim_dartel_vent.nii'));
t1SpcDim_vent        = fullfile(T1folder, t1SpcDim_vent_struct.name);

csf_dat           = spm_read_vols(spm_vol(cCSF));
t1SpcDim_vent_dat = spm_read_vols(spm_vol(t1SpcDim_vent));
csf_bin_dat = csf_dat>0.8;
vent_dat = t1SpcDim_vent_dat .* csf_bin_dat;

cns2_scripts_writeNii  (cns2param, ...
                        spm_vol(t1SpcDim_vent), ...
                        vent_dat, ...
                        fullfile(outputFolder, 'ventricular_mask.nii'));

% T1 to native space
cns2_scripts_revReg (cns2param, img, T1, fullfile(outputFolder, 'ventricular_mask.nii'));

% clean up
% ----======== NOT FINISHED YET =========--------
if ~cns2param.exe.save_dskspc

system (['mv ' cGM ' ' ...
                cWM ' ' ...
                cCSF ' ' ...
                mat ' ' ...
                T1folder '/r*.nii ' ...
                T1folder '/w*.nii ' ...
                flowMap ' ' ...
                T1folder '/T1spaceanddim_*.nii ' ...
                outputFolder]);
else
    delete (cGM,cWM,cCSF,mat,fullfile(T1folder,'r*.nii'))

ventricle_native = [outputFolder '/rventricular_mask.nii'];

system (['. ${FSLDIR}/etc/fslconf/fsl.sh;gzip -f ' ventricle_native ';${FSLDIR}/bin/fslmaths ' ventricle_native '.gz -nan -thr 0 -bin ' ventricle_native '.gz;gunzip -f ' ventricle_native '.gz']);
