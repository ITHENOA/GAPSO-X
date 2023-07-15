
% Components
global topCS % 0=ring, 1=full, 2=von 3=rnd, 4=time-var, 5=hierarchical
global AC_CS % 0=cte, 1=rnd, 2=time-var, 3=extrapolated
global pertInfCS % 0=None, 1=gauss, 2=levy, 3=cauchy, 4=uniform 
global pmCS2 % 1=cte, 2=euclidean, 3=obj.func, 4=success rate
global moiCS % 0=best, 1=full, 2=rank, 3=rnd
global pertRndCS % 0=None, 1=rectangular, 2=noisy
global MtxCS % 0=None, 1=rnd diagonal, 2=rnd linear, 3=exp map, 4=Eul rot, 5=Eul rot_all, 6=increasing group based
global inertiaW1CS % 0=cte, 1=linear decreasing, 2=linear increasing, 3=random, 4=self-regulating, 5=adaptive based on velocity, 6=double exponential self-adaptive, 7=rank-based, 8=success-based, 9=convergence-based
global paramW23CS % 0=w1, 1=rnd, 2=cte
global popCS % 0=cte, 1=time-var, 2=incrimental
global dnppCS % 0=rectangular, 1=spherical, 2=standard, 3=gaussian, 4=discrete, 5=cauchy gaussian
% Components 2
global alpha_mtxCS2 % => MtxCS  % 0=cte, 1=gauss, 2=adaptive,
global pIntitTypeCS2 % => popCS(2)  % 0=Init-random, 1=Init-horizontal
global rcdelCS2 % => topCS(5)  % 0=?, 1=percentage
% General Parameters
global finalPopSize it itMax  
% inipop
global particles initialPopSize
% pop
global popTViterations
% toprcdelCS2
global bd particlesToAdd k_topTime
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


% rng(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% component
popCS = 1%0; % [0 1 2]
pIntitTypeCS2 = 0%0; %[0 1] (popCS=2)
topCS = 3%0; %[0 1 2 3 4 5]
rcdelCS2 = 1; % [0 1] (topCS=5)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% new
moiCS = 1%0; % [0 1 2 3]
pmCS2 = 4%1; % [1 2 3 4]
pertInfCS = 2%randi(5)-1%0; % [0 1 2 3 4]   ta inja
alpha_mtxCS2 = 0%0; % [0 1 2]
MtxCS = 0%0; % [0 1 2 3 4 5 6]
AC_CS = 0%0; %[0 1 2 3]
dnppCS = 0%0; % [0 1 2 3 4 5]
pertRndCS = 0%0; % [0 1 2]
inertiaW1CS = 0%0; % [0 1 2 3 4 5 6 7 8 9]
paramW23CS = 0%0; % [0 1 2]

% general param
finalPopSize = 100%30; % [2:200]
itMax = 100;
% population
popTViterations = 1; %int[0:100]
% TOP parameter
bd = 10; %[2 20]    % branching degree
particlesToAdd = 5; %[]  topCS=3 time-varing
k_topTime = 3;  % delete some connections evary k iterations
% AC param
phi1 = 1; % [0:2.5]
phi2 = 1; % [0:2.5]
phiMax = 0; % [phi1Max, phi2Max] [0:2.5, 0:2.5]
phiMin = 0; % [phi1Min, phi2Min] [0:2.5, 0:2.5]
% PM param
PM_cte = 1; % [0:1] sefr moshkel dare                       pm moshkel date ??
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
w1Max = .8; % [0:0.9]
w1Min = .1; % [0:0.9] 
nu = .5; % [0.1:1] 
a_w1_cb = .5; % [0:1] 
b_w1_cb = .5; % [0:1] 
lambda_w1_abv = .5; % [0.1:1]
% w2, w3
w2_cte = .5; % [0:1]
w3_cte = .5; % [0:1]
% inipop
particles = 20;
initialPopSize = 10;
%%%%%%%%%%%%%%%% cte %%%%%%%%%%%%%%%%%%%
global best d topTime_counter n_iniNei_top3 n_nei_born_top3 f_counter
pm=1; % initial pert magnitud  
w1 = [];
best = 1; % minimization=1, maximization=end ?
d = 2;   % dimansion of benchmark function                                                                  
bound = [-3 3;-4 4];

ini_w1_45 = 0;  % initial w1 for 4=self-regulating and 5=adaptive vel
ini_pm_234born = 1; % initial pm for all exept 1=cte
ini_vel = 0;
n_addToNeighborhood = 5;
topTime_counter = 1;
n_iniNei_top3 = 1;
n_nei_born_top3 = n_iniNei_top3 + 1;
f_counter = 0;

