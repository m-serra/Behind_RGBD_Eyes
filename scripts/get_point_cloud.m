function [ point_cloud ] = get_point_cloud( dimg, cam_params )
%GET_POINT_CLOUD Summary of this function goes here
%   Detailed explanation goes here
    Kd= cam_params.Kdepth;

    Z = dimg(:); %convert to array
    [y, x] = ind2sub(size(dimg),(1:size(dimg,1)*size(dimg,2)));
    miu_depth = [Z.*x ;Z.*y;Z];
    pc_points = Kd\miu_depth;
    
    point_cloud = pointCloud(pc_points');
    figure(1);showPointCloud(point_cloud);
end

