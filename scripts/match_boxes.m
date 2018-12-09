function [ new_objects ] = match_boxes( obj1, obj2, new_objects, frame)

% Matching between 3D boxes identified in two cameras:
% 1) for every (box_cam1, box_cam2) pair, compute the intersection ratio
% 2) use the hungarian algorithm to find the best match for every box
% 3) eliminate matches whose score is below a sastisfiability threshold 
%    (i.e. assume that the box is only seen by one of the cameras in the 
%     current frame)
% 4) if the match is good enough merge the frame list of the box in camera1
%    with the frame list of the box in camera2 and save it in a new_object 
% 5) 

% (1 - intersection ratio)
ratio_threshold = 0.7;
new_objects_count = 0;
obj1_to_remove = [];
obj2_to_remove = [];

% matrix with the ratio of volume intersection between every pair of components
ratio = zeros(length(obj1),length(obj2)); 
    
for i=1:length(obj1) % iterate camera 1 components

    % check whether component i of cam1 is in frame
    if ~ismember(frame,obj1(i).frame)
        ratio(i,:) = 1;
        continue
    end

    % index of this frame in the frames list of the component i
    ii = find(obj1(i).frame==frame);

    % find component box vertices
    x_min = min(obj1(i).X(ii,:)); x_max = max(obj1(i).X(ii,:));
    y_min = min(obj1(i).Y(ii,:)); y_max = max(obj1(i).Y(ii,:));
    z_min = min(obj1(i).Z(ii,:)); z_max = max(obj1(i).Z(ii,:));

    box1 = [x_min x_max y_min y_max z_min z_max];

    % compute component box volume
    vol1 = prod(box1(:,2:2:end) - box1(:,1:2:end) ,2 );

    for j=1:length(obj2) % iterate camera 2 components

        % check whether component j  of cam2 is in frame
        if ~ismember(frame,obj2(j).frame)
            ratio(:,j) = 1;
            continue
        end 

        % index of this frame in the frames list of the component j
        jj = find(obj2(j).frame==frame);

        % find component box vertices
        x_min = min(obj2(j).X(jj,:)); x_max = max(obj2(j).X(jj,:));
        y_min = min(obj2(j).Y(jj,:)); y_max = max(obj2(j).Y(jj,:));
        z_min = min(obj2(j).Z(jj,:)); z_max = max(obj2(j).Z(jj,:));

        box2 = [x_min x_max y_min y_max z_min z_max];

        % compute component box volume
        vol2 = prod(box2(:,2:2:end) - box2(:,1:2:end) ,2 );

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
        ratio(i,j) = 1 - (vol_c / (min(vol1, vol2)));

    end
end

% Once we've computed the intersection ratios between each pair of
% components detected by the cameras in the current frame, 
% the Hungarian algorithm is used to find the best matches
assignment = munkres(ratio);
    
for i=1:length(assignment)

    % if the assignment is not good enough we consider that in this frame, 
    % the component is only present in one of the cameras
    if (assignment(i) == 0 || ratio(i,assignment(i)) > ratio_threshold)
        continue
    % a good match between components of the two cameras was found
    else
        new_objects_count = new_objects_count + 1;
        obj1_to_remove = [obj1_to_remove i];
        obj2_to_remove = [obj2_to_remove assignment(i)];
        % frames will have all the frames where the box appears,
        % independently of the camera that sees the box
        new_objects(new_objects_count).frame = union(obj1(i).frame, obj2(assignment(i)).frame);
        
        % iterate all the frames of the new object and create the
        % respective (X Y Z)
        for k=1:length(new_objects(new_objects_count).frame)
            f = new_objects(new_objects_count).frame(k);
            
            a = ismember(f,obj1(i).frame);
            b = ismember(f,obj2(assignment(i)).frame);
            
            if a && b % in frame f the box was detected in both cameras
                ff1 = find(obj1(i).frame==f);
                ff2 = find(obj2(assignment(i)).frame==f);
                x_union = [obj1(i).X(ff1,:) obj2(assignment(i)).X(ff2,:)];
                x_min = min(x_union);
                x_max = max(x_union);
                new_objects(new_objects_count).X(k,:) = [x_min x_max x_max x_min x_min x_max x_max x_min];
                
                y_union = [obj1(i).Y(ff1,:) obj2(assignment(i)).Y(ff2,:)];
                y_min = min(y_union);
                y_max = max(y_union);
                new_objects(new_objects_count).Y(k,:) = [y_min y_min y_max y_max y_min y_min y_max y_max];
                
                z_union = [obj1(i).Z(ff1,:) obj2(assignment(i)).Z(ff2,:)];
                z_min = min(z_union);
                z_max = max(z_union);
                new_objects(new_objects_count).Z(k,:) = [z_min z_min z_min z_min z_max z_max z_max z_max];
                
            elseif a % in frame f the box was detected in cam1 only
                ff1 = find(obj1(i).frame==f);
                new_objects(new_objects_count).X(k,:) = obj1(i).X(ff1,:);
                new_objects(new_objects_count).Y(k,:) = obj1(i).Y(ff1,:);
                new_objects(new_objects_count).Z(k,:) = obj1(i).Z(ff1,:);
            elseif b % in frame f the box was detected in cam2 only
                ff2 = find(obj2(assignment(i)).frame==f);
                new_objects(new_objects_count).X(k,:) = obj2(assignment(i)).X(ff2,:);
                new_objects(new_objects_count).Y(k,:) = obj2(assignment(i)).Y(ff2,:);
                new_objects(new_objects_count).Z(k,:) = obj2(assignment(i)).Z(ff2,:);
            end
        end

    end
end

% remove assigned boxes from the initial objects
obj1(obj1_to_remove) = [];
obj2(obj2_to_remove) = [];

end

