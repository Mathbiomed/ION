%%% Find direction function %%%

function direction = find_direction(values, e, index)

% Inputs: 
% 1. extrema should be a two column matrix.  The first column are the
% time points of the maxes and mins.  The second column is -1 if it is a
% min and 1 if it is a max.  
% 2. values is a vector of time points at which to determine direction.  

% Output:
% 1. direction is a vector of equal length of values that is 1 if it is
% increasing and -1 if it is decreasing at the corresponding time point in
% values.
extrema = e{index};

[r,~] = size(extrema);
l1 = length(values);

% Initialize

if(extrema(1,2) == -1)
    
    d = ones(r+1,1);
    d(1:2:end) = -1;
    
else
    
    d = ones(r+1,1);
    d(2:2:end) = -1;
    
end

% Initialize direction

direction = zeros(l1,1);

for i = 1:l1
    
    v = values(i);
    
    s = 1;
    
    for j = 1:r
        
        if(j==1)
            if(v<extrema(j))
                break;
            end
        elseif(v>extrema(j-1) && v<extrema(j))
            
            break;
            
        end
        
        s = s+1;
        
    end
    
    direction(i) = d(s);
    
end
            
        
        