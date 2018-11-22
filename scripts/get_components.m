function [cc] = get_components( background, img, diff_threshold, filter_size)
%GET_COMPONENTS Function for retrrieving components in a given image
%   This function works as follows:
%   1- subtracts the background image to the current img
%   2- Applies a morphological filter to clean some noise
%   3. Labels the identified components
%   4. Returns connected components
    %figure(1);clf;
    %figure(2);clf;
   
    % Image without background
    imdiff=abs(img-background)>diff_threshold;
    
    % Looks for connected components and filter
    imgdiffiltered=imopen(imdiff,strel('disk',filter_size));
    
    % Gets connected components info
    cc = bwconncomp(imgdiffiltered);
    
    figure (21)
    imshow(imgdiffiltered);
    figure (22)
    imshow(imdiff);
    
    
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