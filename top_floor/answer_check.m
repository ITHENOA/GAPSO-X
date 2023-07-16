function flag=answer_check(par)
    if par(3)==6 && par(4)==2
        flag=0;    
    elseif par(2)>3 && par(8)~=0
        flag=0;  
    elseif par(2)>10 && rem(par(2),10)~=0 && par(4)~=1
        flag=0;  
    elseif par(5)~=0 && floor(par(2)/10)>20
        flag=0;
    else
        flag=1;
    end
    