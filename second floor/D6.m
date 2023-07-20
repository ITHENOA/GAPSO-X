function cs=D6(index,nPar,nDecoder)
switch index
    case {11,21}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0    1
        cs(2,1:6)=[0.1,1,10,2,3,2];    %taw or delta    2
    case {12,22}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0    1
        cs(3,1:6)=[0.1,1,10,2,3,2];   %epsilon  3
        cs(2,1:6)=[0.1,1,10,2,3,2];    %taw or delta    2
    case {13,23}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0    1
        cs(4,1:6)=[0.1,1,10,2,3,2];    %m       4
        cs(2,1:6)=[0.1,1,10,2,3,2];    %taw or delta    2
    case {14,24}
        cs(1,1:6)=[0.1,1,10,2,3,2];    %pm_0    1
        cs(5,1:8)=[1,50,50,4,5,4,2,1];    %Sc   5
        cs(6,1:8)=[1,50,50,4,5,4,2,1];    %Fc   6
        cs(2,1:6)=[0.1,1,10,2,3,2];    %taw or delta    2
    otherwise
        cs=zeros(nPar,4+nDecoder);
end