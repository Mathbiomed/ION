function L1 = compute_R_fourier(data, rcolumn, scolumn, rvalue, t, f_der)

% Compute s(t)

s_t = data(data(:,1)==t, scolumn);

% Compute r'(t) and direction of r for reference later

rp_t = f_der(t);

direction = rp_t/abs(rp_t);

if(rp_t == 0)
    
    L1 = NaN;
    
else

    % Find all possible r_hat(t) values in the given data set

    [s_values_r_hat, sp_values_r_hat] = compute_all(data,rvalue,rcolumn); % Gives all times at which r == rvalue

    rp_values = sp_values_r_hat(:,rcolumn); % Saves the rprime values at each time from above

    % Find the hat value

    t_index_negative = find(rp_values*direction<0); % Take as the possible hat values the times with the same r-value but opposite direction

    t_test = abs(t-s_values_r_hat(t_index_negative,1));
    t_test_index = find(min(t_test)==t_test);
    t2 = s_values_r_hat(t_index_negative(t_test_index),1);

    s_r_hat_t = s_values_r_hat(t_index_negative(t_test_index),scolumn);
    rp_r_hat_t = f_der(t2);

    s = (s_t-s_r_hat_t);%/(sum([abs(s_t) abs(s_r_hat_t)])+0.05);
    rp = (rp_t-rp_r_hat_t);%/(sum([abs(rp_t) abs(rp_r_hat_t)])+0.05);
    L1 = s*rp;
    
end

% figure(1)
% plot(data(:,1),data(:,rcolumn), 'b', 'LineWidth', 2)
% hold on
% plot(data(:,1),data(:,scolumn), 'r', 'LineWidth', 2)
% plot(t, rvalue, 'bo', 'MarkerSize', 14)
% plot(t, s_t, 'ro', 'MarkerSize', 14)
% plot([t t2], [rvalue rvalue], 'b--', 'LineWidth', 3)
% plot(t2, s_r_hat_t, 'r*', 'MarkerSize', 14)
% plot(t2, rvalue, 'b*', 'MarkerSize', 14)
% hold off
% filename = strcat('Example_Plots/Figure_', num2str(t), '.fig');
% saveas(gcf, filename)

end



