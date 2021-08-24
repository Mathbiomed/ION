%%% Main Script %%%

% Copyright (c) 2021, Jonathan P. Tyler
% All rights reserved.

% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

% function [L1, L1g] = main

clear rp_data e data

regulation_detection_inputs;

data = load('data.csv');

[~,c] = size(data);

% Make the output directory

if(~exist('Output', 'dir'))
    mkdir('Output');
end

% Plot the data

figure(1)
plot(data(:,1), data(:,2:end), '.-', 'LineWidth', 2, 'MarkerSize', 18)
xlabel('Time', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Abundance', 'FontSize', 18, 'FontWeight', 'bold')
title('Plot of data', 'FontSize', 18, 'FontWeight', 'bold')
legend()
saveas(1, 'Output/data.fig');
close 1

% Load the extrema data

try
    
    for i = 2:c
        
        e{i-1} = load(['e' num2str(i-1) '.csv']);
        
    end
    
catch
    
    error('Error loading the extrema data.  Make sure that you have csv files for the extrema information of each variable in the form ek.csv where k is the variable number.');
    
end

% Estimate the derivative

rp_data(:,1) = data(:,1);

dt = data(2,1)-data(1,1);  % ASSUMES THAT THE DATA MATRIX IS UNIFORMLY SPACED.  NEED TO UPDATE THE CODE TO ALLOW FOR NONUNIFORM TIME POINTS

for i = 2:c
    
    rp_data(:,i) = movingslope(data(:,i), supportlength, 1, dt);
    
end

% Plot the derivative

figure(1)
plot(data(:,1), rp_data(:,2:end), '.-', 'LineWidth', 2, 'MarkerSize', 18)
xlabel('Time', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Derivative of abundance', 'FontSize', 18, 'FontWeight', 'bold')
title('Plot of derivative', 'FontSize', 18, 'FontWeight', 'bold')
legend()
saveas(1, 'Output/derivative.fig');
close 1

% Run the self-regulation analysis for each possible interaction

for i = 2:c
    
    for j = 2:c
        
        if(i == j)
            continue;
        else
            
            R1 = plot_reg_detect_self(i, j, data, rp_data, e);
            

            R_self(i-1,j-1) = R1;
            
            R2 = plot_reg_detect(i, j, data, rp_data, e);
            
            R_trans(i-1,j-1) = R2;
            
        end
        
    end
    
end


% Find the interactions that satisfy the threshold value

R_self_predicted = R_self<-threshold;
R_trans_predicted = R_trans>threshold;
R_trans_predicted = R_trans_predicted+-1*(R_trans<-threshold);

R_predicted = R_self_predicted.*R_trans_predicted;

% Make the graph figure

A1 = R_predicted==1;
A2 = R_predicted==-1;

G1 = digraph(A1');
G2 = digraph(A2');

figure(1)
hold off
f1 = plot(G1, '.b', 'MarkerSize', 16, 'NodeFontSize', 14, 'NodeFontWeight', 'bold', 'LineWidth', 1, 'Layout', 'circle')
hold on
f2 = plot(G2, '.r', 'XData', f1.XData, 'YData', f1.YData, 'MarkerSize', 16, 'NodeFontSize', 14, 'NodeFontWeight', 'bold', 'LineWidth', 1, 'NodeLabel', {})
hold off
saveas(1, 'Output/inferred_network_graph.fig');

% Calculate the P_XtoY values and plot

P = min(-R_self, abs(R_trans));

P(P<0) = 0;

[s1,s2] = size(P);
P = reshape(P, s1*s2,1);

P = sort(P, 'descend');

P = P(1:(end-length(diag(R_self))));

figure(2)
plot(1:length(P), P, 'b.', 'MarkerSize', 14)
hold on
plot([1 length(P)], [threshold threshold], 'r--', 'LineWidth', 1)
hold off
ylim([0 1])
saveas(2, 'Output/P_values.fig')

% Save outputs and publish

save('Output/regulation-detection-scores.mat', 'R_self', 'R_trans', 'threshold', 'R_predicted');

publish('Final_results.m', 'format', 'pdf', 'showCode', false, 'outputDir', 'Output/');

close all
