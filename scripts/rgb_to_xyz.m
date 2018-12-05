function [ rgb_3D ] = rgb_to_xyz(rgb_sift_points, dimg, cam_params)
%RGB_TO_XYZ Function to perform the conversion from rgb coordinates to 3D
%coordinates
%   To convert a point in a rgb image to 3D coordinates we need depth
%   information. Therefore, we need to compute for each rgb pixel, the
%   correspondig pixel in the deppth image. Then, we can convert to 3D
%   coordinates. The flow is the following:
%   1. Match corresponding depth frame to rgb indices
%   2. For each rgb_indice that we want to identify, iterate over all
%   converted indices, and find the coordinate in the depth image that
%   generated the closes match in the rgb image. Then we get the
%   corresponding point in 3D

size_dimg = size(dimg);
area_dimg = numel(dimg);

% STEP 1
% Get 3D representation from depth image
pc = get_point_cloud(dimg,size_dimg,(1:size_dimg(1)*size_dimg(2)),...
                     cam_params);
P = [pc.Location(:,1)';pc.Location(:,2)';pc.Location(:,3)'];

% Get rgb (u,v) values from the 3D representation
niu = cam_params.Krgb * [cam_params.R cam_params.T] * [P;ones(1,size(P,2))];
% x = miu1 / miu3    y = miu2 / miu3
u_rgb=round(niu(1,:)./niu(3,:)); 
v_rgb=round(niu(2,:)./niu(3,:));
depth_in_rgb = [u_rgb;v_rgb];

% STEP 2
rgb_3D = [];
for i=1:size(rgb_sift_points,1)
    % point in rgb that we want to identify
    u_goal=rgb_sift_points(i,1); v_goal=rgb_sift_points(i,2);
    goal = repmat([u_goal;v_goal], 1, size_dimg(1)*size_dimg(2));
    
    points_distance = goal - depth_in_rgb;
    [min_value, index] = min(sum(points_distance.*points_distance));
    rgb_3D = [rgb_3D P(:,index)];
end

end

