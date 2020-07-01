function lv2clstrs_struct = cns2_wmh_ud_postproc_classification_2ndlvclstrs (cns2param, lv1clstrs_dat, hdr, out_nii, varargin)

curr_cmd = mfilename;

if nargin == 5
	idx = varargin{1};
end

if cns2param.exe.verbose && nargin==4
	fprintf ('%s : generating %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end

switch cns2param.classification.ud.lv1clstr_method
case 'kmeans'
	Nlv1clstrs = cns2param.classification.ud.k4kmeans;
case 'superpixel'
	Nlv1clstrs = cns2param.classification.ud.n4superpixel_actual;
end

% initialise to resolve the parfor classification issue
lv2clstrs_dat = zeros ([size(lv1clstrs_dat) Nlv1clstrs]);

for k = 1 : Nlv1clstrs
	tmp = lv1clstrs_dat;
	tmp (tmp ~= k) = 0;
	tmp (tmp == k) = 1;
	lv2clstrs_struct(k) = bwconncomp (tmp, 6); % 6-connectivity
	lv2clstrs_dat (:,:,:,k) = labelmatrix (lv2clstrs_struct (k));
end
clearvars tmp;

% write out 2nd-level clusters
% not saving for superpixel because too many
if  ~cns2param.exe.save_more_dskspc && ~strcmp(cns2param.classification.ud.lv1clstr_method,'superpixel')
	if cns2param.exe.verbose && nargin==5
		fprintf ('%s : writing %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
	elseif cns2param.exe.verbose && nargin==4
		fprintf ('%s : writing 2nd-level clusters.\n', curr_cmd);
	end
	cns2_scripts_writeNii (cns2param, ...
						   hdr, ...
						   lv2clstrs_dat, ...
						   out_nii, ...
						   '4d');
end