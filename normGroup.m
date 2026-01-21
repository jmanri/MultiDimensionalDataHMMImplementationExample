function datav = normGroup(data, w)
% normGroup - Normaliza un conjunto de datos almacenados en una celda
%             y escala cada conjunto de datos según un vector de pesos.
%
% Entradas:
%   data - Cell array de tamaño Mx1, donde cada celda contiene una matriz (NxD).
%   w    - Vector de pesos de tamaño Mx1, que define el escalamiento de cada conjunto.
%
% Salidas:
%   datav - Matriz con datos normalizados y escalados, concatenados en columnas.

% **Verificación de la entrada `data`**
if ~iscell(data)
    error('ERROR: input data must be a cell array.');
end

if size(data,2) ~= 1  % Verifica si `data` es un vector columna
    data = data';
    if size(data,2) ~= 1
        error('ERROR: input data values must be a cell array of size Mx1 (M: magnitudes)');
    end
end

m = size(data,1); % Número de celdas (M)


% **Verificar que todas las matrices dentro de `data` tengan la misma cantidad de filas**
l = zeros(m,1); % Vector para almacenar el número de filas de cada matriz
n = zeros(m,1); % Vector para almacenar el número de columnas de cada matriz

for i = 1:m
    if ~ismatrix(data{i}) || isempty(data{i})
        error('ERROR: Each cell must contain a non-empty matrix.');
    end
    l(i) = size(data{i},1);
    n(i) = size(data{i},2);
end

if any(l ~= l(1))  % Si hay diferentes tamaños de filas, error
    error('ERROR: all matrices inside the cell array must have the same number of rows.');
end

% **Verificación de la entrada `w` (vector de pesos)**
if ~isvector(w)
    error('ERROR: weight (w) values must be a vector.');
end

if size(w,1) ~= m  % Si `w` es fila, transponerlo
    w = w';
end

if size(w,1) ~= m
    error('ERROR: weight (w) values must be a vector of size Mx1.');
end


% Normalizar
numCells = numel(data);             % Número de celdas en el vector celda
data_norm = cell(size(data));       % Preasignar celda para datos normalizados

for i = 1:numCells
    matrix = double(data{i});  % Convertir a double para evitar problemas

    % Encontrar el mínimo y máximo de toda la matriz
    minVal = min(matrix(:)); 
    maxVal = max(matrix(:));

    % Evitar división por cero si todos los valores son iguales
    rangeVal = maxVal - minVal;
    if rangeVal == 0
        data_norm{i} = zeros(size(matrix), 'double'); % Mantener tipo double
    else
        data_norm{i} = ((matrix - minVal) / rangeVal) * w(i); % Escalar por w(i)
    end
end

% Convertir la celda en una matriz concatenando columnas
datav = cell2mat(data_norm');

% Convertir la celda en una matriz concatenando fila
% datah = cell2mat(data_norm)';



% for i=1:1:m
%     datam = data{i};                    % extraigo los vectores en cada celda para normalizar por grupos
%     if min(size(datam)) == 1
%         if not(size(datam,2)==1)
%             datam = datam';
%         end
%     end
%     datam = datam - min(datam);         % llevo la magnitud a iniciar en el origen
%     maxdata(i) = max(max(datam));       % calculo el máximo entre todos los máximos de la magnitud
%     mindata(i) = min(min(datam));       % calculo el mínimo entre todos los mínimos de la magnitud
%     delta(i) = maxdata(i)-mindata(i);   % calculo la variación total
% 
%     wm = w(i);
% 
%     mr = wm./delta(i);
% 
%     posnorm{i} = (datam-mindata(i)).*mr;
% end
% 
% datav = [];
% for i=1:1:size(posnorm,2)
%     datav = [datav posnorm{i}];
% end
end