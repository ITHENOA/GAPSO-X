function [pop, X, gb] = stagnation_detection(X,gb)
global Aidx it
global mu unstuckCS
if unstuckCS
    for i = Aidx
        if norm(X(i,it+1).v) + norm(gb.pos(end) - X(i,it+1).pos) < mu
            changeIdx{1} = [changeIdx, i];
            X(i,it+1).v = (2 * rand+eps - 1) * mu;
        end
    end
    
    for i = [changeIdx{1}]
        X(i,it+1).pos = boundCheck(X(i,it).pos + X(i,it+1).v, bound);
        % Update Fitness
        X(i,it+1).fit = f(X(i,it+1).pos);
        % Update pop
        pop.v(i,:,it+1) = X(i,it+1).v;
        pop.pos(i,:,it+1) = X(i,it+1).pos;
        pop.fit(i,it+1) = X(i,it+1).fit;
        % update pb
        if X(i,it+1).fit < X(i,it).pb.fit
            X(i,it+1).pb.pos = X(i,it+1).pos;
            X(i,it+1).pb.fit = X(i,it+1).fit;
        else
            X(i,it+1).pb = X(i,it).pb;
        end
        pop.pb.pos(i,:) = X(i,it+1).pb.pos;
        pop.pb.fit(i) = X(i,it+1).pb.fit;
    end
    
    if numel(changeIdx) ~= 0
        [gb.fit(it+1), id] = min(pop.pb.fit);
        gb.pos(it+1,:) = pop.pb.pos(id,:);
    end
end
