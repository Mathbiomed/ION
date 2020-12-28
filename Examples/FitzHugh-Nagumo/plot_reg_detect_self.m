%%% Plot R r - CFP, s - mCherry %%%

function R_score = plot_reg_detect_self(rcolumn, scolumn, data, rp_data, extrema)

Rs = [];
ts = [];
rps = [];
rs = [];
tv = data(:,1);

for i = 1:length(tv)
        
        try

            R = compute_R_self(data,rcolumn,scolumn,data(i,scolumn), data(i,1), rp_data, extrema);

            Rs = [Rs; R];
            ts = [ts; data(i,1)];
% 
        catch

           continue;

        end
    
    
end

tsp = ts;
tsn = ts;
Rsp = Rs;
Rsn = Rs;

Rsp(Rs<0) = 0;
Rsn(Rs>=0) = 0;


% Make the regulation detection figure for 
fig_filehead = ['Output/Reg_dect_', num2str(rcolumn-1), '_onto_', num2str(rcolumn-1), '_fix_' num2str(scolumn-1) '.fig'];
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
title({['Regulation Detection Function for Variable ' num2str(rcolumn-1) ' onto Variable ' num2str(rcolumn-1)], ['Fixing Variable ' num2str(scolumn-1)], ['Score = ' num2str(R_score, 3)]}, 'FontSize', 18, 'FontWeight', 'bold')
saveas(1, fig_filehead)