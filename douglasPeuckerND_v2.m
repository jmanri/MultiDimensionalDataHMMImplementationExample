function posreduced = douglasPeuckerND_v2(ptList, tolerance)
% Douglas-Peucker en múltiples dimensiones

n = size(ptList,1);  % Número de puntos
m = size(ptList,2);  % Dimensionalidad

if n <= 2
    posreduced = ptList;
    return;
end

% Puntos inicial y final
A = ptList(1,:);
B = ptList(n,:);

AB = B - A;          % Vector que define la recta
dNode = norm(AB);    % Longitud de la recta

% Verificar que los puntos no sean idénticos
if dNode < 1e-10
    posreduced = A; % Si A == B, no hay simplificación posible
    return;
end

% Distancias perpendiculares de cada punto a la línea AB
d = zeros(n-2,1);  % Inicializar vector de distancias

for k = 2:n-1
    P = ptList(k,:);
    AP = P - A;
    
    % Proyección de AP sobre AB
    proj = dot(AP, AB) / dot(AB, AB) * AB;
    perpVec = AP - proj; % Vector perpendicular a la recta
    
    d(k-1) = norm(perpVec); % Distancia perpendicular
end

% Índice del punto más lejano
[~, farthestIdx] = max(d);
dmax = d(farthestIdx);

if dmax > tolerance
    % División de la lista en dos segmentos y recursión
    recList1 = douglasPeuckerND_v2(ptList(1:farthestIdx+1,:), tolerance);
    recList2 = douglasPeuckerND_v2(ptList(farthestIdx+1:end,:), tolerance);
    
    % Concatenar evitando duplicados
    posreduced = [recList1; recList2(2:end,:)];
else
    posreduced = [A; B]; % Solo se guardan los extremos
end
end