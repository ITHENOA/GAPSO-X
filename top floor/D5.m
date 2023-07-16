function cs=D5(index,nPar,nDecoder)
switch index
    case 0
        cs(1,:)=[0.1,2.4,31,1,5];   %phi1
        cs(2,:)=[0.1,2.4,31,1,5];   %phi2
    case 1
        cs(1,:)=[0.1,2.4,31,1,5];   %phi1min
        cs(2,:)=[0.1,2.4,31,1,5];   %phi1max
        cs(1,:)=[0.1,2.4,31,1,5];   %phi2min
        cs(2,:)=[0.1,2.4,31,1,5];   %phi2max
    otherwise
        cs=zeros(nPar,4+nDecoder);
end