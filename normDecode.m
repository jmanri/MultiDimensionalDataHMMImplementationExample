function decodednorm = normDecode(decoded, maxmin, CB_groups)
% normDecode - Group-wise inverse normalization with component-wise scaling
%
% This function reconstructs the original scale of data from a normalized
% and concatenated representation. It performs the inverse operation of
% a group-based normalization scheme, using stored minimum and maximum
% reference values for each group and scaling factors for individual components.
%
% Inputs:
%   decoded    - Matrix containing normalized data concatenated across feature groups.
%   maxmin     - Cell array containing reference maximum and minimum values
%                for each data group.
%   CB_groups  - Vector defining a scaling factor for each component,
%                controlling its contribution to the original scale.
%
% Output:
%   decodednorm - Cell array containing the decoded data, rescaled to their
%                 original ranges.
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

numComponents = size(decoded, 2);

if numComponents ~= numel(CB_groups)
    % Consistency checks (do not alter behavior, only prevent silent errors)
    error('ERROR: Length of CB_groups must match number of decoded components.');
end

% Global component index (matches concatenation order)
compIdx = 1;

% Preallocate output cell array
decodednorm = cell(size(maxmin));

% Decode each data group
for i = 1:numel(maxmin)
    
    % Number of components in the current group
    numGroupComp = size(maxmin{i}, 2);
    
    % Compute global range for the current group
    % (design choice: shared range across all components in the group)
    groupMax = max(maxmin{i}(1, :));
    groupMin = min(maxmin{i}(2, :));
    delta    = groupMax - groupMin;
    
    % Preallocate decoded group matrix
    decodednorm{i} = zeros(size(decoded, 1), numGroupComp);
    
    % Decode each component within the group
    for c = 1:numGroupComp
        
        % Shift normalized values from [-0.5, 0.5] to [0, 1]
        datam = decoded(:, compIdx) + 0.5;
        
        % Component-wise scaling factor
        % NOTE: CB_groups is indexed per component, not per group
        scaleFactor = delta / CB_groups(compIdx);
        
        % Reconstruct original scale
        decodednorm{i}(:, c) = groupMin + datam * scaleFactor;
        
        % Advance global component index
        compIdx = compIdx + 1;
    end
end

end