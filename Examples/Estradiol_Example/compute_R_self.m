function L1 = compute_R_self(data, rcolumn, scolumn, svalue, t, rp_data, extrema)


if(ismember(t, data(:,1)))
    
    rp_t = rp_data(data(:,1) == t, rcolumn);
    r_t = data(data(:,1) == t, rcolumn);
    [s_values_r_hat, sp_values_r_hat] = compute_all(data,svalue,scolumn); % Gives all times at which s == svalue
    sp_values = sp_values_r_hat(:,scolumn); % Saves the rprime values at each time from above
    sp_values_direction = find_direction(sp_values_r_hat(:,1),extrema,scolumn-1);
    direction = find_direction(t, extrema, scolumn-1);
    
else

    [s_values_r_hat, sp_values_r_hat] = compute_all(data,svalue,scolumn); % Gives all times at which r == rvalue
    sp_values = sp_values_r_hat(:,scolumn); % Saves the rprime values at each time from above
    sp_values_direction = find_direction(sp_values_r_hat(:,1),extrema,scolumn-1);
    direction = find_direction(t, extrema, scolumn-1);
    t_index = find(sp_values_direction*direction>0); % These index the times at which the direction of sp matches the input direction

    % Find the s value at the time t

    t_test_1 = abs(t-s_values_r_hat(t_index,1));
    t_test_1_index = find(min(t_test_1)==t_test_1);
    t1 = s_values_r_hat(t_index(t_test_1_index),1);
    r_t = s_values_r_hat(t_index(t_test_1_index), rcolumn);
    rp_t = interp1(rp_data(:,1), rp_data(:,rcolumn), t1, 'linear');
end

% Find the s value closest to the r-value in question

t_index_negative = find(sp_values_direction*direction<0);

t_test = abs(t-s_values_r_hat(t_index_negative,1));
t_test_index = find(min(t_test)==t_test);
t2 = s_values_r_hat(t_index_negative(t_test_index),1);

r_s_hat_t = s_values_r_hat(t_index_negative(t_test_index),rcolumn);
rp_s_hat_t = interp1(data(:,1), rp_data(:,rcolumn), t2, 'linear');

% Final L1g values

r = (r_t-r_s_hat_t)/(sum([abs(r_t) abs(r_s_hat_t)])+0.05);
rp = (rp_t-rp_s_hat_t)/(sum([abs(rp_t) abs(rp_s_hat_t)])+0.05);
L1 = r*rp;

% if(rcolumn == 2 & scolumn == 4)
%     % Make a figure to check everything works
%     figure(1)
%     plot(data(:,1),data(:,rcolumn), 'b', 'LineWidth', 2)
%     hold on
%     plot(data(:,1),data(:,scolumn), 'r', 'LineWidth', 2)
%     plot(t, svalue, 'ro', 'MarkerSize', 14)
%     plot(t, r_t, 'bo', 'MarkerSize', 14)
%     plot([t t2], [svalue svalue], 'r--', 'LineWidth', 3)
%     plot(t2, svalue, 'r*', 'MarkerSize', 14)
%     plot(t2, r_s_hat_t, 'b*', 'MarkerSize', 14)
%     hold off
%     filename = strcat('Example_Plots/Figure_', num2str(t), '.fig');
%     saveas(gcf, filename)
% end

end



