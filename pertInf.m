function perted = pertInf(vector,pm) % ok +2
global pertInfCS
global lambda bt %(user defined)

switch  pertInfCS
    case 0 % None ---------------------------------------------------------
        % disp("prtInfo ==> None")
        perted = vector;

    case 1 % gauss --------------------------------------------------------
        % disp("prtInfo ==> gauss")
        perted = zeros(1,size(vector,2));
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',2,'beta',0,'gam',...
                pm/sqrt(2),'delta',vector(i)));           
        end

    case 2 % levy ---------------------------------------------------------
        % disp("prtInfo ==> levy")
        perted = zeros(1,size(vector,2));
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',lambda,'beta',0,'gam',pm,'delta',pm+vector(i)));
        end

    case 3 % cauchy -------------------------------------------------------
        % disp("prtInfo ==> cauchy")
        perted = zeros(1,size(vector,2));
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',1,'beta',0,'gam',pm,'delta',vector(i)));
        end

    case 4 % uniform ------------------------------------------------------
        % disp("prtInfo ==> uniform")
        s = rand(size(vector)) * (2 * bt) - bt;
        perted = vector + s .* vector;
end
