function output=decoder_C(cs,c)
index=0;
start=1;
for i=1:cs(4)
    stop=sum(cs(5:4+i));
    index=index+decoder_S(c(start:stop));
    start=stop+1;
end
vec=linspace(cs(1),cs(2),cs(3));
output=vec(index);
end