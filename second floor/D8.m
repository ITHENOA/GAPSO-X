function cs=D8(index,nPar,nDecoder)
switch index
    case {30,40,50}
<<<<<<< Updated upstream
        cs(1,1:8)=[1,40,40,4,5,3,1,1];    %alpha    1
    case {31,41,51}
        cs(2,1:5)=[0.01,40,255,1,8];    %sigma      2
    case {32,42,52}
        cs(1,1:8)=[1,40,40,4,5,3,1,1];    %alpha    1
        cs(3,1:8)=[1,40,40,4,5,3,1,1];    %z        3
        cs(4,1:6)=[0.01,0.9,94,2,6,5];    %ro       4
=======
        cs(1,1:8)=[1,40,40,4,5,3,1,1];    %alpha
    case {31,41,51}
        cs(1,1:5)=[0.01,40,255,1,8];    %sigma
    case {32,42,52}
        cs(1,1:8)=[1,40,40,4,5,3,1,1];    %alpha
        cs(2,1:8)=[1,40,40,4,5,3,1,1];    %z
        cs(3,1:6)=[0.01,0.9,94,2,6,5];    %ro
>>>>>>> Stashed changes
    otherwise
        cs=zeros(nPar,4+nDecoder);
end