function output=K2H(par,input)
output=inf(14,4,14);
%components
component=inf(14,14);
component(1,1:4)=[0 1 20 21];  %Pop
component(2,1:6)=[0 1 2 3 4 5];    %DNPP
component(3,1:7)=[0 1 2 3 4 50 51];  %Top
component(4,1:4)=[0 1 2 3];  %MoI
component(5,1:4)=[0 1 2 3];    %AC
component(6,1:9)=[0 11 12 13 14 21 22 23 24];   %PertRand
component(7,1:14)=[0 11 12 13 14 21 22 23 24 31 32 33 34 4];  %PertInfo
component(8,1:13)=[0 1 2 30 31 32 40 41 42 50 51 52 6]; %Mtx
component(9,1:10)=[0 1 2 3 4 5 6 7 8 9];  %W1
component(10,1:3)=[0 1 2];  %W2
component(11,1:3)=[0 1 2];  %W3
component(12,1:2)=[0 1];  %vClampCS
component(13,1:2)=[0 1];  %unstuckCS
component(14,1:2)=[0 ];  %reInitial

for i=setdiff(1:11,4)
    ii=i;
    if i>4;ii=i-1;end
    j=par(i)==component(i,:);
    output(j,:,i)=input(ii,:);
end

