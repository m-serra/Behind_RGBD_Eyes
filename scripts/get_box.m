function [ X, Y, Z ] = get_box( dimg, indices, cam_params )
%GET_BOX Function to obtain the coordinates of the box containing a
%component
%   This function receives as argument the indices of a component. It
%   transforms them in regular 2D coordinates, proceeds to the
%   representation in the point cloud and use the extreme points
%   of the component to build the surrounding box
size_dimg = size(dimg);
pc = get_point_cloud(dimg(indices),size_dimg,indices',cam_params);

% Get coordinates for 8 points in the order:

X = [pc.XLimits(1); pc.XLimits(2); pc.XLimits(2); pc.XLimits(1); ...
     pc.XLimits(1); pc.XLimits(2); pc.XLimits(2); pc.XLimits(1)];
 
Y = [pc.YLimits(1); pc.YLimits(1); pc.YLimits(2); pc.YLimits(2); ...
     pc.YLimits(1); pc.YLimits(1); pc.YLimits(2); pc.YLimits(2)];
 
Z = [pc.ZLimits(1); pc.ZLimits(1); pc.ZLimits(1); pc.ZLimits(1); ...
     pc.ZLimits(2); pc.ZLimits(2); pc.ZLimits(2); pc.ZLimits(2)];
 
% example of unit cube plotting 
 xt = [0;1;1;0;0];
 yt = [0;0;1;1;0];
 zt = [0;0;0;0;0];
 figure;
 hold on;
 plot3(xt,yt,zt);   % draw a square in the xy plane with z = 0
 plot3(xt,yt,zt+1); % draw a square in the xy plane with z = 1
 set(gca,'View',[-28,35]); % set the azimuth and elevation of the plot


end

