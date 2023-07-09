clear;clc
run('Configuration.m')

global topCS inertiaW1CS
global it itMax finalPopSize 
global particles initialPopSize

% f = @(x) 3.*(1-x(:,1)).^2.*exp(-(x(:,1).^2)-(x(:,2)+1).^2)-10.*(x(:,1)./5-x(:,1).^3-x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2)-1./3.*exp(-(x(:,1)+1).^2-x(:,2).^2);
bound = [-3 3;-4 4]; 

%-----------------------------
global deadidx Aidx newidx bornidx
deadidx = [];  % Dead indeces
bornidx = [];
% Aidx : Alive indeces
% newidx : maximum usage of index
saveIdx = zeros(itMax,finalPopSize);                                        
%-----------------------------

%% initialize pop ------------------------------
if popCS ~= 2   % for all 

    pop.pos(1:particles,:,1) = ini_pop(particles, bound);
    pop.fit(1:particles,1) = f(pop.pos(1:particles,:,1));
    [pop.fit(:,1),idx] = sort(pop.fit(:,1));
    pop.pos(:,:,1) = pop.pos(idx,:,1);
    Aidx = 1:particles;
    pop.size(1) = numel(Aidx);
    newidx = particles;
    pop.v(1:particles,:,1) = zeros(particles,d,1);                          

else  % for incrimental  % ??

    pop.pos(1:initialPopSize,:,1) = ini_pop(initialPopSize, bound);
    pop.fit(1:initialPopSize,1) = f(pop.pos(1:initialPopSize,:,1));     
    [pop.fit(:,1),idx] = sort(pop.fit(:,1));
    pop.pos(:,:,1) = pop.pos(idx,:,1);
    Aidx = 1:initialPopSize;
    pop.size(1) = numel(Aidx);
    newidx = initialPopSize;
    pop.v(1:initialPopSize,:,1) = zeros(initialPopSize,d,1);                

end

saveIdx(1,1:numel(Aidx)) = Aidx;

for i=1:pop.size(1)
    X(i,1).pm = 1;
    X(i,1).N.pos = [];
    X(i,1).N.fit = [];
    X(i,1).N.idx = [];
    % if inertiaW1CS==4 || inertiaW1CS==5                                     
    %     X(i,1).w1 =                                                         
    % end
end

% personal best
pb_it.fit = pop.fit(:,1);
pb_it.pos = pop.pos(:,:,1);
% global best
gb.fit(1) = pop.fit(best,1);
gb.pos(1,:) = pop.pos(best,:,1);
gb.idx(1) = best;

% initial Neighborhood
it = 1;
for i = Aidx
    % to hierical momkene N = [] bashe bara bazia
    x.idx = i;
    i;
    X(i,1).N = TOP(pop,x,X(i,1).N);
end

