function L1g = compute_R_self_fourier(data, rcolumn, scolumn, svalue, t, f_der1, f_der2)

% Compute r(t)

r_t = data(data(:,1)==t, rcolumn);

% Compute r'(t) and direction of r for reference later

rp_t = f_der1(t);

sp_t = f_der2(t);

direction = sp_t/abs(sp_t);

% Ask whether s'(t) is zero.  If so, continue.

if(sp_t == 0)
    
    L1g = NaN;
    
else

    % Find all possible r_hat(t) values in the given data set

    [s_values_r_hat, sp_values_r_hat] = compute_all(data,svalue,scolumn); % Gives all times at which s == svalue

    sp_values = sp_values_r_hat(:,scolumn); % Saves the s' values at each time from above

    % Find the hat value

    t_index_negative = find(sp_values*direction<0); % Take as the possible hat values the times with the same r-value but opposite direction

    t_test = abs(t-s_values_r_hat(t_index_negative,1));
    t_test_index = find(min(t_test)==t_test);
    t2 = s_values_r_hat(t_index_negative(t_test_index),1);

    r_s_hat_t = s_values_r_hat(t_index_negative(t_test_index),rcolumn);
    rp_s_hat_t = f_der1(t2);
    
    r = (r_t-r_s_hat_t);%/(sum([abs(r_t) abs(r_s_hat_t)])+0.05);
    rp = (rp_t-rp_s_hat_t);%/(sum([abs(rp_t) abs(rp_s_hat_t)])+0.05);
    L1g = r*rp;

end

% if(rcolumn == 2 && scolumn == 5)
% 
%      figure(1)
%     plot(data(:,1),data(:,rcolumn), 'b', 'LineWidth', 2)
%     hold on
%     plot(data(:,1),data(:,scolumn), 'r', 'LineWidth', 2)
%     plot(t, svalue, 'ro', 'MarkerSize', 14)
%     plot(t, r_t, 'bo', 'MarkerSize', 14)
%     plot([t t2], [svalue svalue], 'r--', 'LineWidth', 3)
%     plot(t2, r_s_hat_t, 'b*', 'MarkerSize', 14)
%     plot(t2, svalue, 'r*', 'MarkerSize', 14)
%     hold off
%     filename = strcat('Example_Plots/Figure_', num2str(t), '.fig');
%     saveas(gcf, filename)
%     
% end


end




