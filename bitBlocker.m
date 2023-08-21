function prob = bitBlocker(prob,center,bound,resolution,grid)

bit = abs(bound(:,2)-bound(:,1))./resolution';
sigma = ceil(resolution'/10) .* bit;
dim = size(bound,1);

dist = cell(dim);
for i = 1:dim-1
    for j = i+1:dim
        dist1 = exp(-((grid{i,j}' - center(i))/sigma(i)).^2); % Gaussian   X'??
        dist2 = exp(-((grid{j,i}' - center(j))/sigma(j)).^2); % Gaussian   Y'??
        dist{i,j} = dist1 .* dist2;
        prob{i,j} = prob{i,j} - dist{i,j}; 
        prob{i,j}(prob{i,j} < 0) = 0;     
    end
end