%% Data Preprocessing

datasetlocation = '../datasets/data_rgb_6/';
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
% matches_3D contains matched points from 2 cams, to calculate R and T.
% first 3 columns are the coordinates in cam1 referential (columns 1,2,3)
% last 3 columns are the coordinates in cam2 referential (columns 4,5,6)
% contains as many rows as matched pair points;
% For robustness, we will use points from the first and last frame. Note
% that one frame would be enough, but if the chosen frame has few
% keypoints, it might be helpful to have a second frame, hopefully with
% different keypoints
matches_3D = [];

ransac_frames = 1;%[1 n_frames];
for frame=ransac_frames
    % 1.1) Find keypoints for the pair of images (cam1,cam2)
    % key point detection using SIFT:
    % check http://www.vlfeat.org/overview/sift.html for detais
    peak_thresh = 0;
    edge_thresh = 20;
    [f_cam1, d_cam1] = vl_sift(single(grayseq_cam1(:,:,frame)),'PeakThresh', peak_thresh, 'edgethresh', edge_thresh);
    [f_cam2, d_cam2] = vl_sift(single(grayseq_cam2(:,:,frame)),'PeakThresh', peak_thresh, 'edgethresh', edge_thresh);
    
    % 1.2) Match keypoints
    % we can apply a 1st filter at this stage to remove noisy matches from
    % the beggining, by reducing the threshold 
    % Note: vl_ubcmatch returns the indexes of the SIFT identified points,
    % not the indices of the real points. 
    % Check http://www.vlfeat.org/overview/sift.html for complete info
 
    match_threshold = 2.5; % 1.5 is the default value
    [matches, scores] = vl_ubcmatch(d_cam1, d_cam2, match_threshold);
    matches = round([f_cam1(1:2,matches(1,:))' f_cam2(1:2,matches(2,:))']);
    
    % plotting
    plot_sift(grayseq_cam1(:,:,frame),grayseq_cam2(:,:,frame), matches);
    
    % Convert points in 3D coordinates in the corresponding frame
    u_cam1_rgb = matches(:,1); v_cam1_rgb = matches(:,2);
    u_cam2_rgb = matches(:,3); v_cam2_rgb = matches(:,4);
    
    cam1_3D = rgb_to_xyz([u_cam1_rgb v_cam1_rgb], dseq_cam1(:,:,frame),cam_params);
    cam2_3D = rgb_to_xyz([u_cam2_rgb v_cam2_rgb], dseq_cam2(:,:,frame),cam_params);
        
    matches_3D = [matches_3D; [cam1_3D' cam2_3D']]; 
    
end

% 1.3) Filter out outlier matches by applying RANSAC method
% At this stage we have all the pair points in the variable matches_3D. See
% variable description next to its first instantiation. 

% S = log(1-P)/log(1-p^k)
% P = probability of success
% p = inliers ratio
% k = 4 in our case
P = 0.99;
p = 0.5;
k = 4;
max_iter = round(log10(1-P) / log10(1-p^k));
%max_iter = 200; % calculate according to the probability of outliers

inliers = ransac_procrustes(matches_3D, max_iter);

% 1.4) Fit R and T using pair points obtained after applying RANSAC in 1.3
% We should use PROCRUSTES solution
[~, ~, tr] = procrustes(inliers(:,1:3), inliers(:,4:6), 'Scaling',false,...
                        'Reflection',false);
                    
% Checking total error:
predicted_cam1 = matches_3D(:,4:6)*tr.T + ...
                            repmat(tr.c(1,:),size(matches_3D, 1),1);
diff = matches_3D(:,1:3) - predicted_cam1;
error = sqrt(sum(diff.^2,2));
total_wrong_matches = sum(double(error>0.25));

%test point cloud
pc1 = get_point_cloud(dseq_cam1(:,:,1), size_dimg, ...
                    (1:size_dimg(1)*size_dimg(2)),cam_params);
                
figure(111);
showPointCloud(pc1);
                
pc2 = get_point_cloud(dseq_cam2(:,:,1), size_dimg, ...
                    (1:size_dimg(1)*size_dimg(2)),cam_params);
                
figure(222);
showPointCloud(pc2);

figure (334)
points = pc2.Location*tr.T + ...
                            repmat(tr.c(1,:),size(pc2.Location, 1),1);
                        
pc3 = pointCloud(points);
showPointCloud(pc1);
hold on
showPointCloud(pc3);

R = tr.T';
T = tr.c(1,:)';

obj1 = track3D_part1(imagesequence_cam1, cam_params);
obj2 = track3D_part1(imagesequence_cam2, cam_params);

obj2_transformed = transform_object(obj2, R, T, n_frames);

% Stage 2: Run track3D_part1() for imagesequence_cam1 and imagesequence_cam2

% Stage 3: Represent components in 3D (point cloud), join possible
% intersecting components. 
% look for iterative closest points - wikipedia


% In the end return all identified components (identified only by cam1, only by cam2 and by both)