function cs=D7(index,nPar,nDecoder)
switch index
    case {11,21,31}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0
    case {12,22,32}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0
        cs(2,1:6)=[0.1,1,10,2,3,2];   %epsilon
    case {13,23,33}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0
        cs(2,1:6)=[0.1,1,10,2,3,2];    %m
    case {14,24,34}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0
        cs(2,1:8)=[1,50,50,4,5,4,2,1];    %Sc
        cs(3,1:8)=[1,50,50,4,5,4,2,1];    %Fc
    otherwise
        cs=zeros(nPar,4+nDecoder);
end