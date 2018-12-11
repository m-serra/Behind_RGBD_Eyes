function [ frame_components_merged ] = registration( frame_components_cam1, frame_components_cam2, frame)
% This function is responsible for intersecting components information
% retrieved by the 2 cameras, and return a single structure with all the 
% objects identified in every frame.
% 1) for every object in cam1, see if there exists a matching object in
%    camera 2. (a matching object is considered if the intersection ratio
%    of the boxes is above a certain threshold).
% 2) Whenever a match exists, merge with object in cam1 and update relevant
%    information about the object, such as its descriptors and box
%    coordinates
% 3) objects in cam1 not matched are just retrieved as they were received
%    in the input
% 4) objects in cam2 not matched are just retrieved as they were received
%    in the input


frame_components_merged = [];

% (1 - intersection ratio)
ratio_threshold = 0.3;
% obji_to_remain is an array with zeros and ones. 
% 0 means the object with that index was matched (and a new object was
% created) and therefore its past information should not remain. 
% 1 means the object with that index was not matched and therefore the
% exact same information of the object should remain
obj1_to_remain = ones(1,length(frame_components_cam1));
obj2_to_remain = ones(1,length(frame_components_cam2));
    
for i=1:length(frame_components_cam1) % iterate over camera 1 components

    % find component box vertices
    x_min_cam1 = min(frame_components_cam1(i).X(1,:)); x_max_cam1 = max(frame_components_cam1(i).X(1,:));
    y_min_cam1 = min(frame_components_cam1(i).Y(1,:)); y_max_cam1 = max(frame_components_cam1(i).Y(1,:));
    z_min_cam1 = min(frame_components_cam1(i).Z(1,:)); z_max_cam1 = max(frame_components_cam1(i).Z(1,:));

    box1 = [x_min_cam1 x_max_cam1 y_min_cam1 y_max_cam1 z_min_cam1 z_max_cam1];

    % compute component box volume
    vol1 = abs(prod(box1(:,2:2:end) - box1(:,1:2:end) ,2 ));
    
    % candidate matches for each frame components in cam 1
    candidates = [];
    
    for j=1:length(frame_components_cam2) % iterate over camera 2 components

        % find component box vertices
        x_min_cam2 = min(frame_components_cam2(j).X(1,:)); x_max_cam2 = max(frame_components_cam2(j).X(1,:));
        y_min_cam2 = min(frame_components_cam2(j).Y(1,:)); y_max_cam2 = max(frame_components_cam2(j).Y(1,:));
        z_min_cam2 = min(frame_components_cam2(j).Z(1,:)); z_max_cam2 = max(frame_components_cam2(j).Z(1,:));

        box2 = [x_min_cam2 x_max_cam2 y_min_cam2 y_max_cam2 z_min_cam2 z_max_cam2];

        % compute component box volume
        vol2 = abs(prod(box2(:,2:2:end) - box2(:,1:2:end) ,2 ));

        % get the box created by the intersection of box1 and box2
        common_box = intersectBoxes3d(box1, box2);

        % if there is no intersection skip to next cam2 component
        if common_box == -1
            continue
        end

        % compute volume of the common box
        vol_c = prod(common_box(:,2:2:end) - common_box(:,1:2:end) ,2 );

        % if the match was sufficiently good, add object of cam2 to the
        % list of objects to merge with cam1 (candidates)
        if (vol_c / (min(vol1, vol2))) > ratio_threshold
            candidates = [candidates j];
        end

    end
    
    % if any candidates on the list, merge with cam1 object
    % if merge is performed, delete from objects to remain
    if ~isempty(candidates)
        % initialize new object
        frame_component_new = frame_components_cam1(i);
        
        for k=candidates
            % merge every candidate iteratively
            frame_component_new = merge_components(frame_component_new,...
                                    frame_components_cam2(k));
            
            % eliminate corresponding merged component of cam2
            obj2_to_remain(k) = 0;
        end
        % eliminate merged components cam1
        obj1_to_remain(i) = 0;
        frame_components_merged = [frame_components_merged frame_component_new];
    end
end

% at this stage, we added all the matched components. We proceed with
% adding the components which were not matched
frame_components_merged = [frame_components_merged frame_components_cam1(find(obj1_to_remain)) ...
                            frame_components_cam2(find(obj2_to_remain))];
                        
end

