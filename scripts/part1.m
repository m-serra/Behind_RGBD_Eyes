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
% % imagesequence = struct('rgb', cell(1, length(depth_images)), 'depth', cell(1, length(depth_images)));
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

%% Part I

% Subtract background
background = get_background(dseq);

% Get components
diff_threshold = 0.20;
get_components(background, dseq(:,:,1), diff_threshold, 5);

% Calling the function of PART1
objects = track3D_part1(imagesequence, cameramatrix.cam_params);

%% Part II

