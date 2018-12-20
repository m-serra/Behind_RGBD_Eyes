%% Data Preprocessing
close all

datasetlocation = '../datasets/fruta1/';
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

% preallocation of memory. we assume there are as many images from cam1 as
% from cam2
images_per_cam = length(depth_images)/2;
imagesequence_cam1 = struct('rgb', cell(1, images_per_cam), 'depth', cell(1, images_per_cam));
imagesequence_cam2 = struct('rgb', cell(1, images_per_cam), 'depth', cell(1, images_per_cam));

for i = 1:images_per_cam
    % load camera 1 images
    imagesequence_cam1(i).rgb =[datasetlocation rgb_images(i).name];
    imagesequence_cam1(i).depth =[datasetlocation depth_images(i).name];
    % load camera 2 images
    imagesequence_cam2(i).rgb =[datasetlocation rgb_images(images_per_cam + i).name];
    imagesequence_cam2(i).depth =[datasetlocation depth_images(images_per_cam + i).name];
end

% Get the camera parameters
cameramatrix = load(cameralocation);

%% Part II

objects = track3D_part2(imagesequence_cam1, imagesequence_cam2, cameramatrix.cam_params);