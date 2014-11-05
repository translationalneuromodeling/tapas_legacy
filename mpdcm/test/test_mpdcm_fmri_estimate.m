function test_mpdcm_fmri_estimate()
%% 
%
% aponteeduardo@gmail.com
% copyright (C) 2014
%

d = test_mpdcm_fmri_load_td();

% Check that there are no fatal error

nd = d{1};
nd.U.u = nd.U.u(1:4:end,:);
nd.U.dt = 1.0;

try
    pars = struct();
    pars.T = linspace(1e-1, 1, 100).^5;
    pars.nburnin = 500;
    pars.niter = 4000;
    profile clear
    profile on
    dcm = mpdcm_fmri_estimate(nd, pars);
    profile off
    profile viewer
    
    display('    Passed')
catch err
    d = dbstack();
    fprintf('   Not passed at line %d\n', d(1).line)
    disp(getReport(err, 'extended'));
end

% Make a more intensive test of the function

try
    pars = struct();
    pars.T = linspace(1e-1, 1, 100).^5;
    pars.nburnin = 500;
    pars.niter = 5000;

    tic
    %dcm = mpdcm_fmri_estimate(d{1}, pars);
    toc

    fprintf('Fe: %0.5f', dcm.F);
    display('    Passed')
catch err
    d = dbstack();
    fprintf('   Not passed at line %d\n', d(1).line)
    disp(getReport(err, 'extended'));
end
end
