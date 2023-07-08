% Components
global topCS % 0=cte, 1=time-var, 2=hierarchical
global AC_CS % 0=cte, 1=rnd, 2=time-var, 3=extrapolated
global pertInfCS % 0=None, 1=gauss, 2=levy, 3=cauchy, 4=uniform 
global pmCS2 % 1=cte, 2=euclidean, 3=obj.func, 4=success rate
global moiCS % 0=best, 1=full, 2=rank, 3=rnd
global pertRndCS % 0=None, 1=rectangular, 2=noisy
global MtxCS % 0=None, 1=rnd diagonal, 2=rnd linear, 3=exp map, 4=Eul rot, 5=Eul rot_all, 6=increasing group based
global inertiaW1CS % 0=cte, 1=linear decreasing, 2=linear increasing, 3=random, 4=self-regulating, 5=adaptive based on velocity, 6=double exponential self-adaptive, 7=rank-based, 8=success-based, 9=convergence-based
global paramW23CS % 0=w1, 1=rnd, 2=cte
global popCS
global
% General Parameters
global finalPopSize it itMax  
% inipop
global particles initialPopSize
% top
global bd
% AC
global phi1 phi2 phiMax phiMin
% Mtx
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha
% PM
global PM_cte e m Sc Fc
% pertI
global lambda bt
% pertR
global taw delta
% w1
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv
% w2, w3
global w2_cte w3_cte
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% component
pertInfCS = 0; % [0 1 2 3 4]
topCS = 0; %[0 1 2]
pmCS2 = 1; % [1 2 3 4]
moiCS = 0; % [0 1 2 3]
pertRndCS = 0; % [0 1 2]
MtxCS = 0; % [0 1 2 3 4 5 6]
AC_CS = 0; %[0 1 2 3]
inertiaW1CS = 0; % [0 1 2 3 4 5 6 7 8 9]
paramW23CS = 0; % [0 1 2]
% general param
finalPopSize = 100; % [2:200]
itMax = 100;
% TOP parameter
bd = 10; %[2 20]    % branching degree
% AC param
phi1 = 0; % [0:2.5]
phi2 = 0; % [0:2.5]
phiMax = 0; % [phi1Max, phi2Max] [0:2.5, 0:2.5]
phiMin = 0; % [phi1Min, phi2Min] [0:2.5, 0:2.5]
% PM param
PM_cte = 0; % [0:1]
e = 1; % (0:1]
m = 1; % (0:1]
Sc = 5; % int[1:50]
Fc = 5; % int[1:50]
% pert Info param
lambda = 1;  % [1:2]
bt = 1;  % [0:1]
% pert Rand param
taw  = 1;  % [0:1]
delta = 1;  % [0:1]
% Mtx param
ini_alpha_mtx = 0; % int[0:40]
sigma_alpha =0.1; % [0.01:40]
z_alpha = 1; % int[1:40]
ro_alpha = 0.1; % [0.01:0.9]
% w1
inertia_cte = .5; % [0:0.9]
w1Max = .5; % [0:0.9]
w1Min = .5; % [0:.9] 
nu = .5; % [0.1:1] 
a_w1_cb = .5; % [0:1] 
b_w1_cb = .5; % [0:1] 
lambda_w1_abv = .5; % [0.1:1]
% w2, w3
w2_cte = .5; % [0:1]
w3_cte = .5; % [0:1]
%%%%%%%%%%%%%%%% cte %%%%%%%%%%%%%%%%%%%
pm=1; % initial pert magnitud  
w1 = [];

% gb.fit %[0:tMix]
% gb.pos %[0:tMix]

global best d
best = 1; 
d = 3;                                                                      ?

% pop.fit = ones(finalPopSize,itMax)*inf;     % (popSize, it)
% pop.pos = ones(finalPopSize,d,itMax)*inf;   % (popSize, d, it)
% v = zeros(finalPopSize,d,itMax);            % (popSize, d, it)

f = @(x) 3.*(1-x(:,1)).^2.*exp(-(x(:,1).^2)-(x(:,2)+1).^2)-10.*(x(:,1)./5-x(:,1).^3-x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2)-1./3.*exp(-(x(:,1)+1).^2-x(:,2).^2);
bound = [-3 3;-4 4]; 

pop.pos = ones(finalPopSize+itMax,d,itMax)*Inf; % if all it pop+1
pop.fit = ones(finalPopSize+itMax,itMax)*Inf;

