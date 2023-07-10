a=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21]
b{1} = a;
bd=4;
for i = 1:bd
    b{i} = 
end

b(1,1)=a(1)
for i=1:bd
    b(i,2)=a(+)
end

for k=1:bd
    for j=1:bd   
        b(k,3)=a(+)
        k=k+bd;
    end
end

for k=1:bd 
    for l=1:bd
        b(k,4)
        k=k+bd^2;
    end
end

for k=1:bd 
    for l=1:bd
        b(k,5)
        k=k+bd^2;
    end
end


p={};
b="p{1,1}";
bd=3;
k=1;
for s = 1:bd 
    for j = 1:bd
        k=k+1
        c(s,j) = b + "{" +j+ "," +1+ "}"
         % eval("p"+c+"="+cell(1,1));
    end
    b = b + "{" +s+ "," +1+ "}";
end

