% Regulation detection inputs

method = 'linear'; % User-specified method to run the analysis.  Can be 
%                    either 'linear' or 'fourier'.  If 'linear', the method
%                    interpolate the data using a linear interpolation.  If
%                    'fourier', then the method will fit a fourier series
%                    up to the number of coefficients specified below (see num_fourier).  
%                    It will then run the analysis on the fourier fit.  The
%                    fourier method is good if the data is more harmonic in
%                    nature or if there is a lot of noise in the data.  We
%                    suggest comparing the results of both methods if
%                    possible.

threshold = 0.9; % The threshold used to infer direct regulations. 
%                 Must be a number between 0 and 1.  We suggest a default 
%                 threshold of 0.9.

num_fourier = 8; % If the 'fourier' method is chosen above, then this is 
%                  is the number of fourier series coefficients that the
%                  model will fit.  It can take a number between 1 and 8.  

supportlength = 3; % defines the number of
%        points used for the moving window derivative estimation. 
%        supportlength may be no more than the length of vec.
%
%        supportlength must be at least 2, but no more than length(vec).
%        NOTE: a supportlength of 2 will return derivative estimates
%        equivalent to the diff estimate in matlab

modelorder = 1; % Defines the order of the windowed
%        model used to estimate the slope. When model order is 1, the
%        model is a linear one. If modelorder is less than supportlength-1.
%        then the sliding window will be a regression one. If modelorder
%        is equal to supportlength-1, then the window will result in a
%        sliding Lagrange interpolant.
%
%        modelorder must be at least 1, but not exceeding
%        min(10,supportlength-1)





