function [ X, Y, Z ] = get_box( dimg, indices, cam_params )
%GET_BOX Function to obtain the coordinates of the box containing a
%component
%   This function receives as argument the indices of a component. It
%   transforms them in regular 2D coordinates, proceeds to the
%   representation in the point cloud and use the extreme points
%   of the component to build the surrounding box
size_dimg = size(dimg);
point_cloud = get_point_cloud(dimg(indices),size_dimg,indices',cam_params);

X = 1;
Y = 1;
Z = 1;

end

