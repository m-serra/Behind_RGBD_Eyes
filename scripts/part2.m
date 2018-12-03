%% Data Preprocessing

datasetlocation = '../datasets/maizena_chocapics_2cam/';
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
cam_params = cameramatrix.cam_params; % cam parameters
size_dimg = size(dseq_cam1(:,:,1)); % stores size of dimg

% Stage 1: Identify R, T from cam2 to cam1 referential
%
% matches_3D contains all the key matched points, in 3D!
% first 3 columns are the coordinates in cam1 referential (columns 1,2,3)
% last 3 columns are the coordinates in cam2 referential (columns 4,5,6)
% contains as many rows as matched pair points among all frames
matches_3D = [];
for frame=1:n_frames
    % 1.1) Find keypoints for the pair of images (cam1,cam2)
    % key point detection using SIFT:
    % check http://www.vlfeat.org/overview/sift.html for detais
    [f_cam1, d_cam1] = vl_sift(single(grayseq_cam1(:,:,frame)));
    [f_cam2, d_cam2] = vl_sift(single(grayseq_cam2(:,:,frame)));
    
    % 1.2) Match keypoints
    % we can apply a 1st filter at this stage to remove noisy matches from
    % the beggining, by reducing the threshold 
    match_threshold = 1.5; % 1.5 is the default value
    [matches, scores] = vl_ubcmatch(d_cam1, d_cam2, match_threshold);
    
    % Convert points in 3D coordinates in the corresponding frame
    indices_cam1 = matches(1,:);
    indices_cam2 = matches(2,:);
    dimg_cam1 = dseq_cam1(:,:,frame);
    dimg_cam2 = dseq_cam2(:,:,frame);
    
    pc_cam1 = get_point_cloud(dimg_cam1(indices_cam1),...
                              size_dimg, indices_cam1,cam_params);
    pc_cam2 = get_point_cloud(dimg_cam2(indices_cam2),...
                              size_dimg, indices_cam2,cam_params);
    
    frame_matches = [pc_cam1.Location pc_cam2.Location];
    matches_3D = [matches_3D;frame_matches]; 

end

% 1.3) Filter out outlier matches by applying RANSAC method
% At this stage we have all the pair points in the variable matches_3D. See
% variable description next to its first instantiation. 



% 1.4) Fit R and T using pair points obtained after applying RANSAC in 1.3

% Stage 2: Run track3D_part1() for imagesequence_cam1 and imagesequence_cam2

% Stage 3: Represent components in 3D (point cloud), join possible
% intersecting components. 


% In the end return all identified components (identified only by cam1, only by cam2 and by both)