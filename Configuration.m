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
pm = ?; % initial pert magnitud     = PM_cte? or user define? or cte? = 1
fit = zeros(popSize,itMax);
w1 = [];

gb.fit %[0:tMix]
gb.pos %[0:tMix]

best = 1;? % global???


pop.fit = ones(finalPopSize,itMax)*inf;     % (popSize, it)
pop.pos = ones(finalPopSize,d,itMax)*inf;   % (popSize, d, it)
v = zeros(finalPopSize,d,itMax);            % (popSize, d, it)

% initialize pop
if popCS ~= 2   % not incrimental
    pop.pos(1:particles,:,1) = ini_pop(particles, bound);
    pop.fit(1:particles,1) = f(pop.pos(1:particles,:,1));
    pop.size(1) = sum(pop.fit(:,1) ~= inf);
else
    pop.pos(1:initialPopSize,:,1) = ini_pop(initialPopSize, bound);
    pop.fit(1:initialPopSize,1) = f(pop.pos(1:initialPopSize,:,1)); 
    pop.size(1) = sum(pop.fit(:,1) ~= inf);
end
% [gb.fit(1), gbidx] = min(pop.fit(:,1));
% gb.pos(1,:) = pop.pos(gbidx,:,1);
% pop sorter
[pop.fit(:,1),idx] = sort(pop.fit(:,1));
pop.pos(:,:,1) = pop.pos(idx,:,1);
% global best
gb.fit(1) = pop.fit(best,1);
gb.pos(1,:) = pop.pos(best,:,1);

N = [];%new ?
% Main 
for it = 2:itMax
    pop = populationCS(pop,bound,gb);   % pop.(fit & pos & size)
    % pop sorter
    [pop.fit(:,it), idx] = sort(pop.fit(:,it));
    pop.pos(:,:,it) = pop.pos(idx,:,it);

    % personal best & global best
    [pb.fit, itOfMin] = min(pop.fit,[],2);
    for i=1:pop.size(it)
        pb.pos(i,:) = pop.pos(i,:,itOfMin(i));
    end
    [gb.fit(it), idx] = min(pb.fit);    %need in AC
    gb.pos(it,:) = bp.pos(idx,:);%pop.pos(idx,:,itOfMin);
    % gb.idx = idx;

    for i=1:finalPopSize
        % x(i).fit
        N=[];%new ?
        % Define the Particle
        [x.pb.fit, pbIdx] = min(pop.fit(i,:));%pb.fit(i); new2
        x.pb.pos = pop.pos(i,:,pbIdx);%pb.pos(i,:); new2
        x.fit = pop.fit(i,it);
        x.pos = pop.pos(i,:,it);
        x.idx = i;%new
        % Neighborhood(N) <== topology
        x.N = TOP(pop,x,d,N);   % x.N.(pos & fit & idx)   % to it badi bayad N in x ro bedim ??? modify MOI and TOP
        x.N.size = numel(x.N.fit);  % x.N.(pos & fit & idx & size)
        [x.N.fit, idx] = sort(x.N.fit); % N.fit sort
        x.N.pos = x.N.pos(idx,:); % N.pos sort
        x.N.idx = x.N.idx(idx,:); % N.idx sort
        % Local best <== N
        x.lb.fit = x.N.fit(best);% [x.lb.fit, idxlb] = min(x.N.fit);
        x.lb.pos = x.N.pos(best,:);% x.lb.pos = x.N.pos(idxlb,:);
        % Influencer(I) <== model of influence
        x.I = MOI(); % x.I.(pos & fit & idx & size | weight)
        [x.I.fit, idx] = sort(x.I.fit); % I.fit sort
        x.I.pos = x.I.pos(idx,:); % I.pos sort
        x.I.idx = x.I.idx(idx,:); % N.idx sort

        x=[];
    end
    % X(it) = x; 
    
end