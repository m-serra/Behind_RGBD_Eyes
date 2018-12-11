%% Data Preprocessing

datasetlocation = '../datasets/maizena_chocapics2/';

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
% rgb_images = natsortfiles({rgb_images.name});
% depth_images = natsortfiles({depth_images.name});

% preallocation of memory
imagesequence = struct('rgb', cell(1, length(depth_images)), 'depth', cell(1, length(depth_images)));

for i = 1:length(depth_images)
    imagesequence(i).rgb =[datasetlocation rgb_images(i).name];
    imagesequence(i).depth =[datasetlocation depth_images(i).name];
end

% Get the camera parameters
cameramatrix = load(cameralocation);

%% Part I

% Calling the function of PART1
objects = track3D_part1(imagesequence, cameramatrix.cam_params);

%% Part II

