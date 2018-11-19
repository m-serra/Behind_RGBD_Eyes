%% Data Preprocessing

datasetlocation = '../datasets/movingpeople/maizena_chocapics1/data_rgb/';
cameralocation = '../vars/cameraparametersAsus.mat';

% Get the list of images names
rgb_images = dir(strcat(datasetlocation, '*.png'));
depth_images = dir(strcat(datasetlocation, '*.mat'));

% Check for datasets with errors
if(length(rgb_images) ~= length(depth_images))
       fprintf('The number of rgb images is diffent from the depth images\n');
end

% transform the list images names into an array of structures

% sorting the files names through their natural order
rgb_sorted = natsortfiles({rgb_images.name});
depth_sorted = natsortfiles({depth_images.name});

%tidying up the place
%clear 'rgb_images' 'depth_images';

% preallocation of memory
%imagesequence = struct('rgb', cell(1, 22), 'depth', cell(1, 22));

for i = 1:length(rgb_sorted)    
    imagesequence(i).rgb = [datasetlocation rgb_images(i)];
    imagesequence(i).depth = [datasetlocation depth_sorted(i)];
end



% Get the camera parameters
cameramatrix = load(cameralocation);


str = string(imagesequence(1).rgb{1})
isstring(str)


%% Part I


% Calling the function of PART1
objects = track3D_part1(imagesequence, cameramatrix.cam_params);


%% Part II

