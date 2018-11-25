function [ background ] = get_background( seq )
%GET_BACKGROUND Function to calculate the background of a sequence of
%images
%   Receives as argument a image sequence, and calculates the median over
%   time to get the background
    background=median(seq,3);
    %imagesc(uint8(background));
    %imshow(uint8(background));
end

