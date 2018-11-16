% Code by professor João Paulo Costeira - jpcosteira@tecnico.ulisboa.pt
function remove_bg(mode)

    if ( ~strcmp(mode, 'grey') && ~strcmp(mode, 'depth') )
        disp("Show must be either 'grey' or 'depth'");
        return;
    end
    
    d = dir('../img/remove_bg/*.jpg'); % 480x640 rgb images
    dd = dir('../vars/remove_bg/*.mat'); % 480x640 corresponding depth arrays

    imgs = zeros(480, 640, length(d)); % cube to put all rgb images converted to grayscale
    imgsd = zeros(480, 640, length(d)); % cube to put all depth images

    for i = 1:length(d) % iterate all images
        imgs(:,:,i) = rgb2gray(imread(strcat('../img/remove_bg/', d(i).name)));
        load(strcat('../vars/remove_bg/', dd(i).name));
        imgsd(:,:,i) = double(depth_array)/1000;

        % plot the images
        figure(1);
        subplot(211); imshow(uint8(imgs(:,:,i)));
        subplot(212); imagesc(imgsd(:,:,i));
        colormap(gray);

        pause(0.1);
    end

    % the background is given by the median of each pixel across time, both
    % in the color data, the most common color is the background color
    % in the depth data, the most common depth is the background depth
    bgdepth = median(imgsd, 3); 
    bggray = median(imgs, 3);

    figure(1);
    subplot(211);imagesc(bgdepth);
    subplot(212);imagesc(bggray);

    % Bg subtraction for depth (try with gray too)
    figure(1); clf;
    figure(2); clf;
    
    if(strcmp(mode, 'grey'))
       img = imgs;
       bg = bggray;
       diff_threshold = 0.2;
       filter_size = 5;
    elseif( strcmp(mode, 'depth') )
       img = imgsd;
       bg = bgdepth;
       diff_threshold = 0.20;
       filter_size = 5;
    end

    for i = 1:length(d) % iterate all images

        % check if the difference of each pixel and the bg depth is greater
        % than 20 -> obtain a matrix of true and false for each pixel
        imdiff = abs(img(:,:,i) - bg) > diff_threshold;

        % strel -  https://www.mathworks.com/help/images/ref/strel.html
        % I think this is filtering out edges in which the depth varies even
        % being background all the time. It selects areas of imdiff that are 
        % true all inside a circle of radius 5.
        imgdiffiltered = imopen(imdiff, strel('disk', filter_size));

        % plot the two images
        figure(1);
        subplot(211);imagesc(imdiff);
        title('Difference image')
        subplot(212);imagesc(imgdiffiltered);
        title('Morph filtered difference image');
        colormap(gray);

        figure(2);
        subplot(211);imagesc(img(:,:,i));
        title('Depth image i')
        subplot(212);imagesc(bg);
        title('Background image');
        colormap(gray);

        % bwlabel performs the labeling of connected components in a 
        % 2D binary image. We provide amdgdiffiltered, which is
        % 0: if img_depth - bg_depth <= 20
        % 1: if img_depth - bg_depth > 20
        
        % notice that in the grey we can se the shadow of the prof and
        % light changes
        figure(3);
        imagesc(bwlabel(imgdiffiltered));
        title('Connected components');
        pause(4);
    end
end