%-----------------------------
global Didx Aidx newidx
Didx = [];  % Dead indeces
% Aidx : Alive indeces
% newidx : maximum usage of index
saveIdx = zeros(itMax,finalPopSize);                                        ?
%-----------------------------

%% initialize pop ------------------------------
if popCS ~= 2   % not incrimental

    pop.pos(1:particles,:,1) = ini_pop(particles, bound);
    pop.fit(1:particles,1) = f(pop.pos(1:particles,:,1));
    [pop.fit(:,1),idx] = sort(pop.fit(:,1));
    pop.pos(:,:,1) = pop.pos(idx,:,1);
    Aidx = 1:particles;
    pop.size(1) = numel(Aidx);
    newidx = particles;
    pop.v(1:particles,:,1) = zeros(particles,d,1);                          ?

else

    pop.pos(1:initialPopSize,:,1) = ini_pop(initialPopSize, bound);
    pop.fit(1:initialPopSize,1) = f(pop.pos(1:initialPopSize,:,1));     
    [pop.fit(:,1),idx] = sort(pop.fit(:,1));
    pop.pos(:,:,1) = pop.pos(idx,:,1);
    Aidx = 1:initialPopSize;
    pop.size(1) = numel(Aidx);
    newidx = initialPopSize;
    pop.v(1:initialPopSize,:,1) = zeros(initialPopSize,d,1);                ?

end

saveIdx(1,1:numel(Aidx)) = Aidx; % motmaen sho harbar nemirize ino to eon                ??

for i=1:pop.size
    X(i,1).pm = 1;
    X(i,1).N.pos = [];
    X(i,1).N.fit = [];
    X(i,1).N.idx = [];
    if inertiaW1CS==4 || inertiaW1CS==5                                     ?
        X(i,1).w1 =                                                         ?
    end
end

% initial N for time varing topology    (start from fully??)
it=1;                                                                       ?
if topCS == 5 % timeVar
    topCS = 1; % fully
    for i = 1:pop.size
        X(i,1).N = TOP(pop,[],[]);                                          ?
    end
    topCS = 5; % timeVar
end

% global best
gb.fit(1) = pop.fit(best,1);
gb.pos(1,:) = pop.pos(best,:,1);

%%  --------------------- Main ----------------------
for it = 2:itMax
    pop = populationCS(pop,bound,gb);   % pop.(fit & pos & size)
    pop.size(it) = numel(Aidx);

    % idx sorter
    [~, idx] = sort(pop.fit(Aidx,it));
    Aidx = Aidx(idx);

    % personal best & global best
    pb_it.fit = ones(pop.size(it),1)*inf;
    pb_it.pos = ones(pop.size(it),d)*inf;
    [pb_it.fit(Aidx), itOfMin] = min(pop.fit(Aidx,:),[],2);
    pb_it.pos = pop.pos(Aidx,:,itOfMin);

    [gb.fit(it), idx] = min(pb_it.fit);
    gb.pos(it,:) = bp.pos(idx,:);
    gb.idx = idx;

    

    for i = Aidx % -------------- particle ------------------
        x.v = pop.v(i,:,it);                                                ?
        % Define the Particle
        x.pb.fit = pb_it.fit(i); 
        x.pb.pos = pb_it.pos(i,:);
        x.fit = pop.fit(i,it);
        x.pos = pop.pos(i,:,it);
        x.idx = i;
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
        X(i,it).prtRnd = pertRnd(X(i,it).pos, pm);                          ?
        X(i,it).phi = AC(X(i,it), gb);
        X(i,it).w1 = inertiaW1(X(i,it-1).w1 ,gb,X(i,it), bound, pop, X, saveIdx); ?
        [X(i,it).w2, X(i,it).w3] = param_W23(X(i,it).w1);
        X(i,it).dnpp = DNPP(X(i,it), pop, X(i,it).prtInfo, X(i,it).phi, saveIdx); ?
        % update velocity
        X(i,it+1).v = X(i,it).w1 * X(i,it).v + X(i,it).w2 * X(i,it).dnpp + X(i,it).w2 * X(i,it).prtRnd; ?
        % update position
        X(i,it+1).pos = X(i,it).pos + X(i,it+1).v;  ??????????
    end
    pop.pos(Aidx,:,it+1) = X(Aidx,it+1).pos;    ?????????
        % biaim tebgh algoritm khodesh berim => akhar berim soragh update
        % pop na aval
    saveIdx(it,1:numel(Aidx)) = Aidx;
end