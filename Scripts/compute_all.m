%%%% Compute all times at which the data is equal to the value given %%%%

% Copyright (c) 2021, Jonathan P. Tyler
% All rights reserved.

% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function [s_vals, sp_vals] = compute_all(data,r_value,rcolumn)

% data input should be: column 1-time, column 2-r_data, column 3-s_data

% Separate out the data

try
   
    t_data = data(:,1);
    r_data = data(:,rcolumn);
    
catch
    
    error('Not enough data given.')
    
end

times = [];

for i = 1:length(r_data)-1

    % Ask whether r_value is between the current and next point

    if(r_value> r_data(i) && r_value <= r_data(i+1))

        % Compute the time at which this occurs

        rp = (r_data(i)-r_data(i+1))/(t_data(i)-t_data(i+1));

        t = (r_value-r_data(i))/rp+t_data(i);
      
        times = [times; t i rp];
        
    elseif(r_value< r_data(i) && r_value >= r_data(i+1))
        
        % Compute the time at which this occurs


        rp = (r_data(i)-r_data(i+1))/(t_data(i)-t_data(i+1));

        t = (r_value-r_data(i))/rp+t_data(i);
      
        times = [times; t i rp];
        
    end
end
    
[num_times, ~] = size(times);

[~, data_length] = size(data);

s_vals = zeros(num_times, data_length);
s_vals(:,1) = times(:,1);
s_vals(:,rcolumn) = r_value;
sp_vals = zeros(num_times, data_length);
sp_vals(:,1) = times(:,1);
sp_vals(:,rcolumn) = times(:,3);


for j = 1:num_times
    
    i = times(j,2);
    t = times(j,1);
    
    for k=2:data_length
    
        
        if(k == rcolumn)
            continue;
        else
            
            s_data = data(:,k);
            
            % Compute the s_value at time t

            sp = (s_data(i)-s_data(i+1))/(t_data(i)-t_data(i+1));

            s_value = sp*(t-t_data(i))+s_data(i);

            s_vals(j,k) = s_value;

            sp_vals(j,k) = sp;
        end
    end

end


end


            
            
        
        
