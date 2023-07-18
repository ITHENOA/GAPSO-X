function fit = f(x)
global f_counter bound d
f_counter = f_counter + 1;
% ff = @(x) 3.*(1-x(:,1)).^2.*exp(-(x(:,1).^2)-(x(:,2)+1).^2)-10.*(x(:,1)./5-x(:,1).^3-x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2)-1./3.*exp(-(x(:,1)+1).^2-x(:,2).^2);
% fit = ff(x);

fit = shifted_rotated_katsuura(x);
bound = [-100 100;-100 100];
d = size(bound,1);

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

function y = shifted_rotated_katsuura(input_matrix)
    % Determine the number of individuals (population size) and dimensions
    [num_individuals, num_dimensions] = size(input_matrix);

    % Define the rotation matrix R (adjust theta for desired rotation angle)
    theta = pi / 6; % 30 degrees rotation
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];

    % Define the shifting values for each dimension
    o = 5 * ones(1, num_dimensions);

    % Initialize the output vector to store function values for each individual
    y = zeros(num_individuals, 1);

    % Evaluate the function for each individual in the population
    for i = 1:num_individuals
        % Shift and rotate the input vector for the current individual
        x_individual = input_matrix(i, :);
        x_shifted_rotated = (x_individual - o) * R;

        % Calculate the function value for the current individual
        inner_sum = 0;
        for j = 1:num_dimensions
            inner_sum = inner_sum + abs(x_shifted_rotated(j) * 2^(-i * (1 + j) / 10));
        end

        y(i) = 1;
        for k = 1:num_dimensions
            y(i) = y(i) * (1 + k * inner_sum);
        end
    end
end
