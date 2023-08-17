function result = RS(f, x0, bound, direction_shrinker, nCompareForStop, maxIterations, tolerance)
% v2

    x = x0;
    % Input Controller
    if nargin < 2, error('At least 2 input needed.'); end
    if nargin < 3, bound = ones(length(x), 1)*[-inf inf]; end
    if nargin < 4, direction_shrinker = 1;	end
    if nargin < 5, nCompareForStop = 10;	end
    if nargin < 6, maxIterations = 50;	end
    if nargin < 7, tolerance = 1e-6;	end
    
    % Parameters
    dim = size(bound,1);
    bias = zeros(1,dim);  % Bias
    X(1,:) = x;
    n=0;
    i=0;
    
    % Factors
    a = .2;  b = .4;
    c = 1;   d = .4;
    e = .5;

    while true
        i=i+1;
        % Random Vector
        dx = 2*rand(1,dim)-1 / direction_shrinker;  % [-1, 1]   % /50 -> just direction
        % dx = randn(size(x))*(bound(:,1)-bound(:,2))/50
        Xnew = x + bias + dx;
        fx = f(x);
        fXnew = f(Xnew);
        if fXnew < fx % Forward
            if ~isinrange(x + bias + dx,bound); i=i-1;continue; end
            x = Xnew;
            fx = fXnew;
            bias = a * bias + b * dx;
        else % Backward
            Xnew = x + bias - dx;
            if fXnew < fx
                if ~isinrange(x + bias - dx,bound); i=i-1;continue; end
                x = Xnew;
                fx = fXnew;
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
                disp('Converged.')
                fprintf('Iterarion = %d \n',i)
                break
            end
            n=0;
        end
        % Stop Condition 2 : Max Iteration
        if i==maxIterations
            disp('Reach to Max Iteration.')
            fprintf('Iterarion = %d \n', maxIterations)
            break
        end
    end
    % fprintf('Final Optimal = %d', f(X(end,1), X(end,2)))
    result.pos = X(end,:);
    result.fit = fx;
