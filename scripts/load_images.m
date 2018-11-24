function [ rgbseq, grayseq, dseq ] = load_images( imgseq)
    %LOAD_IMAGES Function responsible for loading images
    %   Reads the imgseq structure, that contains an array with
    %   the names of both the depth images and rgb images
    %   Returns three array sequences, for the rgb sequence,
    %   the gray scale sequence and the depth sequence
    
    % ATTENTION MUST CHANGE
    %seq_size = length(imgseq);
    seq_size = 20;
    rgbseq = zeros(480, 640, 3, seq_size); % array of cubes to put all rgb images
    grayseq = zeros(480, 640, seq_size); % cube to put all gray images
    dseq = zeros(480, 640, seq_size); % cube to put all depth images

    for i = 1:seq_size % iterate all images
        % load rgb
        rgbseq(:,:,:,i) = imread(char(imgseq(i).rgb));
        % load gray scale
        grayseq(:,:,i)=rgb2gray(imread(char(imgseq(i).rgb))); 
        % load depth 
        load(char(imgseq(i).depth));
        dseq(:,:,i) = double(depth_array)/1000;

        % plot the images
%         figure(1);
%         subplot(311); imshow(imread(char(imgseq(i).rgb)));
%         subplot(312); imshow(uint8(grayseq(:,:,i)));
%         subplot(313); imagesc(dseq(:,:,i));
%         colormap(gray);
%     
%         pause(0.1);
    
        % test to remove zeros in depth
        %dseq(:,:,i) = correct_depth(dseq(:,:,i));
    end
    
    
end
