function [dcms] = tapas_mpdcm_fmri_generate(dcms)
%% Generates DCMs using the parameters given in dcms. Similar to 
% spm_dcm_generate
%
% Input
%   dcms        -- Cell array of DCM structures
% Output
%   dcms        -- Cell array of DCM structures including the predicted signals
%
% aponteeduardo@gmail.com
% copyright (C) 2015
%

[y, u, theta, ptheta] = tapas_mpdcm_fmri_tinput(dcms);

for i = 1:numel(dcms)
    dcm = dcms{i};
    theta{i}.A = dcm.Ep.A;
    theta{i}.B = full(dcm.Ep.B);
    theta{i}.C = dcm.Ep.C;
    theta{i}.D = dcm.Ep.D;
    theta{i}.K = dcm.Ep.decay;
    theta{i}.tau = dcm.Ep.transit;
    theta{i}.epsilon = dcm.Ep.epsilon;
    ptheta.dt = 1;
end

ys = tapas_mpdcm_fmri_int(u, theta, ptheta);

for i = 1:numel(dcms)
    dcms{i}.y = ys{i};
end


end
