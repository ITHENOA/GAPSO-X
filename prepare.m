function grid = prepare(bound,resolution)

dim = size(bound,1);
x = cell(1,dim);
for i = 1:dim
    x{i} = linspace(bound(i,1), bound(i,2), resolution(i));
end

grid = cell(dim);
for i = 1:dim-1
    for j = i+1:dim
        [grid{i,j},grid{j,i}] = meshgrid(x{i},x{j});
    end
end