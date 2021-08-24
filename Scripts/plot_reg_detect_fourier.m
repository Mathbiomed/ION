%%% Compute and plot regulation_detection for cross interactions %%%

% Copyright (c) 2021, Jonathan P. Tyler
% All rights reserved.

% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function R_score = plot_reg_detect_fourier(rcolumn, scolumn, data, ffit_n)

Rs = [];
ts = [];

tv = data(:,1);

load(['Output/Var_' num2str(rcolumn) '.mat'], 'fitresults')

f_v1 = fitresults;

% Construct the derivatives 

c1 = coeffvalues(f_v1);

syms x

f_der = 0;

for i = 1:ffit_n

    f_der = f_der + i*c1(2*i+1)*c1(end)*cos(i*c1(end)*x) - i*c1(2*i)*c1(end)*sin(i*c1(end)*x);

end

f_der = matlabFunction(f_der);

for i = 1:length(tv)
    
        try

            % Compute the regulation detection value at time data(i,1)
            
            R = compute_R_fourier(data,rcolumn,scolumn,data(i,rcolumn), data(i,1), f_der);
            Rs = [Rs; R];
            ts = [ts; data(i,1)];

        catch
        
            continue;
        
        end    
    
end

filehead = strcat('Output/Reg_detect_', num2str(rcolumn-1), '_onto_', num2str(scolumn-1));

all_s = [ts Rs];

save(strcat(filehead, '.mat'), 'all_s');

tsp = ts;
tsn = ts;
Rsp = Rs;
Rsn = Rs;

Rsp(Rs<0) = 0;
Rsn(Rs>=0) = 0;

% Make the regulation detection figure for 
fig_filehead = ['Output/Reg_dect_', num2str(scolumn-1), '_onto_', num2str(rcolumn-1), '.fig'];
figure(1)
area(tsp, Rsp, 'FaceColor', 'b')
hold on
area(tsn, Rsn, 'FaceColor', 'r')
hold off
xlabel('Time', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Regulation detection value', 'FontWeight', 'bold', 'FontSize', 18)

% Compute the score

A1 = trapz(ts,Rs);
A2 = trapz(ts,abs(Rs));

P = (A1+A2)/2;
N = (A2-A1)/2;

R_score = (P-N)/(P+N);

% Add the score to the title of the figure
title({['Regulation Detection Function for Variable ' num2str(scolumn-1) ' onto Variable ' num2str(rcolumn-1)], ['Score = ' num2str(R_score, 3)]}, 'FontSize', 18, 'FontWeight', 'bold')
saveas(1, fig_filehead)
end

