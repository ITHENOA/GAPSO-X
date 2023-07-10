function tothis = cpFields(tothis,copy)
field = fieldnames(copy);
for j = 1:numel(field)
    tothis.(field{j}) = copy.(field{j});
end