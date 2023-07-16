function cs=D8(index,nPar,nDecoder)
switch index
    case {30,40,50}
        cs(1,1:8)=[1,40,40,4,5,3,1,1];    %alpha
    case {31,41,51}
        cs(1,1:5)=[0.01,40,255,1,8];    %sigma
    case {32,42,52}
        cs(1,1:8)=[1,40,40,4,5,3,1,1];    %z
        cs(2,1:6)=[0.01,0.9,94,2,6,5];    %ro
    otherwise
        cs=zeros(nPar,4+nDecoder);
end