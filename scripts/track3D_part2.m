function [ objects, cam2toW ] = track3D_part2( imagesequence_cam1, imagesequence_cam2, cam_params )
% Part II

% In this section we will identify moving objects not just with one camera 
% but with two cameras. Therefore, we must match information obtained by 
% each camera and gather all the components identified.
% As we want to match objects, we must represent them in the same
% coordinate frame, which we will choose to be the referential of cam1.
% Our job is decomposed in three stages:
% 1: Identify R, T from cam2 to cam1 referential
% 2: Identify components on cam1 and cam2 images
% 3. Use matrices calculated on step 1 to merge components found on step 2


% Load images
[rgbseq_cam1, grayseq_cam1, dseq_cam1] = load_images(imagesequence_cam1);
[rgbseq_cam2, grayseq_cam2, dseq_cam2] = load_images(imagesequence_cam2);

% some auxiliary variables
n_frames = size(dseq_cam1,3); % number of frames in sequence
size_dimg = size(dseq_cam1(:,:,1)); % stores size of dimg

% Stage 1: Identify R, T from cam2 to cam1 referential
ransac_frames = 20;
[R, T] = get_R_T(grayseq_cam1, grayseq_cam2, dseq_cam1, dseq_cam2, cam_params, ransac_frames);

% Subtract background
background_cam1 = get_background(dseq_cam1);
background_cam2 = get_background(dseq_cam2);

% --- Start working with components ---

% cell array that contains COMPONENTS FOR ALL FRAMES
objects = [];

% parameters
diff_threshold = 0.2;
filter_size = 10;

% iterate over frames:
for frame=1:size(dseq_cam1,3)
    % get components for a given frame
    cc_cam1 = get_components(background_cam1, dseq_cam1(:,:,frame), diff_threshold, ...
                        filter_size, rgbseq_cam1(:,:,:,frame));
                    
    cc_cam2 = get_components(background_cam2, dseq_cam2(:,:,frame), diff_threshold, ...
                        filter_size, rgbseq_cam2(:,:,:,frame));
                    
    %get component info: descriptor, X, Y, Z
    frame_components_cam1 = get_component_info(cc_cam1, dseq_cam1(:,:,frame), ...
                        rgbseq_cam1(:,:,:,frame), cam_params, frame);
                    
    frame_components_cam2 = get_component_info(cc_cam2, dseq_cam2(:,:,frame), ...
                        rgbseq_cam2(:,:,:,frame), cam_params, frame);
                    
    % transform objects from cam2 into cam1 reference
    frame_components_cam2 = transform_object(frame_components_cam2, R, T, n_frames);
    
    % get the intersection of components from cam1 and cam2
    frame_components_new = registration( frame_components_cam1, frame_components_cam2, frame);
    
    
    % debug mode - experimental results (color point cloud)
    if length(frame_components_new) > 0
        % colour point clouds
        figure (200 + frame)
        color_point_cloud(dseq_cam2(:,:,frame), rgbseq_cam2(:,:,:,frame), cam_params, 'rotate',R',T')
        hold on
        color_point_cloud(dseq_cam1(:,:,frame), rgbseq_cam1(:,:,:,frame), cam_params, 'normal',0,0)
        for obj=1:length(frame_components_new)
            if obj>8
                continue
            end
           plot_obj_boxes(frame_components_new(obj), frame, char(color_(obj)), 3); 
        end
    end
    
    % compare frame_components's components
    % with previous frame components
    if frame == 1 %first frame -> no old components
        frame_components_old = frame_components_new;
        continue
    else
        [new_objects, frame_components_old] = match_components(frame_components_old, frame_components_new);
    end
    %this will be inside a loop with frame iterator
    objects = [objects new_objects];
    if frame == size(dseq_cam1,3) %last frame -> all old components become new_objects
        [new_objects, ~] = match_components(frame_components_old, []);
        objects = [objects new_objects];
    end
    
end

% take from the objects structure the components that only appear in one
% frame (according to the professor, those components are not meaningful)
objects = clean_single_objects(objects);

cam2toW = struct('R',R,'T',T);

end

