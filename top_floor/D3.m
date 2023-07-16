function cs=D3(index,nPar,nDecoder)
switch index
    case 6
        cs(1,:)=[2,20,19,3,4,2,1];  %bd
    otherwise
        cs=zeros(nPar,4+nDecoder);
end