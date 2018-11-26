function [S, C, graph] = split_z_components(d_component, d_threshold)

max_dist_between_neighbor_pixels = 1 + d_threshold;

%kernels
k = zeros(2, 3, 3);
k(1,:,:) = [0 -1 0; 0 1 0; 0 0 0]; % cost of going down
k(2,:,:) = [0 0 0; -1 1 0; 0 0 0]; % cost of going right

sz = size(d_component,1)*size(d_component,2);
G = zeros(sz, sz);

% convolve each kernel with dimg to get the cost of going in each direction
% add the costs to a matrix of adjacencies
for i = 1:2
    
    %obtain the cost of each edge with a 2D convolution
    kernel = squeeze(k(i,:,:));
    costs = abs(conv2(d_component, kernel, 'same')) + 1;
    C = sparse(costs); % add 1 to the costs to prevent eliminating 0's
    
    [row1, col1, cost] = find(C);
        
    if i == 1
        col2 = col1;
        row2 = row1 + 1;
    else 
        col2 = col1 + 1;
        row2 = row1;
    end
    
    %eliminate edges that go outside of the image
    for j = length(col2):-1:1
        if(col2(j) > size(d_component,2) || row2(j) > size(d_component,1))
            col2(j) = []; row2(j) = []; col1(j) = []; row1(j) = []; cost(j) = [];
        end
    end
   
    ind1 = sub2ind(size(d_component), row1, col1); % edge start pixel
    ind2 = sub2ind(size(d_component), row2, col2); % edge end pixel
    
    % add edges to the adjacency matrix
    for j = 1:length(ind1)
        G(ind1(j), ind2(j)) = cost(j,1);
        G(ind2(j), ind1(j)) = cost(j,1);
    end
end

%eliminate the edges that have a cost higher than the threshold
accepted_edges = G < max_dist_between_neighbor_pixels;
G = G .* accepted_edges;

graph = sparse(G);

% find the connected components of the graph
[S, C] = graphconncomp(graph);

end
