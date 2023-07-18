function alpha = alpha_mtx(pop)
global d it repeatedPOP
global alpha_mtxCS2 
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha

switch alpha_mtxCS2
    case 0 % cte ----------------------------------------------------------
        alpha = ini_alpha_mtx;

    case 1 % gauss --------------------------------------------------------
        alpha = normrnd(0, sigma_alpha);

    case 2 % adaptive -----------------------------------------------------
        if it==1
             alpha = ini_alpha_mtx;
        else
            % ir: is the number of improved particles in the last iteration divided by the population size.
            ir = sum([pop.fit(repeatedPOP,it)] < [pop.fit(repeatedPOP,it-1)]) / numel(repeatedPOP);
            sigma_alpha2 = z_alpha * ir/sqrt(d) + ro_alpha;
            alpha = normrnd(0, sigma_alpha2);
        end
end