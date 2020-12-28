function R = compute_R(data, rcolumn, scolumn, rvalue, t, rp_data, extrema)

if(ismember(t, data(:,1)))
    t1 = t;
    s_t = data(data(:,1)==t, scolumn);
    rp_t = rp_data(data(:,1) == t, rcolumn);
    [s_values_r_hat, sp_values_r_hat] = compute_all(data,rvalue,rcolumn); % Gives all times at which r == rvalue
    rp_values = sp_values_r_hat(:,rcolumn); % Saves the rprime values at each time from above
    rp_values_direction = find_direction(sp_values_r_hat(:,1),extrema,rcolumn-1);
    direction = find_direction(t, extrema, rcolumn-1);
    
else

    [s_values_r_hat, sp_values_r_hat] = compute_all(data,rvalue,rcolumn); % Gives all times at which r == rvalue
    rp_values = sp_values_r_hat(:,rcolumn); % Saves the rprime values at each time from above
    
    rp_values_direction = find_direction(sp_values_r_hat(:,1),extrema,rcolumn-1);
    direction = find_direction(t, extrema, rcolumn-1);
    
    t_index = find(rp_values_direction*direction>0); % These index the times at which the direction of rp matches the input direction

    % Find the s value at the time t

    t_test_1 = abs(t-s_values_r_hat(t_index,1));
    t_test_1_index = find(min(t_test_1)==t_test_1);
    t1 = s_values_r_hat(t_index(t_test_1_index),1);
    s_t = s_values_r_hat(t_index(t_test_1_index), scolumn);
    %rp_t = sp_values_r_hat(t_index(t_test_1_index),rcolumn);
    rp_t = interp1(rp_data(:,1), rp_data(:,rcolumn), t1, 'linear');
end

% Find the s value closest to the r-value in question

t_index_negative = find(rp_values_direction*direction<0);

t_test = abs(t-s_values_r_hat(t_index_negative,1));
t_test_index = find(min(t_test)==t_test);
t2 = s_values_r_hat(t_index_negative(t_test_index),1);

s_r_hat_t = s_values_r_hat(t_index_negative(t_test_index),scolumn);
rp_r_hat_t = interp1(data(:,1), rp_data(:,rcolumn), t2, 'linear');

s = s_t-s_r_hat_t;
rp = rp_t-rp_r_hat_t;
R = s*rp;

t_dist = abs(t1-t2);



end



