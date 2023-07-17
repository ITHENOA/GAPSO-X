function perted = pertRnd(vector,pm)
global pertRndCS
global taw delta %(user defined)

switch pertRndCS
    case 0  % None --------------------------------------------------------
        perted = vector;

    case 1  % rectangular -------------------------------------------------
        perted = pm * (taw * (1-2*rand));

    case 2  % noisy -------------------------------------------------------
        perted = pm * (-delta/2 + rand*delta);
end