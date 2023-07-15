function updated_tree=Top_hierarchical_update(tree,p_best)
global bd Aidx
Aidx=[Aidx,find(p_best==inf)];

for i=1:size(tree,1)
    for j=1:bd^(i-1)
        if tree(i,j)~=0
            p_best(tree(i,j))=p_best(tree(i,j)==Aidx);
        end
    end
end

updated_tree=zeros(size(tree,1),size(tree,2));
updated_tree(1,1)=tree(1,1);
for i=1:size(tree,1)-1
    for j=1:bd^(i-1)
        value=p_best(updated_tree(i,j));
        index=0;
        for k=1:bd
            if tree(i+1,(j-1)*bd+k)==0
                check_value=inf;
            else
                check_value=p_best(tree(i+1,(j-1)*bd+k));
            end
                if value>check_value
                    value=check_value;
                    index=k;
                end
        end
        if index~=0
            var=updated_tree(i,j);
            updated_tree(i,j)=tree(i+1,(j-1)*bd+index);
            updated_tree(i+1,(j-1)*bd+index)=var;
            [~,not_chosen_index]=find(tree(i+1,(j-1)*bd+(1:bd))~=tree(i+1,(j-1)*bd+index));
            updated_tree(i+1,(j-1)*bd+not_chosen_index)=tree(i+1,(j-1)*bd+not_chosen_index);
        else
            updated_tree(i+1,(j-1)*bd+(1:bd))=tree(i+1,(j-1)*bd+(1:bd));
        end
    end
end
