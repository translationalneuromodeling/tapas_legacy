function test_mpdcm_fmri_map(fp)
%% Test 
%
% fp -- Pointer to a file for the test output, defaults to 1
%
% aponteeduardo@gmail.com
%
% Author: Eduardo Aponte
%
% Revision log:
%
%

if nargin < 1
    fp = 1;
end

fname = mfilename();
fname = regexprep(fname, 'test_', '');


fprintf(fp, '================\n Test %s\n================\n', fname);

d = test_mpdcm_fmri_load_td();

for i = 1:5
    [y, u, theta, ptheta] = mpdcm_fmri_tinput(d(i));

    % Test whether there is any clear bug
    try
        mpdcm_fmri_map(y, u, theta, ptheta);
        fprintf(fp, '       Passed\n');
    catch err
        fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
        display(getReport(err, 'extended'));
    end
end

try
    [y, u, theta, ptheta] = mpdcm_fmri_tinput(d);
    mpdcm_fmri_map(y, u, theta, ptheta);
    fprintf(fp, '       Passed\n');
catch err
    fprintf(fp, '   Not passed at line %d\n', err.stack(end).line);
    display(getReport(err, 'extended'));
end


end

