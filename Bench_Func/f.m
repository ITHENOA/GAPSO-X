function fit = f(x)
global f_counter
f_counter = f_counter + 1;
% ff = @(x) 3.*(1-x(:,1)).^2.*exp(-(x(:,1).^2)-(x(:,2)+1).^2)-10.*(x(:,1)./5-x(:,1).^3-x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2)-1./3.*exp(-(x(:,1)+1).^2-x(:,2).^2);
% fit = ff(x);

fit = griewangk(x);
end
function f = griewangk(population)
    % Griewangk's function for a matrix population
    [nParticles, nDimensions] = size(population);
    f = zeros(nParticles, 1);
    
    for i = 1:nParticles
        x = population(i, :);
        sum_sq = sum(x.^2);
        prod_cos = prod(cos(x ./ sqrt(1:nDimensions)));
        f(i) = sum_sq / 4000 - prod_cos + 1;
    end
end

