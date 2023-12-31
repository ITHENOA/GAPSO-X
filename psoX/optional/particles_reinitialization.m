function  [pop,X,gb] = particles_reinitialization(pop,X,gb,bound)
global d Aidx it reInitial

if reInitial && all(std(pop.pb.pos,1) < 0.001)
    for i = Aidx
        change = false;
        for j = 1:d
            if rand > 1/d
                change = true;
                X(i,it+1).pos(j) = rand * (bound(j,2) - bound(j,1)) + bound(j,1);
            end
        end
        if change
            X(i,it+1).pos = posClamp(X(i,it+1).pos,bound);
            X(i,it+1).fit = f(X(i,it+1).pos);
            pop.pos(i,:,it+1) = X(i,it+1).pos;
            pop.fit(i,it+1) = X(i,it+1).fit;
            if X(i,it+1).fit < X(i,it).pb.fit
                X(i,it+1).pb.pos = X(i,it+1).pos;
                X(i,it+1).pb.fit = X(i,it+1).fit;
            else
                X(i,it+1).pb = X(i,it).pb;
            end
            pop.pb.pos(i,:) = X(i,it+1).pb.pos;
            pop.pb.fit(i) = X(i,it+1).pb.fit;
        end
    end
    [gb.fit(it+1), id] = min(pop.pb.fit);
    gb.pos(it+1,:) = pop.pb.pos(id,:);
end
