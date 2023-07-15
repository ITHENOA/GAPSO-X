function [xend,fit,i,t] = RS(x0, bound, direction_shrinker, nCompareForStop, maxIterations, tolerance)
% v2
rst = tic;
% Input Controller
if nargin < 1, error('At least 2 input needed.'); end
if nargin < 2, bound = ones(length(x), 1)*[-inf inf]; end
if nargin < 3, direction_shrinker = 1;	end
if nargin < 4, nCompareForStop = 10;	end
if nargin < 5, maxIterations = 50;	end
if nargin < 6, tolerance = 1e-6;	end

% Parameters
n_x = numel(x0);
bias = zeros(1,n_x);  % Bias
x=x0;
X(1,:) = x0;
n=0;
i=0;


% Factors
a = .2;  b = .4;
c = 1;   d = .4;
e = .5;

while true
    i=i+1;
    % Random Vector
    dx = 2*rand(1,n_x)-1 ./ direction_shrinker;  % [-1, 1]   % /50 -> just direction
    % dx = randn(size(x))*(bound(:,1)-bound(:,2))/50
    Xnew = x + bias + dx;
    %%% for specific problem %%%% HW2.3
    Xnew(1:2) = round(Xnew(1:2));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if f(Xnew) < f(x) % Forward
        if ~isinrange(x + bias + dx,bound); i=i-1;continue; end
        x = Xnew;
        bias = a * bias + b * dx;
    else % Backward
        Xnew = x + bias - dx;
        %%% for specific problem %%%% HW2.3
        Xnew(1:2) = round(Xnew(1:2));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if f(Xnew) < f(x)
            if ~isinrange(x + bias - dx,bound); i=i-1;continue; end
            x = Xnew;
            bias = c * bias + d * dx;
        else % Shrink bias
            bias = e * bias;
        end
    end
    X(i+1,:) = x;   % Save current point

    % Stop Condition 1 : Compare many result together
    if i>=nCompareForStop
        for j = 0:nCompareForStop-1
            n = n + norm(X(i+1-j,:)-X(i-j,:));
        end
        if n <tolerance
            % disp('Converged.')
            % fprintf('Iterarion = %d \n',i)
            break
        end
        n=0;
    end
    % Stop Condition 2 : Max Iteration
    if i==maxIterations
        % disp('Reach to Max Iteration.')
        % fprintf('Iterarion = %d \n', maxIterations)
        break
    end
end
% fprintf('Final Optimal = %d', f(X(end,:)))
xend = X(end,:);
fit = f(X(end,:));
t = toc(rst);