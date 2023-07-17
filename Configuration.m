%

% rng(1)

global itMax f_counter best d

% general
itMax = 100;
f_counter = 0;
best = 1;
ini_vel = 0;

% Benchmark-Function
d = 2; % dimansion 
bound = [-3 3;-4 4];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POP
global finalPopSize particles initialPopSize popTViterations particlesToAdd
global popCS % 0=cte, 1=time-var, 2=incrimental
global pIntitTypeCS2 % 0=Init-random, 1=Init-horizontal
%------------------------------------------------------
popCS = 1; % $ [0 1 2]
% pop01
particles = 20; %  $ 
% pop1
finalPopSize = 100; % $ [2:200]
initialPopSize = 10; %  $ 
popTViterations = 1; % $ int[0:100]
% pop2
pIntitTypeCS2 = 0; % $ [0 1] (popCS=2)
particlesToAdd = 5; % $ []  topCS=3 time-varing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  TOP
global perc_top5_rcdel1 topTime_counter n_iniNei_top3 n_nei_born_top3 k_top5 bd
global topCS % 0=ring, 1=full, 2=von 3=rnd, 4=time-var, 5=hierarchical
global rcdelCS2 % 0=main, 1=percentage
% -----------------------
topCS = 5; % $ [0 1 2 3 4 5]
% top3
n_iniNei_top3 = 1;%cte  number of random neighbor for each particle
n_nei_born_top3 = n_iniNei_top3 + 1;%cte  number of random neighbor for each newborn particle
% top4
bd = 10; % $ [2 20]    % branching degree
% top5
k_top5 = 2; % $ delete some connections evary k iterations                    
rcdelCS2 = 1; % $ [0 1]
topTime_counter = 1;%cte    %(rcdelCS2=0)
perc_top5_rcdel1 = 0.4; %(rcdelCS2=1) remove percentage of allowed connections 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MOI
global moiCS % 0=best, 1=full, 2=rank, 3=rnd
% --------------------
moiCS = 3; % $ [0 1 2 3]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DNPP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global rand_cauchy_dnpp
global dnppCS % 0=rectangular, 1=spherical, 2=standard, 3=gaussian, 4=discrete, 5=cauchy gaussian
% --------------------------
dnppCS = 0; % $ [0 1 2 3 4 5]
rand_cauchy_dnpp = rand;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERT-INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PRT-I
global bt
global prtInfCS % 0=None, 1=gauss, 2=levy, 3=cauchy, 4=uniform 
% -------------------------
prtInfCS = 4; % $ [0 1 2 3 4]   
% prtI5
bt = 1;  % [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PM
global PM_cte e m Sc Fc
global pmCS % 1=cte, 2=euclidean, 3=obj.func, 4=success rate
pmCS = 4; % $ [1 2 3 4]
% pm1
PM_cte = 1; % $ [0:1]   
% pm2
e = 1; % $ (0:1]
% pm3
m = 1; % $ (0:1]
% pm4
Sc = 5; % $ int[1:50]
Fc = 5; % $ int[1:50]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RRM(MTX) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MTX
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha
global MtxCS % 0=None, 1=rnd-diagonal, 2=rnd-linear, 3=exp-map, 4=Eul-rot, 5=Eul-rot_all, 6=increasing-group-based
global alpha_mtxCS2 % => MtxCS  % 0=cte, 1=gauss, 2=adaptive,
% -----------------------------
MtxCS = 3; % $ [0 1 2 3 4 5 6]
alpha_mtxCS2 = 2; % $ [0 1 2]
% alp0
ini_alpha_mtx = 0; % $ int[0:40]
% alp1
sigma_alpha =0.1; % $ [0.01:40]
% alp2
z_alpha = 1; % $ int[1:40]
ro_alpha = 0.1; % $ [0.01:0.9]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AC(phi) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  AC
global phi1 phi2 phi1Max phi1Min phi2Max phi2Min
global AC_CS % 0=cte, 1=rnd, 2=time-var, 3=extrapolated
% -----------------------
AC_CS = 1; % $ [0 1 2 3]
% AC0
phi1 = 1; % $ [0:2.5]
phi2 = 1; % $ [0:2.5]
% AC1
phi1Max = 0; %  $  
phi1Min = 2.5; %  $ 
phi2Max = 0; %  $ 
phi2Min = 2.5; %  $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERT-RAND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PRT-R
global taw delta
global prtRndCS % 0=None, 1=rectangular, 2=noisy
% ---------------------
prtRndCS = 2; % $ [0 1 2]
% prtR1
taw  = 0;  % $ [0:1]
% prtR2
delta = 0;  % $ [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  W1
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv
global inertiaW1CS % 0=cte, 1=linear-decreasing, 2=linear-increasing, 3=random, 4=self-regulating, 5=adaptive-based-on-velocity,
% 6=double-exponential-self-adaptive, 7=rank-based, 8=success-based, 9=convergence-based
% -------------------------------------
inertiaW1CS = 9; % $ [0 1 2 3 4 5 6 7 8 9]
% 0
inertia_cte = .5; % $ [0:0.9]
% 124785
w1Max = .8; %  $ [0:0.9]
w1Min = .1; %  $ [0:0.9] 
% 4
nu = .5; %  $ [0.1:1] rho
% 5
lambda_w1_abv = .5; %  $ [0.1:1]
% 9
a_w1_cb = .5; %  $ [0:1] 
b_w1_cb = .5; %  $ [0:1] 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W2 and W3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  W23
global w2_cte w3_cte
global paramW23CS % 0=w1, 1=rnd, 2=cte
% ------------------------
paramW23CS = 2; %  $ [0 1 2]
% 2
w2_cte = .5; % $  [0:1]
w3_cte = .5; %  $ [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%% unstuc reini %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global vClampCS unstuckCS reInitial
vClampCS = 0;% $ 
unstuckCS = 0;% $ 
reInitial = 0;% $ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vmax = zeros(1,d);
for j = 1:d
    vmax(j) = (bound(j,2) - bound(j,1))/2;
end