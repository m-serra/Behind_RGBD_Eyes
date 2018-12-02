function cc = split_z_components(cc, d_img, d_threshold)
    
    if cc.NumObjects == 0
        return
    end
   
    cc_indx = regionprops(cc,'SubarrayIdx'); % gives boxes around the components
    d_img_indx = reshape((1:numel(d_img)), size(d_img));
    max_pixel_dist = 1 + d_threshold;

    %kernels
    k(1,:,:) = [0 -1 0; 0 1 0; 0 0 0]; % cost of going down
    k(2,:,:) = [0 0 0; -1 1 0; 0 0 0]; % cost of going right
    k(3,:,:) = [-1 0 0; 0 1 0; 0 0 0]; % cost of going NW-SW diagonal
    k(4,:,:) = [0 0 0; 0 1 0; -1 0 0]; % cost of going SW-NE diagonal
    
    n_components = cc.NumObjects;
    
    for c = n_components:-1:1
               
        % obtain the component in depth values instead of 1s and 0s
        d_component = d_img( cc_indx(c).SubarrayIdx{1}(1):cc_indx(c).SubarrayIdx{1}(end), ...
                             cc_indx(c).SubarrayIdx{2}(1):cc_indx(c).SubarrayIdx{2}(end));
        
        component_size = numel(d_component);
        %adj_matrix = zeros(numel(d_component), numel(d_component));
        costs =zeros(1, 8 * component_size);
        ind1 = zeros(1, 8 * component_size);
        ind2 = zeros(1, 8 * component_size);
        row1 = zeros(1, component_size);
        col1 = zeros(1, component_size);
        row2 = zeros(1, component_size);
        col2 = zeros(1, component_size);
        
        
        % convolve each kernel with d_component to get the cost of going in 
        % each direction. Add the costs to a matrix of adjacencies
        for i = 1:4
            
            init_pos = ((i-1)*component_size)+1;
            
            %obtain the cost of each edge with a 2D convolution
            kernel = squeeze(k(i,:,:));
            costs_matrix = abs(conv2(d_component, kernel, 'same')) + 1;
              
            [row1, col1, costs(init_pos:init_pos+component_size-1)] = find(costs_matrix);

            if i == 1
                col2 = col1;
                row2 = row1 + 1;
            elseif i == 2
                col2 = col1 + 1;
                row2 = row1;
            elseif i == 3
                col2 = col1 + 1;
                row2 = row1 + 1;
            elseif i == 4
                col2 = col1 + 1;
                row2 = row1 - 1;    
            end
            
            % iterate all new edges
            for j = 1:component_size
                if(col2(j) > 0 && row2(j) > 0 ... 
                   && col2(j) <= size(d_component,2) && row2(j) <= size(d_component,1))
 
                    ind1(init_pos+j-1) = sub2ind(size(d_component), row1(j), col1(j)); % edge start pixel
                    ind2(init_pos+j-1) = sub2ind(size(d_component), row2(j), col2(j)); % edge end pixel

                else
                    costs(init_pos+j-1) = 0;
                end
            end
        end
        
        middle_index = length(ind1)/2+1;
        ind1(middle_index:end) = ind2(1:middle_index-1);
        ind2(middle_index:end) = ind1(1:middle_index-1);
        costs(middle_index:end) = costs(1:middle_index-1);
        
        [~,~,vertex1] = find(ind1);
        [~,~,vertex2] = find(ind2);
        [~,~,edges] = find(costs);
        
        %eliminate the edges that have a cost higher than the threshold
        accepted_edges = edges < max_pixel_dist;
        edges = edges .* accepted_edges;
        
        graph = sparse(vertex1, vertex2, edges);

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
