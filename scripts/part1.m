 %% Data Preprocessing

datasetlocation = '../datasets/lab1/';

cameralocation = '../vars/cameraparametersAsus.mat';

% CREATE image sequence
% Get the list of images names
rgb_images = dir(strcat(datasetlocation, '*.png'));
depth_images = dir(strcat(datasetlocation, '*.mat'));

% Check for datasets with errors
if(length(rgb_images) ~= length(depth_images))
       fprintf('The number of rgb images is diffent from the depth images\n');
end

% transform the list images names into an array of structures

% sorting the files names through their natural order
% rgb_sorted = natsortfiles({rgb_images.name});
% depth_sorted = natsortfiles({depth_images.name});

%tidying up the place
%clear 'rgb_images' 'depth_images';

% preallocation of memory
imagesequence = struct('rgb', cell(1, length(depth_images)), 'depth', cell(1, length(depth_images)));

for i = 1:length(depth_images)
    imagesequence(i).rgb =[datasetlocation rgb_images(i).name];
    imagesequence(i).depth =[datasetlocation depth_images(i).name];
end

%% Part I

% Get the camera parameters
cameramatrix = load(cameralocation);

%figure (1)
% Load images
[rgbseq, grayseq, dseq] = load_images(imagesequence);
%imagesc(uint8(dseq(:,:,1)));

% Point cloud
size_dimg = size(dseq(:,:,1));
pc = get_point_cloud(dseq(:,:,1), size_dimg, ...
                    (1:size_dimg(1)*size_dimg(2)),cameramatrix.cam_params);
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
for frame=1:5%size(dseq,3)
    % get components for a given frame
    cc = get_components(background, dseq(:,:,frame), diff_threshold, ...
                        filter_size, rgbseq(:,:,:,frame));
                    
    %if at least one component was identified, then store info
    if cc.NumObjects > 0
        frame_components_new = struct( 'frame',cell(1,cc.NumObjects), ...
                                   'label',cell(1,cc.NumObjects), ...
                                   'indices',cell(1,cc.NumObjects), ...
                                   'descriptor',cell(1,cc.NumObjects), ...
                                   'X',cell(1,cc.NumObjects), ...
                                   'Y',cell(1,cc.NumObjects), ... 
                                   'Z',cell(1,cc.NumObjects));
                               
        %for each component identified, store its info                       
        for i = 1:cc.NumObjects
            frame_components_new(i).frame = frame;
            frame_components_new(i).label = i;
            frame_components_new(i).indices = cc.PixelIdxList{i};
            frame_components_new(i).descriptor = get_component_descriptor(dseq(:,:,frame), ...
                rgbseq(:,:,:,frame), cc.PixelIdxList{i}, cameramatrix.cam_params);
            %get box coordinates
            [X, Y, Z] = get_box(dseq(:,:,frame) ,cc.PixelIdxList{i},...
                                cameramatrix.cam_params, i);
            frame_components_new(i).X = X;
            frame_components_new(i).Y = Y;
            frame_components_new(i).Z = Z;
        end
        
    else
        frame_components_new = struct( 'frame',cell(1,cc.NumObjects), ...
                                   'label',cell(1,cc.NumObjects), ...
                                   'indices',cell(1,cc.NumObjects), ...
                                   'descriptor',cell(1,cc.NumObjects), ...
                                   'X',cell(1,cc.NumObjects), ...
                                   'Y',cell(1,cc.NumObjects), ... 
                                   'Z',cell(1,cc.NumObjects));
    end
    
    
    % compare frame_components's components
    % with previous frame components
    if frame == 1 %first frame -> no old components
        frame_components_old=frame_components_new;
        continue
    else
        [new_objects, frame_components_old] = match_components(frame_components_old, frame_components_new);
    end
    %this will be inside a loop with frame iterator
    objects = [objects new_objects];
    if frame == 5 %size(dseq,3) %last frame -> all old components become new_objects
        [new_objects, ~] = match_components(frame_components_old, []);
        objects = [objects new_objects];
    end
    
end


% Calling the function of PART1
% objects = track3D_part1(imagesequence, cameramatrix.cam_params);

%% Part II

