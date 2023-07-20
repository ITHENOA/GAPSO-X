function cs=D10(index,nPar,nDecoder)
switch index
    case 2
        cs(1,:)=[0.01,0.99,97,3,6,5,2];    %w2_0    1
    otherwise
        cs=zeros(nPar,4+nDecoder);
end