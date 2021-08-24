%%% Main script for the regulation-detection algorithm %%%

% Copyright (c) 2021, Jonathan P. Tyler
% All rights reserved.

% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

% Make sure that you have adjusted any settings in the
% regulation_detection_inputs file.  In particular, you may choose the
% method you would like to run (linear or fourier).  You can also change
% the threshold value that infers possible regulations.  

% Make sure that you have a data.csv file in the same directory.  The
% data.csv file should be of the form time points as the first column and
% then data values for all components in the subsequent columns. 


% If you choose the linear interpolation method, you should also have extrema
% files for each variable (labeled 1 to the length of variables).  The
% variable numbers should match the ordering in the data.csv file.  The
% files should be named ek.csv where k varies with the variable number (1
% to length of variables).  In each, the first column should be the time
% points at which the maximums and minimums of the data set occur.  Then
% the second column should be a 1 if a maximum occurs at that time point or
% -1 if a minimum occurs atthat time point.  To make these files, you can
% use the findpeaks function in matlab to see all local extrema.  Then, you
% can refine to get the global max and global min for every period.

clear all; close all;

% Load the regulation_detection_inputs

regulation_detection_inputs;

if(strcmp(method, 'linear'))
    
    main_linear;
    
elseif(strcmp(method, 'fourier'))
    
    main_fourier;
    
else
    
    warning('Did not recognize the method chosen.  Running the analysis with the linear interpolation method.')
    
    main_linear;
    
end



