function [fitresult, gof] = createFit(x, y, per, ffit_n, var_name)
%  Create a fourier fit with prescribed fittype ft.
%
%  Data for fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fourier fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.StartPoint = [zeros(1,1+2*ffit_n) 2*pi/per];
opts.TolFun = 1e-10;
opts.TolX = 1e-10;
ft = ['fourier' num2str(ffit_n)];
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure(1);
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', ['Fourier Fit ' var_name], 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( var_name, 'Interpreter', 'none' );
title(['Fourier fit for ' var_name]);
grid on
saveas(1, ['Output/' var_name '.fig']);


