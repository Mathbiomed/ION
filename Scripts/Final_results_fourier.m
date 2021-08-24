% Copyright (c) 2021, Jonathan P. Tyler
% All rights reserved.

% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

load('Output/regulation-detection-scores.mat')

%% Inferred Network Graph
open('Output/inferred_network_graph.fig')

%% Regulation Detection Scores for Self-Regulation

disp(R_self)

%% Regulation Detection scores for across component interactions (column variable acting on row variable)

disp(R_trans)

%% Open the P values plot

open('Output/P_values.fig')

%% Inferred Interactions

if(sum(abs(R_predicted))==0)
    fprintf('\nNo interactions reached the threshold level specified.')
else

    for i = 1:c-1

        for j = 1:c-1
            
            if(R_predicted(i,j)==-1)

                fprintf('\n%s negatively regulates %s', ['Variable ' num2str(j)], ['Variable ' num2str(i)]);

            elseif(R_predicted(i,j)==1)

                fprintf('\n%s positively regulates %s', ['Variable ' num2str(j)], ['Variable ' num2str(i)]);

            end

        end

    end
    
end

data = load('data.csv');
[~,c] = size(data);

%% Fourier Fits

for i = 2:c
    
    fig_fit = ['Output/Var' num2str(i) '.fig'];

    open(fig_fit)
    
end

%% Regulation detection functions for self-regulations

for i = 2:c

    for j = 2:c
    
        if(i == j)
            continue;
            
        end
        
        open(['Output/Reg_dect_', num2str(i-1), '_onto_', num2str(i-1), '_fix_' num2str(j-1) '.fig']);
        
    end
    
end

%% Regulation detection functions 

for i = 2:c
    
    for j = 2:c
        
        if(i == j) 
            continue;
        end

        open(['Output/Reg_dect_', num2str(j-1), '_onto_', num2str(i-1),'.fig']);
        
    end
    
end

