%%% Main fourier method script %%%


% Load the regulation_detection_inputs

regulation_detection_inputs;

% Save number of fourier coefficients

ffit_n = num_fourier;

% Load the data

try
    data = load('data.csv');
    
catch
    
    error('Error loading the data.');
    
end


mkdir('Output');

% Estimate the period using findpeaks function

per = est_per(data);

if(per == 0)
    
    per = data(end,1);
    
end

% Create the fourier fits of the data using ffit_n number of elements

mkdir('Output/Fourier_fits');
mkdir('Output/Reg_detect_Values');
mkdir('Output/Reg_detect_Figures');


try

    [~,c] = size(data);

    for i = 2:c

        [fitresults, gof] = createFit(data(:,1), data(:,i), per, ffit_n, ['Var' num2str(i)]);

        save(['Output/Var_' num2str(i) '.mat'], 'fitresults', 'gof', 'ffit_n');

    end
    
catch
    
    error('Error making the fourier fits.')
    
end

% Resample the data

new_data = data(1,1):.01:data(end,1);
new_data = reshape(new_data, length(new_data),1);

rp_data = new_data(:,1);

for v1=2:c

    load(['Output/Var_' num2str(v1) '.mat'], 'fitresults')

    f_v1 = fitresults;

    % Take new data based on the fit

    new_data(:,v1) = f_v1(new_data(:,1));

    % Construct the derivatives 
    
    c1 = coeffvalues(f_v1);

    syms x
    
    f_der = 0;
    
    for i = 1:ffit_n
        
        f_der = f_der + i*c1(2*i+1)*c1(end)*cos(i*c1(end)*x) - i*c1(2*i+1)*c1(end)*sin(i*c1(end)*x);
        
    end
    
    f_der = matlabFunction(f_der);
    
    rp_data(:,v1) = f_der(rp_data(:,1));%subs(f_der, x, rp_data(:,1));
    
end

% Run the regulation-detection scripts and save scores

R_self = zeros(c-1, c-1);
R_trans = zeros(c-1,c-1);

for i = 2:c
    
    for j = 2:c
        
        if(i == j)
            continue;
        else
            R1 = plot_reg_detect_self_fourier(i, j, new_data, ffit_n);
            R2 = plot_reg_detect_fourier(i, j, new_data, ffit_n);
            
            R_self(i-1, j-1) = R1;
            R_trans(i-1,j-1) = R2;
            
        end
        
    end
    
end


save('new_data.mat', 'new_data')

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

publish('Final_results_fourier.m', 'format', 'pdf', 'showCode', false, 'outputDir', 'Output/');

close all




