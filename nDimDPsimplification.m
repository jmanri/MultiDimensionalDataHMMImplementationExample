function posreduced = nDimDPsimplification(ptList, threshold)
% nDimDPsimplification - N-dimensional Douglas–Peucker trajectory simplification
%
% This function applies a recursive Douglas–Peucker algorithm to an
% N-dimensional point sequence in order to reduce its number of samples
% while preserving the overall structure of the trajectory.
% Points are retained only if their orthogonal distance to the simplified
% representation exceeds a user-defined threshold.
%
% Inputs:
%   ptList    - Matrix of size NxD, where N is the number of points and
%               D is the dimensionality of the space.
%   threshold - Positive scalar defining the maximum admissible deviation
%               between the original trajectory and its simplified version.
%
% Output:
%   posreduced - Matrix containing the reduced set of points, preserving
%                the original ordering of the trajectory.
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

n = size(ptList,1);  % Number of samples (points)
m = size(ptList,2);  % Dimensionality of the data

if n <= 2
    % If the input contains two or fewer points, no simplification is possible
    posreduced = ptList;
    return;
end

% Starting and ending points of the segment
A = ptList(1,:);
B = ptList(n,:);

AB = B - A;          % Vector defining the line segment AB
dNode = norm(AB);    % Length of the segment AB

% Check whether the start and end points are (almost) identical
if dNode < 1e-10
    % If A and B coincide, no meaningful simplification can be performed
    posreduced = A; 
    return;
end

% Perpendicular distances of intermediate points to the line AB
d = zeros(n-2,1);  % Initialize distance vector

for k = 2:n-1
    P = ptList(k,:);
    AP = P - A;
    
    % Projection of AP onto AB
    proj = dot(AP, AB) / dot(AB, AB) * AB;
    perpVec = AP - proj; % Perpendicular vector to the line AB
    
    % Perpendicular distance from point P to the line AB
    d(k-1) = norm(perpVec); 
end

% Index of the point with the maximum perpendicular distance
[~, farthestIdx] = max(d);
dmax = d(farthestIdx);

if dmax > threshold
    % If the maximum distance exceeds the threshold, recursively
    % apply the algorithm to the two resulting sub-segments
    recList1 = nDimDPsimplification(ptList(1:farthestIdx+1,:), threshold);
    recList2 = nDimDPsimplification(ptList(farthestIdx+1:end,:), threshold);
    
    % Concatenate results while avoiding duplicate points
    posreduced = [recList1; recList2(2:end,:)];
else
    % If all points lie within the threshold, keep only the endpoints
    posreduced = [A; B]; 
end
end