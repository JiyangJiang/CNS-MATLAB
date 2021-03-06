%-----------------
% CNSP_mapToDARTEL
%-----------------
%
% DESCRIPTION:
%   To map image to DARTEL space
%
% INPUT:
%   srcImg = path to the image (*.nii) that will be mapped to DARTEL space
%   flowMap = flow map of srcImg
%   varargin{1} = 'Trilinear' or 'NN'
%
% OUTPUT:
%   srcImgOnDARTEL = srcImg mapped to DARTEL space
%
% USAGE:
%   srcImgOnDARTEL = cns2_spmbatch_nativeToDARTEL (srcImg, flowMap)
%
% NOTE:
%   need to run CNSP_runDARTELe or CNSP_runDARTELc to generate flow map
%

function srcImgOnDARTEL = cns2_spmbatch_nativeToDARTEL (cns2param, srcImg, flowMap, varargin)

    [flowMapFolder,flowMapFilename,flowMapExt] = fileparts (flowMap);
    [srcImgFolder,srcImgFilename,srcImgExt] = fileparts (srcImg);

    if cns2param.exe.verbose
        curr_cmd = mfilename;
        fprintf ('%s : warping %s to DARTEL with %s.\n', curr_cmd, srcImgFilename, flowMapFilename);
    end
    
    if nargin == 4
        switch varargin{1}
            case 'Trilinear'
                interpCode = 1;
            case 'NN'
                interpCode = 0;
        end
    elseif nargin == 3
        interpCode = 1;
    end
    
    clear matlabbatch;

    spm('defaults', 'fmri');
    spm_jobman('initcfg');

    matlabbatch{1}.spm.tools.dartel.crt_warped.flowfields = {flowMap};
    matlabbatch{1}.spm.tools.dartel.crt_warped.images = {
                                                         {srcImg}
                                                         }';
    matlabbatch{1}.spm.tools.dartel.crt_warped.jactransf = 0;
    matlabbatch{1}.spm.tools.dartel.crt_warped.K = 6;
    matlabbatch{1}.spm.tools.dartel.crt_warped.interp = interpCode;

    output = spm_jobman ('run',matlabbatch);
    
    srcImgOnDARTEL = fullfile (flowMapFolder, ['w' srcImgFilename srcImgExt]);
