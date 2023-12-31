function act = bench_func(pos,gb,sizee,bound)
% clear
% clc
global it
% f = @(x) 3.*(1-x(:,1)).^2.*exp(-(x(:,1).^2)-(x(:,2)+1).^2)-10.*(x(:,1)./5-x(:,1).^3-x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2)-1./3.*exp(-(x(:,1)+1).^2-x(:,2).^2);
% bound = [-3 3 ; -4 4];
% bound = [-100 100 ; -100 100];

% n_random_sample = 20;
% x1 = -3 + 6*rand(n_random_sample, 1);
% x2 = -4 + 8*rand(n_random_sample, 1);
% pop = [x1 , x2];
% fit = f(pop);

% clear x1 x2 n_random_sample

%% plot
resolution = 100;
x = zeros(resolution,2);
x(:,1) = linspace(bound(1,1),bound(1,2),resolution);
x(:,2) = linspace(bound(2,1),bound(2,2),resolution);
[X1, X2] = meshgrid(x(:,1), x(:,2));
Z = zeros(size(X1));
for i = 1:numel(X1)
    Z(i) = f([X1(i), X2(i)]);
end
act = min(min(Z));
% 2D
subplot(121); 
contourf(X1, X2, Z);

hold on
scatter(pos(:,1),pos(:,2),'MarkerEdgeColor',...
    'k','MarkerFaceColor',[0.8500 0.3250 0.0980])
title("it = "+num2str(it)+"  (gb = "+num2str(gb(end))+"/"+num2str(act)+")"+"  popSize = "+num2str(sizee))
hold off
% 3D
subplot(122); 
mesh(X1,X2,Z)
hold on
scatter3(pos(:,1),pos(:,2),f(pos),'MarkerEdgeColor',...
    'k','MarkerFaceColor',[0.8500 0.3250 0.0980]);
hold off

% hold on
% scatter(pos(:,1),pos(:,2),'MarkerEdgeColor',...
%     'k','MarkerFaceColor',[0 .75 .75])
% title("it = "+num2str(it)+"  (gb = "+num2str(gb(end))+"/"+num2str(act)+")"+"  popSize = "+num2str(sizee))
% hold off
% % 3D
% subplot(122); 
% mesh(X1,X2,Z)
% hold on
% scatter3(pos(:,1),pos(:,2),f(pos),'MarkerEdgeColor',...
%     'k','MarkerFaceColor',[0 .75 .75]);
% hold off

pause(0.2)