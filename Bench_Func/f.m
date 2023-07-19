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

function y = schwef_f(xx)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SCHWEFEL FUNCTION
%
% Authors: Sonja Surjanovic, Simon Fraser University
%          Derek Bingham, Simon Fraser University
% Questions/Comments: Please email Derek Bingham at dbingham@stat.sfu.ca.
%
% Copyright 2013. Derek Bingham, Simon Fraser University.
%
% THERE IS NO WARRANTY, EXPRESS OR IMPLIED. WE DO NOT ASSUME ANY LIABILITY
% FOR THE USE OF THIS SOFTWARE.  If software is modified to produce
% derivative works, such modified software should be clearly marked.
% Additionally, this program is free software; you can redistribute it 
% and/or modify it under the terms of the GNU General Public License as 
% published by the Free Software Foundation; version 2.0 of the License. 
% Accordingly, this program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
% General Public License for more details.
%
% For function details and reference information, see:
% http://www.sfu.ca/~ssurjano/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT:
%
% xx = [x1, x2, ..., xd]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = size(xx,2);
sum = 0;
for ii = 1:d
	xi = xx(:,ii);
	sum = sum + xi.*sin(sqrt(abs(xi)));
end

y = 418.9829*d - sum;
end

function y = shiftedAckleyFunction(x)
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

function y=rosenbrock(x)
y=100 * (x(:,1).^2 + x(:,2)).^2 + (x(:,1)-1).^2;
end

