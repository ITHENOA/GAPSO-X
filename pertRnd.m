function perted = pertRnd(vector,x,fit,N,pm,gb)
global pertRndCS
global taw delta %(user defined)

switch pertRndCS
    case 0  % None      ok
        perted = vector;

    case 1  % rectangular       ok
        pm = PM(x,fit,N,pm,gb);
        perted = pm * (taw * (1-2*rand));

    case 2  % noisy     ok
        pm = PM(x,fit,N,pm,gb);
        perted = pm * (-delta/2 + rand*delta);
end