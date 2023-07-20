function fit = f(x)
global f_counter bound d
f_counter = f_counter + 1;
% ff = @(x) 3.*(1-x(:,1)).^2.*exp(-(x(:,1).^2)-(x(:,2)+1).^2)-10.*(x(:,1)./5-x(:,1).^3-x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2)-1./3.*exp(-(x(:,1)+1).^2-x(:,2).^2);
% fit = ff(x);

fit = benchmark_func(x,9);
bound = [-5 5;-5 5];
d = size(bound,1);

% fit = rosenbrock(x);
% bound = [-6 6;-6 6];
% d = size(bound,1);

% fit = shiftedAckleyFunction(x);
% bound = [-32 32;-32 32];
% d = size(bound,1);

% fit = schwef_f(x);
% bound = [-100 100;-100 100];
% d = size(bound,1);

% fit = griewangk(x);
% bound = [-10 10;-10 10];
% d = size(bound,1);
end
function f = griewangk(population)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

function y = schwef_f(xx)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = size(xx,2);
sum = 0;
for ii = 1:d
	xi = xx(:,ii);
	sum = sum + xi.*sin(sqrt(abs(xi)));
end

y = 418.9829*d - sum;
end

function y = shiftedAckleyFunction(x)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dim = size(x,2);
    a = 20;
    b = 0.2;
    c = 2 * pi;

    sum1 = 0;
    sum2 = 0;
    for i = 1:dim
        sum1 = sum1 + (x(:,i)).^2;
        sum2 = sum2 + cos(c .* (x(:,i)));
    end

    y = -a * exp(-b * sqrt(sum1 / dim)) - exp(sum2 / dim) ;%+ a + exp(1);
end