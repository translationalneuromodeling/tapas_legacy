function [theta] = mpdcm_fmri_set_parameters(p, theta, ptheta)
%% [ntheta] = mpdcm_fmri_set_parameters(p, theta, ptheta)
% Sets the parameters introduced in vectorial form.
%
% Input:
%
% p -- Cell array of parameters in matrix form
% theta -- Cell array of parameters in structure form
% ptheta -- Hyperparameters
%
% Ouput -- Cell array of parameters in structure form
%
% aponteeduardo@gmail.com
%
% Author: Eduardo Aponte
%
% Revision log:
%
%


nt = numel(theta);
nl = numel(ptheta.Q);

for i = 1:nt

    nr = size(ptheta.a, 1);   
    tp = p{i};

    oi = 0;
    ni = sum(logical(ptheta.a(:)));

    theta{i}.A(logical(ptheta.a)) = indexing(tp, oi, ni);

    oi = ni;
    ni = oi + sum(logical(ptheta.b(:)));
    theta{i}.B(ptheta.b) = indexing(tp, oi, ni);
        
    oi = ni;
    ni = oi + sum(logical(ptheta.c(:)));
    theta{i}.C(logical(ptheta.c)) = indexing(tp, oi, ni);

    oi = ni;
    ni = oi + nr;
    theta{i}.K = indexing(tp, oi, ni);

    oi = ni;
    ni = oi + nr;
    theta{i}.tau(:) = indexing(tp, oi, ni);

    oi = ni;
    ni = oi + 1;
    theta{i}.epsilon(:) = indexing(tp, oi, ni);

    oi = ni;
    ni = oi + nl;
    theta{i}.lambda = indexing(tp, oi, ni);

end

end

function [na] = indexing(a, li, hi )

if li == hi
    na = [];
    return
end

na = a(li+1:hi);

end
