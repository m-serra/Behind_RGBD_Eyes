function [ rgbseq, dseq ] = load_images( imgseq )
    %LOAD_IMAGES Summary of this function goes here
    %   Detailed explanation goes here
    seq_size = length(imgseq);
    rgbseq = zeros(480, 640, 3, seq_size); % cube to put all rgb images converted to grayscale
    dseq = zeros(480, 640, seq_size); % cube to put all depth images

    for i = 1:seq_size % iterate all images
        % load rgb
        % if nedded, convert string to character vector
        % img_rgb_i = convertStringsToChars(imgseq(i).rgb)  
        % img_d_i = convertStringsToChars(imgseq(i).depth)
        ischar(char(imgseq(i).rgb))
        rgbseq(:,:,:,i) = imread(char(imgseq(i).rgb));
        % load depth 
        load(imgseq(i).depth);
        dseq(:,:,i) = double(depth_array)/1000;

    %     % plot the images
    %     figure(1);
    %     subplot(211); imshow(uint8(imgs(:,:,i)));
    %     subplot(212); imagesc(imgsd(:,:,i));
    %     colormap(gray);
    % 
    %     pause(0.1);
    end

end

