function [ objects ] = clean_single_objects( objects )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

i_to_clean = [];

for i=1:length(objects)
    
    if(length(objects(i).frame) == 1) 
        i_to_clean = [i_to_clean i];
    end 
end

objects(i_to_clean) = [];

end

