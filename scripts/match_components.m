function [C] = match_components(frame_components_old, frame_components_new)
%MATCH_COMPONENTS Summary of this function goes here
%   Detailed explanation goes here
    C = zeros(size(frame_components_old,2),size(frame_components_new,2));
    for i=1:size(frame_components_old,2)
        for j=1:size(frame_components_new,2)
            C(i,j) = KLDiv(frame_components_old(i).descriptor(1,:),frame_components_new(j).descriptor(1,:));
        end
    end


end

