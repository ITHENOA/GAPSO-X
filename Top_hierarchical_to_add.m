function tree=Top_hierarchical_to_add(tree)
global bornidx bd
toAdd=length(bornidx);
cap=sum(tree(end,:)==0);
if cap>= toAdd
    counter=0;
    for j=1:bd
        for k=0:bd^(size(tree,1)-2)-1
            if counter>=toAdd;break;end
            if tree(size(tree,1),j+bd*k)==0
                counter=counter+1;
                tree(size(tree,1),j+bd*k)=bornidx(counter);
            end
        end
    end
else
    new_tree=zeros(size(tree,1)+1,bd^(size(tree,1)));
    new_tree(1:size(tree,1),1:size(tree,2))=tree;
    tree=new_tree;
    counter=0;
    for i=size(tree,1)-1:size(tree,1)
        for j=1:bd
            for k=0:bd^(i-2)-1
                if counter>=toAdd;break;end
                if tree(i,j+bd*k)==0
                    counter=counter+1;
                    tree(i,j+bd*k)=bornidx(counter);
                end
            end
        end
    end
end