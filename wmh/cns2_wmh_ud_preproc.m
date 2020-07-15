% varargin{1} = cell array of flow maps. 'creating templates' will generate
%				flow maps in addition to Template 0-6.

function cns2_wmh_ud_preproc (cns2param,i,varargin)

curr_cmd = mfilename;

fprintf ('%s : start preprocessing %s.\n', curr_cmd, cns2param.lists.subjs{i,1});

switch cns2param.classification.ud.ext_space
	case 'dartel'
		switch cns2param.templates.options{1}
		    case 'existing'
				cns2_wmh_ud_preproc_dartel (cns2param,i);

			case 'creating'
				if nargin==3
					flowmaps = varargin{1}; % creating templates will also generate flowmaps
											% which are passed as a cell array in the 3rd
											% argument.
					cns2_wmh_ud_preproc_dartel (cns2param,i,flowmaps);
				else
					ME = MException ('CNS2:preproc:incorrNumInputCreatingTemp', ...
								 	 '''Creating templates'' should pass flowmaps to cns2_wmh_ud_preproc.');
					throw (ME);
				end
		end
	case 'native'
		switch cns2param.templates.options{1}
		    case 'existing'
				cns2_wmh_ud_preproc_native ('cns2_ud',cns2param,i);

			case 'creating'
				if nargin==3
					flowmaps = varargin{1}; % creating templates will also generate flowmaps
											% which are passed as a cell array in the 3rd
											% argument.
					cns2_wmh_ud_preproc_native ('cns2_ud',cns2param,i,flowmaps);
				else
					ME = MException ('CNS2:preproc:incorrNumInputCreatingTemp', ...
								 	 '''Creating templates'' should pass flowmaps to cns2_wmh_ud_preproc.');
					throw (ME);
				end
		end
end
