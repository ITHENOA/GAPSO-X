function perted = pertRnd(vector,pm)
global pertRndCS
global taw delta %(user defined)

switch pertRndCS
    case 0  % None      ok
        perted = vector;

    case 1  % rectangular       ok
        perted = pm * (taw * (1-2*rand));

    case 2  % noisy     ok
        perted = pm * (-delta/2 + rand*delta);
end