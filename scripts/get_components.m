function [cc] = get_components( background, img, diff_threshold, filter_size)
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
    
    % eliminate pixels of dimg that don't belong to the foreground
    component_d_vals = imdiff .* img;
    
    % the kinnect is only accurate for distances under 5m
    % remove points at distances over the limit
    kinnect_limit = 4.5;
    imdiff = (component_d_vals < kinnect_limit) & (component_d_vals ~= 0);
    
    % To see the frame without background
    %figure (21)
    %imshow(imdiff);
    
    % Looks for connected components and filter
    imgdiffiltered=imopen(imdiff,strel('disk',filter_size));
    
    % Gets connected components info
    cc = bwconncomp(imgdiffiltered);
    
    % MAYBE WE SHOULD SUBSAMPLE HERE TO IMPROVE PERFORMANCE
    % Split different components that my be identified as one
    %[N C] = split_z_components(cc, d_component, d_threshold);
    
    % Remove components that are smaller than a number of pixels
    min_component_size = 300; 
    initial_NumObjects = cc.NumObjects;
    
    %MELHORAR ISTO TIRANDO O FOR
    for i = initial_NumObjects:-1:1
        if(length(cc.PixelIdxList{i}) < min_component_size)
            cc.PixelIdxList(i) = []; % eliminates component
            cc.NumObjects = cc.NumObjects -1;
        end
    end
    
    % to see only the connected components
    %figure (22)
    %imshow(imgdiffiltered);  
    
%     Looks for connected components and filter
%     figure(1);
%     imagesc([imdiff imgdiffiltered]);
%     title('Difference image and morph filtered');
%     colormap(gray);
    
%     Compares previous image with background
%     figure(2);
%     imagesc([img background]);
%     title('Depth image i and background image');
%     
%     Differemt components are assgined different colors
     figure(5);
     imagesc(bwlabel(imgdiffiltered));
     title('Connected components');
     
end