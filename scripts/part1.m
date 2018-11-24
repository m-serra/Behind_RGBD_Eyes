 %% Data Preprocessing

datasetlocation = '../datasets/lab1/';
cameralocation = '../vars/cameraparametersAsus.mat';

%% CREATE image sequence
% % Get the list of images names
% rgb_images = dir(strcat(datasetlocation, '*.png'));
% depth_images = dir(strcat(datasetlocation, '*.mat'));
% 
% % Check for datasets with errors
% if(length(rgb_images) ~= length(depth_images))
%        fprintf('The number of rgb images is diffent from the depth images\n');
% end
% 
% % transform the list images names into an array of structures
% 
% % sorting the files names through their natural order
% rgb_sorted = natsortfiles({rgb_images.name});
% depth_sorted = natsortfiles({depth_images.name});
% 
% %tidying up the place
% %clear 'rgb_images' 'depth_images';
% 
% % preallocation of memory
% imagesequence = struct('rgb', convertStringsToChars(strings(1, length(depth_images))), 'depth', convertStringsToChars(strings(1, length(depth_images))));
% 
% for i = 1:length(rgb_sorted)    
%     imagesequence(i).rgb = string(strcat(datasetlocation,rgb_sorted(i)));
%     imagesequence(i).depth = string(strcat(datasetlocation, depth_sorted(i)));
% end

% %% CHANGE CORREDOR1 TO ANY DATASET
% for i=1:254*2
%     imagesequence(i).rgb = strrep(imagesequence(i).rgb,"corredor1","fruta1");
%     imagesequence(i).depth = strrep(imagesequence(i).depth,"corredor1","fruta1");
% end

%% Part I

% Get the camera parameters
cameramatrix = load(cameralocation);

% Manually load imagesequence
imagesequence = load('../vars/imagesequence_lab1.mat');

figure (1)
% Load images
[rgbseq, grayseq, dseq] = load_images(imagesequence.imagesequence);
imagesc(uint8(dseq(:,:,1)));

% Point cloud
size_dimg = size(dseq(:,:,1));
pc = get_point_cloud(dseq(:,:,1), size_dimg, ...
                    (1:size_dimg(1)*size_dimg(2)),cameramatrix.cam_params);
figure (2)
% Subtract background
background = get_background(dseq);

% --- Start working with components ---

% cell array that contains COMPONENTS FOR ALL FRAMES
components = [];

% parameters
diff_threshold = 0.2;
filter_size = 10;

% iterate over frames:
for frame=1:1%size(dseq,3)
    % get components for a given frame
    cc = get_components(background, dseq(:,:,frame), diff_threshold, ...
                        filter_size);
                    
    %if at least one component was identified, then store info
    if cc.NumObjects > 0
        frame_components = struct( 'frame',cell(1,cc.NumObjects), ...
                                   'label',cell(1,cc.NumObjects), ...
                                   'indices',cell(1,cc.NumObjects), ...
                                   'descriptor',cell(1,cc.NumObjects), ...
                                   'X',cell(1,cc.NumObjects), ...
                                   'Y',cell(1,cc.NumObjects), ... 
                                   'Z',cell(1,cc.NumObjects));
                               
        %for each component identified, store its info                       
        for i = 1:cc.NumObjects
            frame_components(i).frame = frame;
            frame_components(i).label = i;
            frame_components(i).indices = cc.PixelIdxList{i};
            frame_components(i).descriptor = get_component_descriptor(dseq(:,:,frame), ...
                rgbseq(:,:,:,frame), cc.PixelIdxList{i}, cameramatrix.cam_params);
            %get box coordinates
            [X, Y, Z] = get_box(dseq(:,:,frame) ,cc.PixelIdxList{i},...
                                cameramatrix.cam_params, i);
            frame_components(i).X = X;
            frame_components(i).Y = Y;
            frame_components(i).Z = Z;
        end
    else
        frame_components = 0;
    end

    %this will be inside a loop with frame iterator
    components = [components frame_components];
end


% Calling the function of PART1
%objects = track3D_part1(imagesequence, cameramatrix.cam_params);

%% Part II