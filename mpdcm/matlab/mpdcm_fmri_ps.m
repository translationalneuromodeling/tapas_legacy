function [ps, fe] = mpdcm_fmri_ps(dcm, pars)
%% Estimates the posterior probability of the parameters using MCMC combined
% with path sampling.
% dcm -- DCM to be estimated
% pars -- Parameters for the mcmc
%
% Uses a standard MCMC on a population and applies an exchange operator
% to improve the mixing.
%
%
% Real parameter evolutionary Monte Carlo with applications to Bayes Mixture
% Models, Journal of American Statistica Association, Liang & Wong 2001.
%
% aponteeduardo@gmail.com
% copyright (C) 2014
%

if ~isfield(pars, 'verbose')
    pars.verbose = 1;
end

DIAGN = 50;

T = pars.T;
nburnin = pars.nburnin;
niter = pars.niter;

nt = numel(T);

[y0, u0, theta0, ptheta] = mpdcm_fmri_tinput(dcm);
htheta = mpdcm_fmri_htheta(ptheta);

u = {u0};
y = {y0};
theta = {theta0};
otheta = {theta0};

[q, otheta] = mpdcm_fmri_gmodel(y, u, otheta, ptheta);
[ollh, ny] = mpdcm_fmri_llh(y, u, otheta, ptheta);
fprintf(1, 'Starting llh: %0.5d\n', ollh);

[op] = mpdcm_fmri_get_parameters(otheta, ptheta);

%[op, ~, ~] = mpdcm_fmri_map(y, u, otheta, ptheta);
%otheta = mpdcm_fmri_set_parameters(op, {theta0}, ptheta);

%[ollh, ny] = mpdcm_fmri_llh(y, u, otheta, ptheta);
%display(ollh);

% This is purely heuristics. There is an interpolation between the prior and
% the mle estimator such that not all chains are forced into high llh regions.
% Moreover, at low temperatures the chains are started in more sensible regime

op = op{1};
np = [(linspace(0, 1, nt)').^5 (1-linspace(0, 1, nt)).^5'] * ...
    [op ptheta.mtheta]';
np = mat2cell(np', numel(op), ones(1, nt));

otheta = mpdcm_fmri_set_parameters({op}, {theta0}, ptheta);

% Samples from posterior

theta = cell(1, nt);
theta(:) = otheta;

op = np;

% Fully initilize
otheta = mpdcm_fmri_set_parameters(op, theta, ptheta);

[ollh, ~] = mpdcm_fmri_llh(y, u, otheta, ptheta);
olpp = mpdcm_fmri_lpp(y, u, otheta, ptheta);

% Eliminate weird cases

[~, l] = min(abs(bsxfun(@minus, find(isnan(ollh)), find(~isnan(ollh))')));
tl = find(~isnan(ollh));
l = tl(l);

olpp(isnan(ollh)) = olpp(l);
op(:, isnan(ollh)) = op(:, l);
ollh(isnan(ollh)) = ollh(l);

ps_theta = zeros(numel(op{end}), niter);
ellh = zeros(nt, niter);

diagnostics = zeros(1, nt);
% Optimized kernel
kt = ones(1, nt);
tic
for i = 1:nburnin+niter

    if mod(i, DIAGN) == 0
        diagnostics = diagnostics/DIAGN;
        if pars.verbose
            fprintf(1, 'Iter %d, diagnostics:  ', i);
            fprintf(1, '%0.2f ', diagnostics);
            fprintf(1, '%0.2f ', ollh);
            fprintf(1, '\n');
        end
        if i < nburnin
            kt(diagnostics < 0.3) = kt(diagnostics < 0.3)/2;
            kt(diagnostics > 0.7) = kt(diagnostics > 0.7)*1.8;
        end
        diagnostics(:) = 0;
    toc
    tic
    end

    np = mpdcm_fmri_sample(op, ptheta, htheta, num2cell(kt));
    ntheta = mpdcm_fmri_set_parameters(np, theta, ptheta);

    [nllh, ny] = mpdcm_fmri_llh(y, u, ntheta, ptheta, 1);

    nllh = sum(nllh, 1);
    nlpp = sum(mpdcm_fmri_lpp(y, u, ntheta, ptheta), 1);

    nllh(isnan(nllh)) = -inf;

    v = nllh.*T + nlpp - (ollh.*T + olpp);
    tv = v;
    v = rand(size(v)) < exp(bsxfun(@min, v, 0));

    ollh(v) = nllh(v);
    olpp(v) = nlpp(v);
    op(:, v) = np(:, v);

    diagnostics(:) = diagnostics(:) + v(:);

    if i > nburnin
        ps_theta(:, i - nburnin) = op{end};
        ellh(:, i - nburnin) = ollh;
    end

    assert(all(-inf < ollh), 'mpdcm:fmri:ps', '-inf value in the likelihood');


end

fe = trapz(T, mean(ellh, 2));

ps.pE = mean(op{end} , 2);
ps.theta = mpdcm_fmri_set_parameters(op(:), {theta0}, ptheta);
ps.y = mpdcm_fmri_int(u, ps.theta, ptheta);
ps.theta = ps.theta{:};
ps.y = ps.y{:};
ps.F = fe;

