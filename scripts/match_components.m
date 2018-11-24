function [C] = match_components(frame_components_old, frame_components_new)
%MATCH_COMPONENTS Summary of this function goes here
%   Detailed explanation goes here

    C = zeros(size(frame_components_old,2),size(frame_components_new,2));
    for i=1:size(frame_components_old,2)
        for j=1:size(frame_components_new,2)
            C(i,j) = KLDiv(frame_components_old(i).descriptor(1,:),frame_components_new(j).descriptor(1,:));
        end
    end
    
    % Hungarian algorithm to find the best component assigment
    assignment = munkres(C);
    
    % to define
    threshold_hungarian = 0.2;
    
    for i=1:length(assignment)
           
        % meter caso de o assignment dar 0 (linha ou coluna toda a
        % infinitos)
        % ----
        
        % if the component in the first frame doesn't belong to a component
        % in the next frame (associated to a low cost value)
        if( C(i,assignment(i) < threshold_hungarian)
            % insert the component in the new_objects and it wont be used
            % in the next frame
            % TODO
            
        else
           % add the component frame and coordinates from frame old to
           % frame new of the correspondent matching component
           % TODO
            
        end
    end

end

