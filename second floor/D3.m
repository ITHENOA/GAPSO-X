function cs=D3(index,nPar,nDecoder)
switch index
    case 4
        cs(1,:)=[2,20,19,3,4,2,1];  %bd     1
    case {50,51}
        cs(2,:)=[2,8,7,1,3];    %k      2
    otherwise
        cs=zeros(nPar,4+nDecoder);
end