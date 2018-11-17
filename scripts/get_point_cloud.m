function [ point_cloud ] = get_point_cloud( dimg, cam_params )
%GET_POINT_CLOUD Summary of this function goes here
%   Detailed explanation goes here
    Z = dimg(:); %convert to array
    [y, x] = ind2sub(size(dimg),(1:size(dimg,1)*size(dimg,2)));
    P = cam_params.Kdepth\[Z.*x;Z.*y;Z];
    
end

