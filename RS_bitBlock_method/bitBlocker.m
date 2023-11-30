function spm = bitBlocker(spm, center, bound, res, grid)
% reduce and block probability around center according to distribution

% INPUT
% spm:          {cell}: space prob matrix
% center:       center of distribution: position of particle
% bound:        (dim,[lb,ub]): boundary
% res:          (1,dimansion): resolutions of dimansions
% grid:         initialized space grid matrix

% OUTPUT
% spm:          updated spm

% PARAMETER
% resUsage:     resolution usage
resUsage = 50;
% b:            increase number of zero in dist(gbell)
% b = 4;
% a:            trapzoidal param increase number of zero in dist(trap)
% a = abs(bound(:,2)-bound(:,1))/resUsage;
% na:           trapzoidal param increase slop in dist(trap)
% na = 2;

bit = abs(bound(:,2)-bound(:,1))./res';
sigma = ceil(res'/resUsage) .* bit;
dim = size(bound,1);

dist = cell(dim);
for i = 1:dim-1
    for j = i+1:dim

        % Gaussian Distribution
        dist1 = exp(-((grid{i,j}' - center(i))/sigma(i)).^2);
        dist2 = exp(-((grid{j,i}' - center(j))/sigma(j)).^2);
        % dist1 = MF('gauss',grid{i,j}',[center(i), sigma(i)]);
        % dist2 = MF('gauss',grid{j,i}',[center(j), sigma(j)]);
        % % Generalized Bell Distribution
        % dist1 = 1/(1+abs((grid{i,j}'-center(i))/sigma(i)).^(2*b));
        % dist2 = 1/(1+abs((grid{j,i}'-center(j))/sigma(j)).^(2*b));
        % dist1 = MF('gbell',grid{i,j},[sigma(i), b, center(i)]);
        % dist2 = MF('gbell',grid{j,i},[sigma(j), b, center(j)]);
        % Trapzoidal Distribution
        % dist1 = MF('trap',grid{i,j}',[center(i)-na*a(i) center(i)-a(i) center(i)+a(i) center(i)+na*a(i)]);
        % dist2 = MF('trap',grid{j,i}',[center(j)-na*a(j) center(j)-a(j) center(j)+a(j) center(j)+na*a(j)]);

        dist{i,j} = dist1 .* dist2;
        spm{i,j} = spm{i,j} - dist{i,j}; 
        spm{i,j}(spm{i,j} < 0) = 0;     
    end
end