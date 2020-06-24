function cns2_spmbatch_corrBiasField (cns2param, in)

if cns2param.exe.verbose
	curr_cmd = mfilename;
	fprintf ('%s : correcting bias field for %s.\n', curr_cmd, in);
end

clear matlabbatch;

spm('defaults', 'fmri');
spm_jobman('initcfg');

matlabbatch{1}.spm.spatial.preproc.channel.vols = {in};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 20;
matlabbatch{1}.spm.spatial.preproc.channel.write = [1 1];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];

output = spm_jobman ('run',matlabbatch);