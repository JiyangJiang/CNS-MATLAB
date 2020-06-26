function lv2clstrs_struct = cns2_wmh_ud_classification_2ndlvclstrs (cns2param, lv1clstrs_dat, hdr, out_nii, varargin)

curr_cmd = mfilename;

if nargin == 5
	idx = varargin{1};
end

if cns2param.exe.verbose && nargin==4
	fprintf ('%s : generating %s''s 2nd-level clusters.\n', curr_cmd, cns2param.lists.subjs{idx,1});
end

% initialise to resolve the parfor classification issue
lv2clstrs_dat = zeros ([size(lv1clstrs_dat) cns2param.classification.ud.k4kmeans]);

for k = 1 : cns2param.classification.ud.k4kmeans
	tmp = lv1clstrs_dat;
	tmp (tmp ~= k) = 0;
	tmp (tmp == k) = 1;
	lv2clstrs_struct(k) = bwconncomp (tmp, 6); % 6-connectivity
	lv2clstrs_dat (:,:,:,k) = labelmatrix (lv2clstrs_struct (k));
end

% write out 2nd-level clusters
if  ~cns2param.exe.save_dskspc && ~cns2param.exe.save_more_dskspc
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