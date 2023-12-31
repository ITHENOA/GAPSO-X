function randAgain = psoxConfiguration(par,input)
% rng(0)
global itMax best d bound itmaxpso
randAgain=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% general param %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
itMax = itmaxpso;
best = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POP
global finalPopSize particles initialPopSize popTViterations particlesToAdd
global popCS % 0=cte, 1=time-var, 2=incrimental
global pIntitTypeCS2 % 0=Init-random, 1=Init-horizontal
%------------------------------------------------------
if par(1)<3;popcs=par(1);
else; popcs=2;end
popCS = popcs; % $ [0 1 2]
% pop0 1
particles = input(1,1); %  $ 
% pop 1
finalPopSize = input(1,3); % $ [2:200]
initialPopSize = input(1,2); %  $ 
popTViterations = input(1,4); % $ int[0:100]
% pop2
pIntitTypeCS2 = rem(par(1),10); % $ [0 1] (popCS=2)
particlesToAdd = input(1,5); % $ []  topCS=3 time-varing

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
bd = input(3,1); % $ [2 20]    % branching degree
% top5
k_top5 = input(3,2); % $ delete some connections evary k iterations                    
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
rand_cauchy_dnpp = input(2,1); % $ 

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
PMI_cte = input(7,1); % $ [0:1]   
PMR_cte = input(6,1); % $ [0:1]   
% pm2
eI = input(7,2); % $ (0:1]
eR = input(6,3); % $ (0:1]
% pm3
mI = input(7,3);% $ (0:1]
mR = input(6,4); % $ (0:1]
% pm4
ScI = input(7,4); % $ int[1:50]
FcI = input(7,5); % $ int[1:50]
ScR = input(6,5); % $ int[1:50]
FcR = input(6,6); % $ int[1:50]

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
ini_alpha_mtx = input(8,1); % $ int[0:40]
% alp1
sigma_alpha =input(8,2); % $ [0.01:40]
% alp2
z_alpha = input(8,3);  % $ int[1:40]
ro_alpha = input(8,4); % $ [0.01:0.9]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AC(phi) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  AC
global phi1 phi2 phi1Max phi1Min phi2Max phi2Min
global AC_CS % 0=cte, 1=rnd, 2=time-var, 3=extrapolated
% -----------------------
AC_CS = par(5); % $ [0 1 2 3]
% AC0 
phi1 = input(5,1); % $ [0:2.5]
phi2 = input(5,2); % $ [0:2.5]
% AC1
phi1Max = input(5,4); %  $  
phi1Min = input(5,3); %  $ 
phi2Max = input(5,6); %  $ 
phi2Min = input(5,5); %  $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERT-RAND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PRT-R
global taw delta
global prtRndCS % 0=None, 1=rectangular, 2=noisy
% ---------------------
if par(6)==0;prcs=par(6);
else;prcs=floor(par(6)/10);end
prtRndCS = prcs; % $ [0 1 2]
% prtR1
taw  = input(6,2);  % $ [0:1]
% prtR2
delta = input(6,2);  % $ [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  W1
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv
global inertiaW1CS % 0=cte, 1=linear-decreasing, 2=linear-increasing, 3=random, 4=self-regulating, 5=adaptive-based-on-velocity,
% 6=double-exponential-self-adaptive, 7=rank-based, 8=success-based, 9=convergence-based
% -------------------------------------
inertiaW1CS = par(9); % $ [0 1 2 3 4 5 6 7 8 9]
% 0 9
inertia_cte = input(9,1); % $ [0:0.9]
% 124578
w1Max = input(9,3); %  $ [0:0.9]
w1Min = input(9,2); %  $ [0:0.9] 
% 4
nu = input(9,4); %  $ [0.1:1] rho
% 5
lambda_w1_abv = input(9,5); %  $ [0.1:1]
% 9
a_w1_cb = input(9,6); %  $ [0:1] 
b_w1_cb = input(9,7); %  $ [0:1] 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% W2 and W3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  W23
global w2_cte w3_cte
global paramW2CS paramW3CS % 0=w1, 1=rnd, 2=cte
% ------------------------
paramW2CS = par(10); %  $ [0 1 2]
paramW3CS = par(11); %  $ [0 1 2]
% 2
w2_cte = input(10,1); % $  [0:1]
w3_cte = input(11,1); %  $ [0:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%% optional %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
if numel(vmax)==0; error("vmax=[]"); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if bd~=inf && popCS~=0 && bd>initialPopSize; bd=initialPopSize; end

if AC_CS==1
    if phi1Min>phi1Max
        tmp=phi1Min;
        phi1Min=phi1Max;
        phi1Max=tmp;
    end
    if phi2Min>phi2Max
        tmp=phi2Min;
        phi2Min=phi2Max;
        phi2Max=tmp;
    end
    if phi1Min==phi1Max
        phi1Min=.5;
        phi1Max=2.5;
    end
    if phi2Min==phi2Max
        phi2Min=.5;
        phi2Max=2.5;
    end
end


if initialPopSize > finalPopSize ||  (initialPopSize ~= inf && particles < initialPopSize)...
        || (bd~=inf && bd>finalPopSize) || (particlesToAdd~=inf && particlesToAdd>finalPopSize-initialPopSize)...
        || (popCS==1 && (particles<initialPopSize || particles>finalPopSize))
    randAgain=1;
end
