function posreduced = nDimDPsimplification(ptList, tolerance)
% Multi-dimensional Douglas–Peucker algorithm for point set simplification
%
% This function reduces the number of points in an N-dimensional trajectory
% while preserving its overall geometric shape within a specified tolerance.

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

if dmax > tolerance
    % If the maximum distance exceeds the tolerance, recursively
    % apply the algorithm to the two resulting sub-segments
    recList1 = nDimDPsimplification(ptList(1:farthestIdx+1,:), tolerance);
    recList2 = nDimDPsimplification(ptList(farthestIdx+1:end,:), tolerance);
    
    % Concatenate results while avoiding duplicate points
    posreduced = [recList1; recList2(2:end,:)];
else
    % If all points lie within the tolerance, keep only the endpoints
    posreduced = [A; B]; 
end
end