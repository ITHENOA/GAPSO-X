clc;clear;close all;
%% parameters
pop_size=55;
p_best=1:pop_size;%rand(1,pop_size);
%% main code
[~,index]=sort(p_best);
bd=3;   %branching degree
size_m=1;
while true
    sum=1;
    for i=1:size_m
        sum=sum+3^i;
    end
    if sum>length(index)
        break;
    end
    size_m=size_m+1;
end
tree=zeros(size_m+1,3^size_m);
counter=0;
for i=1:size_m+1
    for a=1:bd
        if i==2
            for j=1:bd
                counter=counter+1;
                if counter>length(index);break;end
                tree(i,j)=index(counter); 
            end
        else
            for j = a : bd : bd^(i-1) 
                a=a+1;
                counter=counter+1;
                if counter>length(index);break;end
                tree(i,j)=index(counter);
            end
        end
        if i==1 || i==2; break;end
    end
end
N=zeros(length(index),size_m);
for i=1:length(index)
    [row,column]=find(i==tree);
    for j=row:-1:1
        N(i,j)=tree(j,ceil(column/bd));
        column=ceil(column/bd);
    end
end
aa = [0 0 3:size(index,2)];
N=[N aa'];

