clear; clc; close all
res = 1000
center = 0
bound = [-500 500]
grid  = linspace(bound(1),bound(2),res);

resUsage = 10;
bit = abs(bound(:,2)-bound(:,1))./res';
sigma = ceil(res'/resUsage) .* bit

b = 1

a = abs(bound(:,2)-bound(:,1))/resUsage;
na = 10;
    
% dist = 1./(1+abs((grid-center)/sigma).^(2*b));
% dist2 = exp(-((grid - center)/sigma).^2);
dist = MF('gauss',grid,[center, sigma])
% dist = max(min(min((grid-(center-na*a))/((center-a)-(center-na*a)), 1), ((center+na*a)-grid)/((center+na*a)-(center+a))),0);
% dist = MF('trap',grid,[center-na*a center-a center+a center+na*a]);
plot(grid,dist)
legend
sum(dist>0.99)