function out = isinrange(x,range)

out = prod(x' >= range(:,1) & x' <= range(:,2));