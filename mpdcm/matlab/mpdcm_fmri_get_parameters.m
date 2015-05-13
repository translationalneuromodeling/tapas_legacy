function [p] = mpdm_fmri_get_parameters(theta, ptheta)
%% Gets the parameters in vectorial form. 
%
% aponteeduardo@gmail.com
%
% Author: Eduardo Aponte, TNU, UZH & ETHZ - 2015
%
% Revision log:
%
%


nt = numel(theta);
p = cell(size(theta));

for i = 1:nt

    ta = theta{i}.A(logical(ptheta.a)); 
    tb = theta{i}.B(logical(ptheta.b));
    tc = theta{i}.C(logical(ptheta.c));
    td = theta{i}.D(logical(ptheta.d));

    ttran = theta{i}.K;
    tdecay = theta{i}.tau;
    tepsilon = theta{i}.epsilon;
    tl = theta{i}.lambda;

    p{i} = [ta(:); tb(:); tc(:); td(:); ttran(:); tdecay(:); tepsilon(:); ...
        tl(:)];

end


end
