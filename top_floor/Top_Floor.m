clc;clear;close all;
%% prameters
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
%ga prameters
npop=20;    %number of particels
cr_p=0.5;   %cross over probability
m_p=0.1;    %mutation probability
max_it=100;
%% initialzation
par.pos=zeros(npop,size(component,1),max_it+1);
par.fit=zeros(npop,max_it+1);
component_size=sum(component~=inf,2);
for i=1:npop
    flag=1;
    while true
        for j=1:size(component,1)
            par.pos(i,j,1)=component(j,randi(component_size(j)));
        end
        flag=answer_check(par.pos(i,:,1));
        if flag;    break;  end
    end
    pop.fit(i,1)=second_floor(par.pos(i,:,1));
end