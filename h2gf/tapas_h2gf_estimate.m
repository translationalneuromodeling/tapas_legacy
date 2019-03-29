function [posterior] = tapas_h2gf_estimate(data, model, inference, pars)
%% Estimates the hgf using mcmc.
%
% Input
%   data        -- Data of the model. It should be a structure array with 
%                  fields y, and u of dimensions n times 1, when n is the 
%                  number of subjects.
%   model       -- Standar hgf structure object. 
%   inference   -- Inference object. (Optional)
%   pars        -- Parameter structure. (Optional)
%       
% Output
%  posterior    -- Structure containing the posterior.
%

% aponteeduardo@gmail.com
% copyright (C) 2016
%


n = 2;

n = n + 1;
if nargin < n
    inference = struct();
end

n = n + 1;
if nargin < n
    pars = struct();
end

[pars] = tapas_h2gf_pars(data, model, pars);
[data] = tapas_h2gf_data(data, model, pars);
[model] = tapas_h2gf_model(data, model, pars);
[inference] = tapas_h2gf_inference(inference, pars);

[posterior] = tapas_h2gf_estimate_interface(data, model, inference);


end

