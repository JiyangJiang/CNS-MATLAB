%------------------
% CNSP_registration 
%------------------
%
% DESCRIPTION:
%   To register source image to reference image.
%
% INPUT:
%   srcImg = path to source image
%   refImg = path to reference image
%   outputFolder = path to the folder of the registered image, or 'same_dir' if same as srcImg dir.
%   varargin{2} = other image
%   varargin{3} = interpolation ('NN' or 'Tri')
% 
% USAGE:
%   CNSP_registration (FLAIR,T1,'/home/ABC');
%

function rSrcImg = cns2_spmbatch_coregistration (srcImg, refImg, outputFolder, varargin)

    [srcImgParentFolder, srcImgFilename, srcImgExt] = fileparts (srcImg);
    [refImgParentFolder, refImgFilename, refImgExt] = fileparts (refImg);
    curr_cmd = mfilename;
    fprintf ('%s : registering %s%s to %s%s.\n', curr_cmd, ...
                                                srcImgFilename, srcImgExt, ...
                                                refImgFilename, refImgExt);

    if nargin == 4
        otherImg = varargin{1};
    elseif nargin == 3
        otherImg = '';
    end

    if (nargin == 5) && strcmp(varargin{2}, 'NN')
        interp = 0;
        otherImg = varargin{1};
    elseif (nargin == 5) && strcmp(varargin{2}, 'Tri')
        interp = 1;
        otherImg = varargin{1};
    else
        interp = 4;
    end


    spm('defaults', 'fmri');
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[refImg ',1']};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = {[srcImg ',1']};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {otherImg};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = interp;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

    output = spm_jobman ('run',matlabbatch);

    % move coregistered source image to outputFolder
    if ~strcmp (outputFolder, 'same_dir')
        movefile (fullfile (srcImgParentFolder, ['r' srcImgFilename srcImgExt]), outputFolder);
        rSrcImg = fullfile (outputFolder, ['r' srcImgFilename srcImgExt]);
    else
        rSrcImg = fullfile (srcImgParentFolder, ['r' srcImgFilename srcImgExt]);
    end
