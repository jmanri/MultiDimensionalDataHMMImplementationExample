function datav = normGroup(data, w)
% normGroup - Group-wise normalization with optional weighting
%
% This function normalizes multiple datasets stored in a cell array and
% optionally scales each dataset according to a weighting vector.
% Each dataset is normalized independently to preserve its internal structure,
% while the weight vector controls its relative contribution in the
% concatenated output.
%
% Inputs:
%   data - Cell array of size Mx1, where each cell contains a matrix (NxD)
%          representing a dataset.
%   w    - Weight vector of size Mx1, defining the scaling factor for each
%          dataset.
%
% Output:
%   datav - Matrix containing the normalized and weighted data, concatenated
%           column-wise.
% -------------------------------------------------------------------------
% Author:       Juliana Manrique-Cordoba
% Contact:      jmanrique@umh.es
% ORCID:        0000-0002-0684-8534
% Repository:   https://github.com/jmanri
% Created:      22-Jan-2026 (Updated)
% Reference:    Manrique-Cordoba, J., de la Casa-Lillo, M. Á., & 
%               Sabater-Navarro, J. M. (2025). N-Dimensional Reduction 
%               Algorithm for Learning from Demonstration Path Planning. 
%               Sensors, 25(7), 2145.
%               DOI: https://doi.org/10.3390/s25072145
% -------------------------------------------------------------------------

% **Input validation for 'data'**
if ~iscell(data)
    error('ERROR: input data must be a cell array.');
end

if size(data,2) ~= 1 
    % Ensure that `data` is provided as a column cell array (Mx1)
    data = data';
    if size(data,2) ~= 1
        error('ERROR: input data values must be a cell array of size Mx1 (M: magnitudes)');
    end
end

m = size(data,1); % Number of data groups (M)

% **Verify that all matrices inside 'data' have the same number of rows**
% (i.e., they correspond to the same number of samples)
l = zeros(m,1);     % Vector storing the number of rows of each matrix
n = zeros(m,1);     % Vector storing the number of columns of each matrix

for i = 1:m
    if ~ismatrix(data{i}) || isempty(data{i})
        error('ERROR: Each cell must contain a non-empty matrix.');
    end
    l(i) = size(data{i},1);
    n(i) = size(data{i},2);
end

if any(l ~= l(1))  
    % All datasets must be aligned sample-wise
    error('ERROR: all matrices inside the cell array must have the same number of rows.');
end

% Input validation for 'w' (weight vector)
if ~isvector(w)
    error('ERROR: weight (w) values must be a vector.');
end

if size(w,1) ~= m 
    % Convert row vector to column vector if necessary
    w = w';
end

if size(w,1) ~= m
    error('ERROR: weight (w) values must be a vector of size Mx1.');
end

% Normalization and weighting
% Each dataset is normalized independently using min–max normalization.
% The weight w(i) controls the relative influence of each data group
% in the final concatenated feature matrix.
numCells    = numel(data);          % Number of cells in the cell array
data_norm   = cell(size(data));     % Preallocate cell array for normalized data

for i = 1:numCells
    matrix = double(data{i});  % Convert to double precision for numerical robustness

    % Compute global minimum and maximum of the dataset
    % (normalization is applied per dataset, not per column)
    minVal = min(matrix(:)); 
    maxVal = max(matrix(:));

    % Avoid division by zero when all values in the dataset are identical
    rangeVal = maxVal - minVal;
    if rangeVal == 0
        % If the dataset has no variability, return a zero matrix
        data_norm{i} = zeros(size(matrix), 'double'); % Mantener tipo double
    else
        % Apply min–max normalization followed by scaling using w(i)
        data_norm{i} = ((matrix - minVal) / rangeVal) * w(i); % Escalar por w(i)
    end
end

% Concatenate all normalized datasets column-wise to form the final matrix
datav = cell2mat(data_norm');

end