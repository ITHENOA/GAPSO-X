function connections = connectionsFixer(connections)
while true
    equal = find(connections(1,:) == connections(2,:));
    side = find(abs(connections(1,:) - connections(2,:)) == 1);
    if numel(equal) == 0 && numel(side) == 0; break; end
    connections(:,equal) = connections(randi(size(connections,2),2,numel(equal)));
    connections(:,side) = connections(randi(size(connections,2),2,numel(side)));
    for i = 1:size(connections,2)
        bidir = find(prod(connections(:,i) == connections(2:-1:1,:)));
        if numel(bidir) ~= 0
            connections(:,bidir) = connections(randi(size(connections,2),2,numel(bidir)));
        end
    end
end
