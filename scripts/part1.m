 %% Data Preprocessing

datasetlocation = '../datasets/corredor1/';
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

%% Part I

% Get the camera parameters
cameramatrix = load(cameralocation);

% Manually load imagesequence
imagesequence = load('../vars/imagesequence_corredor1.mat');

% Load images
[rgbseq, grayseq, dseq] = load_images(imagesequence.imagesequence);
imagesc(uint8(dseq(:,:,1)));

% Point cloud
pc = get_point_cloud(dseq(:,:,1), cameramatrix.cam_params);

% Subtract background
background = get_background(dseq);


% --- Start working with components ---

% cell array that contains COMPONENTS FOR ALL FRAMES
components = cell(1, size(dseq,3));

% get components for a given frame
diff_threshold = 0.20;
filter_size = 5;
cc = get_components(background, dseq(:,:,1), diff_threshold, filter_size);

if cc.NumObjects > 0
    frame_components = struct('label',cell(1,cc.NumObjects), ...
                               'indices',cell(1,cc.NumObjects), ...
                               'descriptor',cell(1,cc.NumObjects), ...
                               'X',cell(1,cc.NumObjects), ...
                               'Y',cell(1,cc.NumObjects), ... 
                               'Z',cell(1,cc.NumObjects), ...
                               'frames',cell(1,cc.NumObjects));
    for i = 1:cc.NumObjects
        frame_components(i).label = i;
        frame_components(i).indices = cc.PixelIdxList{i};
        frame_components(i).descriptor = 0;
        frame_components(i).X = zeros(8);
        frame_components(i).Y = zeros(8);
        frame_components(i).Z = zeros(8);
        % this will be inside a loop with frame iterator
        % frame_components(i).frames = frame
    end
else
    frame_components = 0;
end

% this will be inside a loop with frame iterator
components(1)=frame_components;



% Calling the function of PART1
%objects = track3D_part1(imagesequence, cameramatrix.cam_params);

%% Part II