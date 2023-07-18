function currentInfo(logfile)
global itMax f_counter d
global finalPopSize particles initialPopSize popTViterations particlesToAdd
global popCS % 0=cte, 1=time-var, 2=incrimental
global pIntitTypeCS2 % 0=Init-random, 1=Init-horizontal
global perc_top5_rcdel1 topTime_counter n_iniNei_top3 n_nei_born_top3 k_top5 bd
global topCS % 0=ring, 1=full, 2=von 3=rnd, 4=hierarchical, 5=time-var
global rcdelCS2 % 0=main, 1=percentage
global moiCS % 0=best, 1=full, 2=rank, 3=rnd
global rand_cauchy_dnpp
global dnppCS % 0=rectangular, 1=spherical, 2=standard, 3=gaussian, 4=discrete, 5=cauchy gaussian
global bt
global prtInfCS % 0=None, 1=gauss, 2=levy, 3=cauchy, 4=uniform 
global PMI_cte eI mI ScI FcI PMR_cte eR mR ScR FcR
global pmICS pmRCS % 1=cte, 2=euclidean, 3=obj.func, 4=success rate
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha
global MtxCS % 0=None, 1=rnd-diagonal, 2=rnd-linear, 3=exp-map, 4=Eul-rot, 5=Eul-rot_all, 6=increasing-group-based
global alpha_mtxCS2 % => MtxCS  % 0=cte, 1=gauss, 2=adaptive,
global phi1 phi2 phi1Max phi1Min phi2Max phi2Min
global AC_CS % 0=cte, 1=rnd, 2=time-var, 3=extrapolated
global taw delta
global prtRndCS % 0=None, 1=rectangular, 2=noisy
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv
global inertiaW1CS % 0=cte, 1=linear-decreasing, 2=linear-increasing, 3=random, 4=self-regulating, 5=adaptive-based-on-velocity,
global w2_cte w3_cte
global paramW2CS paramW3CS % 0=w1, 1=rnd, 2=cte
global vClampCS vClampCS2 unstuckCS reInitial
global vmax
fprintf(logfile,'currentInfo\n---------------------\n');
fprintf(logfile,'f_counter=%d \nitMax=%d \nd=%d \nfinalPopSize=%d \ninitialPopSize=%d \nparticles=%d \npopTViterations=%d \nparticlesToAdd=%d \n',...
    f_counter, itMax, d, finalPopSize, initialPopSize, particles, popTViterations, particlesToAdd);
fprintf(logfile,'popCS=%d \npIntitTypeCS2=%d \nperc_top5_rcdel1=%d \ntopTime_counter=%d \nn_iniNei_top3=%d \nn_nei_born_top3=%d \nk_top5=%d \nbd=%d \n',...
    popCS, pIntitTypeCS2, perc_top5_rcdel1, topTime_counter, n_iniNei_top3, n_nei_born_top3, k_top5, bd);
fprintf(logfile,'topCS=%d \nrcdelCS2=%d \nmoiCS=%d \nrand_cauchy_dnpp=%d \ndnppCS=%d \n',...
    topCS, rcdelCS2, moiCS, rand_cauchy_dnpp, dnppCS);
fprintf(logfile,'topCS=%d \nrcdelCS2=%d \nmoiCS=%d \nrand_cauchy_dnpp=%d \ndnppCS=%d \n',...
    topCS, rcdelCS2, moiCS, rand_cauchy_dnpp, dnppCS);
fprintf(logfile,'bt=%d \nprtInfCS=%d \nPMI_cte=%d \neI=%d \nmI=%d \nScI=%d \nFcI=%d \nPMR_cte=%d \n',...
    bt, prtInfCS, PMI_cte, eI, mI, ScI, FcI, PMR_cte);
fprintf(logfile,'eR=%d \nmR=%d \nScR=%d \nFcR=%d \npmICS=%d \npmRCS=%d \nini_alpha_mtx=%d \nsigma_alpha=%d \n',...
    eR, mR, ScR, FcR, pmICS, pmRCS, ini_alpha_mtx, sigma_alpha);
fprintf(logfile,'z_alpha=%d \nro_alpha=%d \nMtxCS=%d \nalpha_mtxCS2=%d \nphi1=%d \nphi2=%d \nphi1Max=%d \nphi1Min=%d \n',...
    z_alpha, ro_alpha, MtxCS, alpha_mtxCS2, phi1, phi2, phi1Max, phi1Min);
fprintf(logfile,'z_alpha=%d \nro_alpha=%d \nMtxCS=%d \nalpha_mtxCS2=%d \nphi1=%d \nphi2=%d \nphi1Max=%d \nphi1Min=%d \n',...
    z_alpha, ro_alpha, MtxCS, alpha_mtxCS2, phi1, phi2, phi1Max, phi1Min);
fprintf(logfile,'phi2Max=%d \nphi2Min=%d \nAC_CS=%d \ntaw=%d \ndelta=%d \nprtRndCS=%d \ninertia_cte=%d \nw1Max=%d \n',...
    phi2Max, phi2Min, AC_CS, taw, delta, prtRndCS, inertia_cte, w1Max);
fprintf(logfile,'w1Min=%d \nnu=%d \na_w1_cb=%d \nb_w1_cb=%d \nlambda_w1_abv=%d \ninertiaW1CS=%d \nw2_cte=%d \nw3_cte=%d \n',...
    w1Min, nu, a_w1_cb, b_w1_cb, lambda_w1_abv, inertiaW1CS, w2_cte, w3_cte);
fprintf(logfile,'paramW2CS=%d \nparamW3CS=%d \nvClampCS=%d \nvClampCS2=%d \nunstuckCS=%d \nreInitial=%d \nvmax=%d \n',...
    paramW2CS, paramW3CS, vClampCS, vClampCS2, unstuckCS, reInitial, vmax);
