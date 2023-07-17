% function Configuration(par,input)
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
if par(1)<3;popcs=par(1);
else; popcs=2;end
popCS = popcs; % $ [0 1 2]
% pop0 1
particles = input(input(1:2,1,1)~=inf,1,1); %  $ 
% pop 1
checkvec=input(2:4,3,1);
finalPopSize = checkvec(checkvec~=inf); % $ [2:200]
checkvec=[input(2,2,1),input(3,1,1),input(4,1,1)];
initialPopSize = checkvec(checkvec~=inf); %  $ 
popTViterations = input(2,4,1); % $ int[0:100]
% pop2
pIntitTypeCS2 = rem(par(1),10); % $ [0 1] (popCS=2)
particlesToAdd = input(input(3:4,2,1)~=inf,1,1); % $ []  topCS=3 time-varing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  TOP
global perc_top5_rcdel1 topTime_counter n_iniNei_top3 n_nei_born_top3 k_top5 bd
global topCS % 0=ring, 1=full, 2=von 3=rnd, 4=hierarchical, 5=time-var
global rcdelCS2 % 0=main, 1=percentage
% -----------------------
if par(1)<5;topcs=par(1);
else; topcs=5;end
topCS = topcs; % $ [0 1 2 3 4 5]
% top3
n_iniNei_top3 = 1;%cte  number of random neighbor for each particle
n_nei_born_top3 = n_iniNei_top3 + 1;%cte  number of random neighbor for each newborn particle
% top4
bd = input(5,1,3); % $ [2 20]    % branching degree
% top5
k_top5 = input(input(6:7,1,3)~=inf,1,3); % $ delete some connections evary k iterations                    
rcdelCS2 = rem(par(3),10); % $ [0 1]
topTime_counter = 1;%cte    %(rcdelCS2=0)
perc_top5_rcdel1 = 0.4; %(rcdelCS2=1) remove percentage of allowed connections 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MOI
global moiCS % 0=best, 1=full, 2=rank, 3=rnd
% --------------------
moiCS = par(4); % $ [0 1 2 3]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DNPP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global rand_cauchy_dnpp
global dnppCS % 0=rectangular, 1=spherical, 2=standard, 3=gaussian, 4=discrete, 5=cauchy gaussian
% --------------------------
dnppCS = par(2); % $ [0 1 2 3 4 5]
rand_cauchy_dnpp = input(6,1,2); % $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERT-INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PRT-I
global bt
global prtInfCS % 0=None, 1=gauss, 2=levy, 3=cauchy, 4=uniform 
% -------------------------
if par(7)==0 || par(7)==4;pics=par(7);
else;pics=floor(par(7)/10);end
prtInfCS = pics; % $ [0 1 2 3 4]   
% prtI 4
bt = 1;  % [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PM
global PMI_cte eI mI ScI FcI PMR_cte eR mR ScR FcR
global pmICS pmRCS % 1=cte, 2=euclidean, 3=obj.func, 4=success rate
pmICS = rem(par(7),10); % $ [1 2 3 4]
pmRCS = rem(par(6),10); % $ [1 2 3 4]
% pm1
PMI_cte = input(input(:,1,7)~=inf,1,7); % $ [0:1]   
PMR_cte = input(input(:,1,6)~=inf,1,6); % $ [0:1]   
% pm2
checkvec=input(3+(0:2)*4,2,7);
eI = checkvec(checkvec~=inf); % $ (0:1]
checkvec=input(3+(0:2)*4,2,6);
eR = checkvec(checkvec~=inf); % $ (0:1]
% pm3
checkvec=input(4+(0:2)*4,2,7);
mI = checkvec(checkvec~=inf); % $ (0:1]
checkvec=input(4+(0:2)*4,2,6);
mR = checkvec(checkvec~=inf); % $ (0:1]
% pm4
checkvec=input(5+(0:2)*4,2,7);
ScI = checkvec(checkvec~=inf); % $ int[1:50]
checkvec=input(5+(0:2)*4,3,7);
FcI = checkvec(checkvec~=inf); % $ int[1:50]
checkvec=input(5+(0:2)*4,2,6);
ScR = checkvec(checkvec~=inf); % $ int[1:50]
checkvec=input(5+(0:2)*4,3,6);
FcR = checkvec(checkvec~=inf); % $ int[1:50]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RRM(MTX) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MTX
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha
global MtxCS % 0=None, 1=rnd-diagonal, 2=rnd-linear, 3=exp-map, 4=Eul-rot, 5=Eul-rot_all, 6=increasing-group-based
global alpha_mtxCS2 % => MtxCS  % 0=cte, 1=gauss, 2=adaptive,
% -----------------------------
if par(8)==0 || par(8)==1 || par(8)==2 || par(8)==6;mtxcs=par(8);
else;mtxcs=floor(par(8)/10);end
MtxCS = mtxcs; % $ [0 1 2 3 4 5 6]
alpha_mtxCS2 = rem(par(8),10); % $ [0 1 2]
% alp 0 2
checkvec=[input(4+(0:2)*3,1,8) input(6+(0:2)*3,1,8)];
ini_alpha_mtx = checkvec(checkvec~=inf); % $ int[0:40]
% alp1
checkvec=input(5+(0:2)*3,1,8);
sigma_alpha =checkvec(checkvec~=inf); % $ [0.01:40]
% alp2
checkvec=input(6+(0:2)*3,2,8);
z_alpha = checkvec(checkvec~=inf);  % $ int[1:40]
checkvec=input(6+(0:2)*3,3,8);
ro_alpha = checkvec(checkvec~=inf); % $ [0.01:0.9]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AC(phi) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  AC
global phi1 phi2 phi1Max phi1Min phi2Max phi2Min
global AC_CS % 0=cte, 1=rnd, 2=time-var, 3=extrapolated
% -----------------------
AC_CS = par(5); % $ [0 1 2 3]
% AC0 
phi1 = input(1,1,5); % $ [0:2.5]
phi2 = input(1,2,5); % $ [0:2.5]
% AC1
phi1Max = input(2,2,5); %  $  
phi1Min = input(2,1,5); %  $ 
phi2Max = input(2,4,5); %  $ 
phi2Min = input(2,3,5); %  $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERT-RAND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PRT-R
global taw delta
global prtRndCS % 0=None, 1=rectangular, 2=noisy
% ---------------------
if par(6)==0;prcs=par(6);
else;prcs=floor(par(6)/10);end
prtRndCS = prcs; % $ [0 1 2]
% prtR1
checkvec=[input(2+(0:1)*4,2,6) input(3+(0:1)*4,3,6) input(4+(0:1)*4,3,6) input(5+(0:1)*4,4,6)];
taw  = checkvec(checkvec~=inf);  % $ [0:1]
% prtR2
delta = checkvec(checkvec~=inf);  % $ [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  W1
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv
global inertiaW1CS % 0=cte, 1=linear-decreasing, 2=linear-increasing, 3=random, 4=self-regulating, 5=adaptive-based-on-velocity,
% 6=double-exponential-self-adaptive, 7=rank-based, 8=success-based, 9=convergence-based
% -------------------------------------
inertiaW1CS = par(9); % $ [0 1 2 3 4 5 6 7 8 9]
% 0 9
checkvec=[input(1,1,9) input(10,1,9)];
inertia_cte = checkvec(checkvec~=inf); % $ [0:0.9]
% 124578
checkvec=[input(2,1,9) input(3,1,9) input(5,1,9) input(6,1,9) input(8,1,9) input(9,1,9)];
w1Max = checkvec(checkvec~=inf); %  $ [0:0.9]
checkvec=[input(2,2,9) input(3,2,9) input(5,2,9) input(6,2,9) input(8,2,9) input(9,2,9)];
w1Min = checkvec(checkvec~=inf); %  $ [0:0.9] 
% 4
nu = input(5,3,9); %  $ [0.1:1] rho
% 5
lambda_w1_abv = input(6,3,9); %  $ [0.1:1]
% 9
a_w1_cb = input(10,2,9); %  $ [0:1] 
b_w1_cb = input(10,3,9); %  $ [0:1] 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W2 and W3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  W23
global w2_cte w3_cte
global paramW2CS paramW3CS % 0=w1, 1=rnd, 2=cte
% ------------------------
paramW2CS = par(10); %  $ [0 1 2]
paramW3CS = par(11); %  $ [0 1 2]
% 2
w2_cte = input(3,1,10); % $  [0:1]
w3_cte = input(3,1,11); %  $ [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%% unstuc reini %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global vClampCS vClampCS2 unstuckCS reInitial
if par(12)==0;vcs=par(12);
else;vcs=1;end
vClampCS = vcs;% $ 
vClampCS2= rem(par(12),10);
unstuckCS = par(13);% $ 
reInitial = par(14);% $ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global vmax
vmax = zeros(1,d);
for j = 1:d
    vmax(j) = (bound(j,2) - bound(j,1))/2;
end