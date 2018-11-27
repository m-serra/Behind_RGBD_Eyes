function [cc] = get_components( background, img, diff_threshold, filter_size, rgb_img)
%GET_COMPONENTS Function for retrrieving components in a given image
%   This function works as follows:
%   1- subtracts the background image to the current img
%   2- Applies a morphological filter to clean some noise
%   3. Labels the identified components
%   4. Returns connected components
    %figure(1);clf;
    %figure(2);clf;
    
    % Image without background (1: foreground, 0: background)
    imdiff=abs(img-background)>diff_threshold;
    
    % Add depth information to Foreground components
    component_d_vals = imdiff .* img;
    
    % the kinnect is only accurate for distances under 5m
    % remove points at distances over the limit
    % remove points with zero distance
    kinnect_limit = 4.5;
    imdiff = (component_d_vals < kinnect_limit) & (component_d_vals ~= 0);
    
    % To see the frame without background
    %figure (21)
    %imshow(imdiff);
    
    % Looks for connected components and filter
    imgdiffiltered=imopen(imdiff,strel('disk',filter_size));
    
    % Gets connected components info
    cc = bwconncomp(imgdiffiltered);
    
%     for i = 1:cc.NumObjects
%         figure(20+i);
%         plot_component_depth_value_in_rgb_img(img, rgb_img, cc.PixelIdxList{i});
%     end
    
    % MAYBE WE SHOULD SUBSAMPLE HERE TO IMPROVE PERFORMANCE
    % Split different components that might be identified as one                 
     tic
     cc = split_z_components(cc, img, 0.1);
     toc
    
%     for i = 1:cc.NumObjects
%         figure(20+i);
%         plot_component_depth_value_in_rgb_img(img, rgb_img, cc.PixelIdxList{i});
%     end
%     
    % Remove components that are smaller than a number of pixels
    min_component_size = 300; % PASSAR COMO PARAMETRO 
    initial_NumObjects = cc.NumObjects;
    for i = initial_NumObjects:-1:1
        if(length(cc.PixelIdxList{i}) < min_component_size)
            cc.PixelIdxList(i) = []; % eliminates component
            cc.NumObjects = cc.NumObjects -1;
        end
    end
         
%     Differemt components are assgined different colors
     figure(5);
     imagesc(bwlabel(imgdiffiltered));
     title('Connected components');
     
end