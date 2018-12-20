function [ objects ] = track3D_part1( imgseq1, cam_params )
%The function receives the images as inputs and  returns the 8 points describing the time trajectories 
%of the enclosing box of the objects in world (camera) coordinates

%figure (1)
% Load images
[rgbseq, grayseq, dseq] = load_images(imgseq1);
%imagesc(uint8(dseq(:,:,1)));

% Point cloud
size_dimg = size(dseq(:,:,1));
pc = get_point_cloud(dseq(:,:,1), size_dimg, ...
                    (1:size_dimg(1)*size_dimg(2)),cam_params);
%figure (2)
% Subtract background
background = get_background(dseq);

% --- Start working with components ---

% cell array that contains COMPONENTS FOR ALL FRAMES
objects = [];

% parameters
diff_threshold = 0.2;
filter_size = 10;

% iterate over frames:
for frame=1:size(dseq,3)
    % get components for a given frame
    cc = get_components(background, dseq(:,:,frame), diff_threshold, ...
                        filter_size, rgbseq(:,:,:,frame));
                    
    %get component info: descriptor, X, Y, Z
    frame_components_new = get_component_info(cc, dseq(:,:,frame), ...
                        rgbseq(:,:,:,frame), cam_params, frame);
    
    
                    
%     % debug mode - experimental results (color point cloud)
%     if length(frame_components_new) > 0
%         % colour point clouds
%         figure (200 + frame)
%         title(strcat('Frame ', int2str(frame) ));
%         color_point_cloud(dseq(:,:,frame), rgbseq(:,:,:,frame), cam_params, 'normal',0,0)
%         for obj=1:length(frame_components_new)
%            plot_obj_boxes(frame_components_new(obj), frame, char(color_(obj)), 3); 
%         end
%     end
    
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
    if frame == size(dseq,3) %last frame -> all old components become new_objects
        [new_objects, ~] = match_components(frame_components_old, []);
        objects = [objects new_objects];
    end
    
end

% take from the objects structure the components that only appear in one
% frame (according to the professor, those components are not meaningful)
objects = clean_single_objects(objects);

end