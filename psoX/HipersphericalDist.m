function translatedPoints = HipersphericalDist(center,radius,dimensions)

% Generate random points with normal distribution
points = randn(1, dimensions);

% Normalize the points
norms = sqrt(sum(points.^2, 2));
normalizedPoints = points ./ norms;

% Scale the normalized points
scaledPoints = radius * normalizedPoints;

% Translate the points to the center
translatedPoints = scaledPoints + center;

