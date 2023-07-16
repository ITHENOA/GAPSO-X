function cs=D2(index,nPar,nDecoder)
switch index
    case {230,231}
        cs(1,:)=[0.01,0.99,99,5,6,5,2,1,1];  %r
    otherwise
        cs=zeros(nPar,4+nDecoder);
end