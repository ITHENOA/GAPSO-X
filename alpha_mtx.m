function alpha = alpha_mtx(d,fit,it)
global alpha_mtxCS2
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha

switch alpha_mtxCS2
    case 0 % cte    ok
        alpha = ini_alpha_mtx;

    case 1 % gauss      ok
        alpha = normrnd(0,sigma_alpha);

    case 2 % adaptive       ok
        ir=sum(fit(:,it)<fit(:,it-1))/size(fit,1);
        sigma_alpha =z_alpha*ir/sqrt(d) +ro_alpha;
end