%%  --------------------- Main ----------------------
for it = 1:itMax
    % bornidx = [];
    % deadidx = [];
    % pop = populationCS(pop,bound,gb);   % pop.(fit & pos & size)
    % pop.size(it) = numel(Aidx);
    % 
    % % idx sorter
    % [~, idx] = sort(pop.fit(Aidx,it));
    % Aidx = Aidx(idx);
    % 
    % % personal best & global best
    % [pb_it.fit(Aidx), itOfMin] = min(pop.fit(Aidx,:),[],2);
    % for i=1:numel(Aidx)
    %     pb_it.pos(Aidx(i),:) = pop.pos(Aidx(i),:,itOfMin(i));
    % end
    % [gb.fit(it), idx] = min(pb_it.fit(Aidx));
    % gb.pos(it,:) = pb_it.pos(Aidx(idx),:);
    % gb.idx(it) = Aidx(idx);
    % 
    % % assign bornidxs to other exsited particle's neighbor on this it
    % % according to less neighbor size 
    % if numel(bornidx) ~= 0 && numel(deadidx) == 0
    %     idxs = setdiff(Aidx,bornidx);
    %     % [sorted, id] = sort(X(idxs,it-1).N.size);
    %     for i = 1:numel(bornidx)
    %         for j=1:numel(idxs)
    %             vectosort(j)=X(idxs(j),it-1).N.size
    %         end
    %         [sorted, id] = sort(vectosort);
    %         X(idxs(id(1)),it-1).N.size=X(idxs(id(1)),it-1).N.size+1;
    %         % X(idxs(id(1)),it).N.idx = [X(idxs(id(1)),it-1).N.idx bornidx(i)];
    %         % X(id(check),it).N.pos = pop.pos(X(id(check),it).N.idx,:,it);
    %         % X(id(check),it).N.fit = pop.fit(X(id(check),it).N.idx,it);
    % 
    % 
    %     end
    % end

    for i = Aidx % -------------- particle ------------------
        x.v = pop.v(i,:,it);                                                
        % Define the Particle
        x.pb.fit = pb_it.fit(i); 
        x.pb.pos = pb_it.pos(i,:,it);
        x.fit = pop.fit(i,it);
        x.pos = pop.pos(i,:,it);
        x.idx = i;
        if numel(deadidx) ~= 0  % we have a dead
            if sum(X(i,it-1).N.idx == deadidx) % dead blong i ?
                if numel(bornidx) ~= 0 % we have a born too ?
                    id = find(X(i,it-1).N.idx == deadidx);
                    X(i,it).N.idx(id) = bornidx;
                    X(i,it).N.pos(id,:) = pop.pos(bornidx,:,it);
                    X(i,it).N.fit(id) = pop.fit(bornidx,it);

                else % we dont have a born
                    id = find(X(i,it-1).N.idx == deadidx);
                    X(i,it).N.idx = [X(i,it).N.idx(1:id-1) X(i,it).N.idx(id+1:end)];
                    X(i,it).N.pos = pop.pos(X(i,it).N.idx,:,it);
                    X(i,it).N.fit = pop.fit(X(i,it).N.idx,it);
                    X(i,it).N.size = X(i,it).N.size -1;
                end
            end
        end
        if sum(i==bornidx)
            if topCS == 5
                topCS = 3;
                flag = true;
            end
            x.N = TOP(pop, x, []);
            x.N.size = numel(x.N.idx);  % x.N.(pos & fit & idx & size)
            [x.N.fit, idx] = sort(x.N.fit); % N.fit sort
            x.N.pos = x.N.pos(idx,:); % N.pos sort
            x.N.idx = x.N.idx(idx,:); % N.idx sort
            if flag
                topCS = 5;
                flag = false;
            end
        end




        % Neighborhood(N) <== TOP(pop{fit,pos,size},x{idx},N(i,it-1))
        x.N = TOP(pop, x, X(i,it-1).N);   % x.N.(pos & fit & idx)
        x.N.size = numel(x.N.idx);  % x.N.(pos & fit & idx & size)
        [x.N.fit, idx] = sort(x.N.fit); % N.fit sort
        x.N.pos = x.N.pos(idx,:); % N.pos sort
        x.N.idx = x.N.idx(idx,:); % N.idx sort
        % Local best <== N
        x.lb.fit = x.N.fit(best);
        x.lb.pos = x.N.pos(best,:);
        x.lb.idx = x.N.idx(best);
        % Influencer(I) <== model of influence
        x.I = MOI(x); % x.I.(pos & fit & idx & size | weight)
        [x.I.fit, idx] = sort(x.I.fit); % I.fit sort
        x.I.pos = x.I.pos(idx,:); % I.pos sort
        x.I.idx = x.I.idx(idx,:); % N.idx sort
        x.pm = PM(x, X(i,it-1).pm, gb);
        % if inertiaW1CS==4 || inertiaW1CS==5
        %     x.w1 = inertiaW1(X(i,it-1).w1 ,gb,x,bound,pop,X,saveIdx);
        % elseif inertiaW1CS==4 || inertiaW1CS==5
        %     x.w1 = 
        % end
        X(i,it) = x;
        x=[];
    end
    for i = Aidx % -------------- particle ------------------
        X(i,it).prtInfo = pertInf(pb_it.pos(i,:), X(i,it).pm);
        X(i,it).prtRnd = pertRnd(X(i,it).pos, pm);                          
        X(i,it).phi = AC(X(i,it), gb);
        X(i,it).w1 = inertiaW1(X(i,it-1).w1 ,gb,X(i,it), bound, pop, X, saveIdx); 
        [X(i,it).w2, X(i,it).w3] = param_W23(X(i,it).w1);
        X(i,it).dnpp = DNPP(X(i,it), pop, X(i,it).prtInfo, X(i,it).phi, saveIdx); 
        % update velocity
        X(i,it+1).v = X(i,it).w1 * X(i,it).v + X(i,it).w2 * X(i,it).dnpp + X(i,it).w3 * X(i,it).prtRnd; 
        % update position
        X(i,it+1).pos = X(i,it).pos + X(i,it+1).v;
    end
    pop.pos(Aidx,:,it+1) = X(Aidx,it+1).pos;    
        % biaim tebgh algoritm khodesh berim => akhar berim soragh update
        % pop na aval
    saveIdx(it,1:numel(Aidx)) = Aidx;
end