function [ frame_components_merged ] = registration( frame_components_cam1, frame_components_cam2, frame)
% Matching between 3D boxes identified in two cameras:
% 1) for every (box_cam1, box_cam2) pair, compute the intersection ratio
% 2) use the hungarian algorithm to find the best match for every box
% 3) eliminate matches whose score is below a sastisfiability threshold 
%    (i.e. assume that the box is only seen by one of the cameras in the 
%     current frame)
% 4) if the match is good enough merge the frame list of the box in camera1
%    with the frame list of the box in camera2 and save it in a new_object 
% 5) 


frame_components_merged = [];

% (1 - intersection ratio)
ratio_threshold = 0.3;
obj1_to_remain = ones(1,length(frame_components_cam1));
obj2_to_remain = ones(1,length(frame_components_cam2));

% matrix with the ratio of volume intersection between every pair of components
% candidates = ones(length(frame_components_cam1),length(frame_components_cam2)); 
    
for i=1:length(frame_components_cam1) % iterate camera 1 components

    % find component box vertices
    x_min_cam1 = min(frame_components_cam1(i).X(1,:)); x_max_cam1 = max(frame_components_cam1(i).X(1,:));
    y_min_cam1 = min(frame_components_cam1(i).Y(1,:)); y_max_cam1 = max(frame_components_cam1(i).Y(1,:));
    z_min_cam1 = min(frame_components_cam1(i).Z(1,:)); z_max_cam1 = max(frame_components_cam1(i).Z(1,:));

    box1 = [x_min_cam1 x_max_cam1 y_min_cam1 y_max_cam1 z_min_cam1 z_max_cam1];

    % compute component box volume
    vol1 = abs(prod(box1(:,2:2:end) - box1(:,1:2:end) ,2 ));
    
    % candidate matches for each frame components in cam 1
    candidates = [];
    
    for j=1:length(frame_components_cam2) % iterate camera 2 components

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

        % save the ratio between the volumes of the common_box and the
        % smallest of the two component boxes;
        if (vol_c / (min(vol1, vol2))) > ratio_threshold
            candidates = [candidates j];
        end

    end
    
    % if any candidates on the list, merge
    % if merge is performed, delete from objects to remain
    if ~isempty(candidates)
        frame_component_new = frame_components_cam1(i);
        
        
        for k=candidates
            frame_component_new = merge_components(frame_component_new,...
                                    frame_components_cam2(k));
            
            
            % eliminate merged components cam2
            obj2_to_remain(k) = 0;
        end
        % eliminate merged components cam1
        obj1_to_remain(i) = 0;
        frame_components_merged = [frame_components_merged frame_component_new];
    end
    
    
end
frame_components_merged = [frame_components_merged frame_components_cam1(find(obj1_to_remain)) ...
                            frame_components_cam2(find(obj2_to_remain))];



end

