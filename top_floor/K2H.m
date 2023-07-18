function output = K2H(par,input)
output=inf(16,4,11);
%components
component=inf(11,16);
component(1,1:4)=[0 1 20 21];  %Pop
component(2,1:10)=[0 1 200 201 210 211 220 221 230 231];    %DNPP
component(3,1:7)=[0 1 2 3 4 5 6];  %Top
component(4,1:3)=[0 1 2];  %MoI
component(5,1:4)=[0 1 2 3];    %AC
component(6,1:11)=[0 11 120 121 13 14 21 220 221 23 24];   %PertRand
component(7,1:16)=[0 11 120 121 13 14 21 220 221 23 24 31 320 321 33 34];  %PertInfo
component(8,1:13)=[0 1 2 30 31 32 40 41 42 50 51 52 6]; %Mtx
component(9,1:10)=[0 1 2 3 11 12 13 14 15 16];  %W1
component(10,1:3)=[0 1 2];  %W2
component(11,1:3)=[0 1 2];  %W3

for i=setdiff(1:11,4)
    ii=i;
    if i>4;ii=i-1;end
    j=par(i)==component(i,:);
    output(j,:,i)=input(ii,:);
end

