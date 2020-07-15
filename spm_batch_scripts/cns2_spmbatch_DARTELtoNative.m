%--------------------
% CNSP_DARTELtoNative
%--------------------
%
% DESCRIPTION:
%   inverse transfer image from DARTEL space back to native space
%
% INPUT:
%   DARTELimg = image on DARTEL space that will be mapped back to native
%   space
%   flowMap = flow map of DARTELimg
%   varargin {1} = 'NN' (nearest neighbours. By default, trilinear)
%
% OUTPUT:
%   NativeImg = DARTELimg on native space
%
% USAGE:
%   NativeImg = CNSP_DARTELtoNative (DARTELimg, flowMap)
%

 
function NativeImg = cns2_spmbatch_DARTELtoNative (DARTELimg, flowMap, varargin)

    if cns2param.exe.verbose
        curr_cmd = mfilename;
        fprintf ('%s : warping %s to DARTEL with %s.\n', curr_cmd, srcImgFilename, flowMapFilename);
    end

    [dartelImgFolder, dartelImgFilename, dartelImgExt] = fileparts (DARTELimg);
    [flowMapFolder, flowMapFilename, flowMapExt] = fileparts (flowMap);
    
    if nargin == 3 && strcmp (varargin{1}, 'NN')
        interp = 0;
    else
        interp = 1;
    end
    
    spm('defaults', 'fmri');
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.tools.dartel.crt_iwarped.flowfields = {flowMap};
    matlabbatch{1}.spm.tools.dartel.crt_iwarped.images = {DARTELimg};
    matlabbatch{1}.spm.tools.dartel.crt_iwarped.K = 6;
    matlabbatch{1}.spm.tools.dartel.crt_iwarped.interp = interp;

    output = spm_jobman ('run',matlabbatch);
    
    NativeImg = fullfile (flowMapFolder, ['w' dartelImgFilename '_' flowMapFilename '.nii']);
    movefile (NativeImg,fullfile(flowMapFolder,dartelImgFilename,'_native.nii'));
    NativeImg = fullfile (flowMapFolder, dartelImgFilename, '_native.nii');
