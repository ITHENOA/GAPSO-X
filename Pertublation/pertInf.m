function perted = pertInf(vector,pm) % ok +2
global prtInfCS
global bt %(user defined)

switch  prtInfCS
    case 0 % None ---------------------------------------------------------
        perted = vector;

    case 1 % gauss --------------------------------------------------------
        perted = zeros(1,size(vector,2));
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',2,'beta',0,'gam',...
                pm/sqrt(2),'delta',vector(i)));           
        end

    case 2 % levy ---------------------------------------------------------
        perted = zeros(1,size(vector,2));
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',0.5,'beta',0,'gam',pm,'delta',pm+vector(i)));
        end

    case 3 % cauchy -------------------------------------------------------
        perted = zeros(1,size(vector,2));
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',1,'beta',0,'gam',pm,'delta',vector(i)));
        end

    case 4 % uniform ------------------------------------------------------
        s = rand(size(vector)) * (2 * bt) - bt;
        perted = vector + s .* vector;
end
