function [ background ] = get_background( seq )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% for i=1:size(seq,3)
    background=median(seq,3);   % depth background
    imagesc(background);

% end

