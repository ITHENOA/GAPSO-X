function Logger(logfile)
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

fprintf(logfile,'PSOX');
fprintf(logfile,'\n******************\n');

fprintf(logfile,' (popCS) => ');
switch popCS
    case 0; fprintf(logfile,'cte'); 
    case 1; fprintf(logfile,'time-var'); 
    case 2; fprintf(logfile,'incrimental '); 
        fprintf(logfile,'{pIntitTypeCS2 = ');
        switch pIntitTypeCS2
            case 0; fprintf(logfile,'Init-random}');
            case 1; fprintf(logfile,'Init-horizontal}');
        end
end

fprintf(logfile,'\n (topCS) => ');
switch topCS
    case 0; fprintf(logfile,'ring'); 
    case 1; fprintf(logfile,'full'); 
    case 2; fprintf(logfile,'von'); 
    case 3; fprintf(logfile,'rnd'); 
    case 4; fprintf(logfile,'hierarchical'); 
    case 5; fprintf(logfile,'time-var '); 
        fprintf(logfile,'{rcdelCS2 = ');
        switch rcdelCS2
            case 0; fprintf(logfile,'main}');
            case 1; fprintf(logfile,'percentage}');
        end
end

fprintf(logfile,'\n (moiCS) => ');
switch moiCS
    case 0; fprintf(logfile,'best'); 
    case 1; fprintf(logfile,'full'); 
    case 2; fprintf(logfile,'rank'); 
    case 3; fprintf(logfile,'rnd'); 
end

fprintf(logfile,'\n (dnppCS) => ');
switch dnppCS
    case 0; fprintf(logfile,'rectangular'); 
    case 1; fprintf(logfile,'spherical'); 
    case 2; fprintf(logfile,'standard'); 
    case 3; fprintf(logfile,'gaussian'); 
    case 4; fprintf(logfile,'discrete');
    case 5; fprintf(logfile,'cauchy gaussian');
end

fprintf(logfile,'\n (prtInfCS) => ');
switch prtInfCS
    case 0; fprintf(logfile,'None'); 
    case 1; fprintf(logfile,'gauss'); 
    case 2; fprintf(logfile,'levy'); 
    case 3; fprintf(logfile,'cauchy'); 
    case 4; fprintf(logfile,'uniform');
end

fprintf(logfile,'\n (pmICS) => ');
switch pmICS
    case 1; fprintf(logfile,'cte'); 
    case 2; fprintf(logfile,'euclidean'); 
    case 3; fprintf(logfile,'obj.func'); 
    case 4; fprintf(logfile,'success-rate'); 
end

fprintf(logfile,'\n (pmRCS) => ');
switch pmRCS
    case 1; fprintf(logfile,'cte'); 
    case 2; fprintf(logfile,'euclidean'); 
    case 3; fprintf(logfile,'obj.func'); 
    case 4; fprintf(logfile,'success-rate');
end

fprintf(logfile,'\n (MtxCS) => ');
switch MtxCS
    case 0; fprintf(logfile,'None'); 
    case 1; fprintf(logfile,'rnd-diagonal'); 
    case 2; fprintf(logfile,'rnd-linear'); 
    case 3; fprintf(logfile,'exp-map '); 
    case 4; fprintf(logfile,'Eul-rot ');
    case 5; fprintf(logfile,'Eul-rot-all ');
    case 6; fprintf(logfile,'increasing-group-based');    
end
if ismember(MtxCS,[3,4,5])
    fprintf(logfile,'{alpha_mtxCS2 = ');
    switch alpha_mtxCS2
        case 0; fprintf(logfile,'cte}');
        case 1; fprintf(logfile,'gauss}');
        case 2; fprintf(logfile,'adaptive}');
    end
end

fprintf(logfile,'\n (AC_CS) => ');
switch AC_CS
    case 0; fprintf(logfile,'cte'); 
    case 1; fprintf(logfile,'rnd'); 
    case 2; fprintf(logfile,'time-var'); 
    case 3; fprintf(logfile,'extrapolated'); 
end

fprintf(logfile,'\n (prtRndCS) => ');
switch prtRndCS
    case 0; fprintf(logfile,'None'); 
    case 1; fprintf(logfile,'rectangular'); 
    case 2; fprintf(logfile,'noisy'); 
end

fprintf(logfile,'\n (inertiaW1CS) => ');
switch inertiaW1CS
    case 0; fprintf(logfile,'cte'); 
    case 1; fprintf(logfile,'linear-decreasing'); 
    case 2; fprintf(logfile,'linear-increasing'); 
    case 3; fprintf(logfile,'random'); 
    case 4; fprintf(logfile,'self-regulating');
    case 5; fprintf(logfile,'adaptive-based-on-velocity');
    case 6; fprintf(logfile,'double-exponential-self-adaptive'); 
    case 7; fprintf(logfile,'ranked-based'); 
    case 8; fprintf(logfile,'success-based'); 
    case 9; fprintf(logfile,'convergence-based');
end

fprintf(logfile,'\n (paramW2CS) => ');
switch paramW2CS
    case 0; fprintf(logfile,'w1'); 
    case 1; fprintf(logfile,'rnd'); 
    case 2; fprintf(logfile,'cte'); 
end
fprintf(logfile,'\n (paramW3CS) => ');
switch paramW3CS
    case 0; fprintf(logfile,'w1'); 
    case 1; fprintf(logfile,'rnd'); 
    case 2; fprintf(logfile,'cte'); 
end
fprintf(logfile,'\n (vClampCS) => ');
switch vClampCS
    case 0; fprintf(logfile,'dont-use'); 
    case 1; fprintf(logfile,'use '); 
        fprintf(logfile,'{vClampCS = ');
        switch vClampCS2
            case 0; fprintf(logfile,'fix-to-boundry}'); 
            case 1; fprintf(logfile,'random-between-bound}'); 
        end      
end

fprintf(logfile,'\n (unstuckCS) => ');
switch unstuckCS
    case 0; fprintf(logfile,'dont-use'); 
    case 1; fprintf(logfile,'use'); 
end

fprintf(logfile,'\n (reInitial) => ');
switch reInitial
    case 0; fprintf(logfile,'dont-use'); 
    case 1; fprintf(logfile,'use'); 
end


fprintf(logfile,'\n----------PARAMs-----------\n');
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
fprintf(logfile,'paramW3CS=%d \nvClampCS=%d \nvClampCS2=%d \nunstuckCS=%d \nreInitial=%d \nvmax=%d \nparamW2CS=%d \n',...
    paramW3CS, vClampCS, vClampCS2, unstuckCS, reInitial, vmax, paramW2CS);