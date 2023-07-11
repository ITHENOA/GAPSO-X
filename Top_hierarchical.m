clc;clear;close all;
%% parameters
pop_size=39;
p_best=rand(1,pop_size);
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
    for j=1:bd^(i-1)
        counter=counter+1;
        if counter>length(index);break;end
        tree(i,j)=index(counter);
    end
end
N=zeros(length(index),size_m);
for i=1:length(index)
    [row,column]=find(i==tree);
    for j=row-1:-1:1
        N(i,j)=ceil(column/bd);
        column=ceil(column/bd);
    end
end