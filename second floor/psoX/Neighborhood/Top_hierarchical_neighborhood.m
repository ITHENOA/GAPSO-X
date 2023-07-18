function N=Top_hierarchical_neighborhood(tree,index,bd)
global bd 
[row,column]=find(index==tree);
N=zeros(1,row);
for j=row:-1:1
    N(j)=tree(j,column);
    column=ceil(column/bd);
end