function [] = get_components( background, img, diff_threshold, filter_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    figure(1);clf;
    figure(2);clf;
   
    % Image without background
    imdiff=abs(img-background)>diff_threshold;
    
    % Looks for connected components and filter
    imgdiffiltered=imopen(imdiff,strel('disk',filter_size));
    figure(1);
    imagesc([imdiff imgdiffiltered]);
    title('Difference image and morph filtered');
    colormap(gray);
    
    % Compares previous image with background
    figure(2);
    imagesc([img background]);
    title('Depth image i and background image');
    
    % Differemt components are assgined different colors
    figure(3);
    imagesc(bwlabel(imgdiffiltered));
    title('Connected components');

end

