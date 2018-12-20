function [new_objects, frame_components_old] = match_components(frame_components_old, frame_components_new)
%MATCH_COMPONENTS Summary of this function goes here
%   Detailed explanation goes here


    % weights
    distance_weight = 0.7;
    colour_weight = 0.3;
    new_objects = struct( 'frame',cell(1,1), ...
                                   'X',cell(1,1), ...
                                   'Y',cell(1,1), ... 
                                   'Z',cell(1,1));
    C = zeros(size(frame_components_old,2),size(frame_components_new,2));
    for i=1:size(frame_components_old,2)
        for j=1:size(frame_components_new,2)
            distance_cost = norm(frame_components_old(i).descriptor{1} - frame_components_new(j).descriptor{1});
            colour_cost = KLDiv(frame_components_old(i).descriptor{2}(1,:),frame_components_new(j).descriptor{2}(1,:));
            C(i,j) = distance_weight*distance_cost + colour_weight*colour_cost;
        end
    end
    
    % Hungarian algorithm to find the best component assigment
    assignment = munkres(C);
    
    % to define
    threshold_hungarian = 1.0;
    
    new_objects_count = 0;
    for i=1:length(assignment)
       
        
        % if the component in the first frame doesn't belong to a component
        % in the next frame (associated to a low cost value)
        if (assignment(i) == 0 || C(i,assignment(i)) > threshold_hungarian)
            new_objects_count = new_objects_count + 1;
            new_objects(new_objects_count).frame = frame_components_old(i).frame;
            new_objects(new_objects_count).X = frame_components_old(i).X;
            new_objects(new_objects_count).Y = frame_components_old(i).Y;
            new_objects(new_objects_count).Z = frame_components_old(i).Z;
        else
            %if( C(i,assignment(i)) < threshold_hungarian)
            % insert the component in the new_objects and it wont be used
            % in the next frame
            frame_components_new(assignment(i)).frame = [frame_components_old(i).frame frame_components_new(assignment(i)).frame];
            frame_components_new(assignment(i)).X = [frame_components_old(i).X; frame_components_new(assignment(i)).X];
            frame_components_new(assignment(i)).Y = [frame_components_old(i).Y; frame_components_new(assignment(i)).Y];
            frame_components_new(assignment(i)).Z = [frame_components_old(i).Z; frame_components_new(assignment(i)).Z];
            
        end
    end
    
    frame_components_old = frame_components_new;
    
    if new_objects_count == 0
        new_objects = [];
    end

end

