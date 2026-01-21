function decodednorm = normDecode(decoded, maxmin,CB_groups)

m = size(decoded,2);
% % maxi = max(maxmin(1,:));
% % mini = min(maxmin(2,:));
% resta = maxmin(1,:)-maxmin(2,:);
% delta = max(resta);
% %cmax = find(ismember(resta',d1,'rows'));
% %d2 = min(resta);
% %cmin = find(ismember(resta',d2,'rows'));

% Para cada dimensión
% for i=1:1:m
%     %maxi = maxmin(1,cmax);
%     mini = maxmin(2,i);
%     datam = decoded(:,i)+0.5; % llevo el valor a la mitad del
% 
%     %delta = d1; %maxi-mini;
%     mr = delta/CB_groups(i);
% 
%     decodednorm(:,i) = (mini+(datam)*mr)';
%     % decodednorm(:,i) = (minm+(datam)*mr)';
% end

n = 1;
for i=1:1:size(maxmin,2)
    resta = [];

    %
    resta = max(maxmin{i}(1,:))-min(maxmin{i}(2,:));
    delta = resta; %max(resta);
    mini = min(maxmin{i}(2,:));
    %

    
    for c=1:1:size(maxmin{i},2)
        % mini = maxmin{i}(2,c);
        datam = decoded(:,n)+0.5; % llevo el valor a la mitad del
    
        %delta = d1; %maxi-mini;
        mr = delta/CB_groups(n);
        
        decodednorm{i}(:,c) = (mini+(datam)*mr)';
        n = n+1;
    end
end



%figure(3)
% plot(decodednorm(:,1),decodednorm(:,2),'r-')

end