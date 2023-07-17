function value=decoder_S(c)
value=0;
for i=0:length(c)-1
    value=value+c(length(c)-i)*2^i;
end

