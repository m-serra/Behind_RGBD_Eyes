function [ point_cloud ] = get_point_cloud( dimg, size_dimg, indices, ...
                                            cam_params )
%GET_POINT_CLOUD Function to compute point cloud of a given depth image
%   Function calculates the point cloud knowing the camera parameters
    Kd= cam_params.Kdepth;
    
    if size(dimg,2)>1
        Z = dimg(:)'; % convert to array
    else
        Z = dimg';
    end
    [y, x] = ind2sub(size_dimg,indices);
    miu_depth = [Z.*x ;Z.*y;Z];
    pc_points = Kd\miu_depth;
    
    point_cloud = pointCloud(pc_points');

end

