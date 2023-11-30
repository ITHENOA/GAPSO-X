function [x, grid, spm] = prepare(bound, res)
% initialize space division, space grid, probability matrix

% INPUT
% bound:    (dimansion,[lowerBound upperBound]): boundary of each dimansion
% res:      (1,dimansion): resolutions of dimansions

% OUTPUT
% x:        (cell) space division for each dimansion: x{dim} = [lb,..., ub] 
%               which length(x{dim}) == resolution(dim)
% grid:     space grid matrix
% spm:      space probability matrix

dim = size(bound,1);
x = cell(1,dim);
for i = 1:dim
    x{i} = linspace(bound(i,1), bound(i,2), res(i));
end

grid = cell(dim);
spm = cell(dim);
for i = 1:dim-1
    for j = i+1:dim
        [grid{i,j},grid{j,i}] = meshgrid(x{i},x{j});
        spm{i,j} = ones(res(i),res(j));
    end
end