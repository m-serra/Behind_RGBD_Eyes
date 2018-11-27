function cc = split_z_components(cc, d_img, d_threshold)
    
    if cc.NumObjects == 0 
        return;
    end
    
    cc_indx = regionprops(cc,'SubarrayIdx'); % gives boxes around the components
    d_img_indx = reshape((1:numel(d_img)), size(d_img));
    max_pixel_dist = 1 + d_threshold;

    % kernels
    k(1,:,:) = [0 -1 0; 0 1 0; 0 0 0]; % cost of going down
    k(2,:,:) = [0 0 0; -1 1 0; 0 0 0]; % cost of going right
    
    for c = length(cc.NumObjects):-1:1
               
        % obtain the component with depth values instead of 1s and 0s
        d_component = d_img( cc_indx(c).SubarrayIdx{1}(1):cc_indx(c).SubarrayIdx{1}(end), ...
                             cc_indx(c).SubarrayIdx{2}(1):cc_indx(c).SubarrayIdx{2}(end));
       
        adj_matrix = zeros(numel(d_component), numel(d_component));

        % convolve each kernel with d_component to get the cost of going in 
        %each direction. Add the costs to a matrix of adjacencies
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
                adj_matrix(ind1(j), ind2(j)) = cost(j,1);
                adj_matrix(ind2(j), ind1(j)) = cost(j,1);
            end
        end

        % eliminate the edges that have a cost higher than the threshold
        accepted_edges = adj_matrix < max_pixel_dist;
        adj_matrix = adj_matrix .* accepted_edges;

        graph = sparse(adj_matrix);

        % find the connected components of the graph
        [S, C] = graphconncomp(graph);
        
        % Finally update the components in cc
        d_component_original_indx = d_img_indx(...
                                     cc_indx(c).SubarrayIdx{1}(1):cc_indx(c).SubarrayIdx{1}(end), ...
                                     cc_indx(c).SubarrayIdx{2}(1):cc_indx(c).SubarrayIdx{2}(end));
        d_component_original_indx = d_component_original_indx(:);
        
        if S > 1
            % Create a new entry in cc.PixelIdxList for each of the new components
            for s = 1:S
                cc.PixelIdxList{cc.NumObjects+1} = d_component_original_indx(C==s);
                cc.NumObjects = cc.NumObjects + 1;
            end
            % Delete the component that was split in several components
            cc.PixelIdxList(c) = [];
            cc.NumObjects = cc.NumObjects - 1;
        end
    end
    
end
