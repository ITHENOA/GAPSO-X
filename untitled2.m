mean_value = 1;
variance_value = 2;
scale_factor = 0.5;
num_samples = 1000; % Number of random samples to generate

% Generate random numbers from the Levy distribution
exponential_numbers = exprnd(1, num_samples, 1);
random_numbers = mean_value + scale_factor * sqrt(variance_value ./ (2 * exponential_numbers));

% Plot the histogram of the random numbers
histogram(random_numbers, 'Normalization', 'pdf');
xlabel('Random Number');
ylabel('Probability Density');
title('Levy Distribution');