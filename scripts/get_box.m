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
% x_max = max(pc.Location(:,1));
% x_min = min(pc.Location(:,1));
% y_max = max(pc.Location(:,2));
% y_min = min(pc.Location(:,2));
% z_max = max(pc.Location(:,3));
% z_min = min(pc.Location(:,3));

X = [pc.XLimits(1); pc.XLimits(2); pc.XLimits(2); pc.XLimits(1); ...
     pc.XLimits(1); pc.XLimits(2); pc.XLimits(2); pc.XLimits(1)];
 
Y = [pc.YLimits(1); pc.YLimits(1); pc.YLimits(2); pc.YLimits(2); ...
     pc.YLimits(1); pc.YLimits(1); pc.YLimits(2); pc.YLimits(2)];
 
Z = [pc.ZLimits(1); pc.ZLimits(1); pc.ZLimits(1); pc.ZLimits(1); ...
     pc.ZLimits(2); pc.ZLimits(2); pc.ZLimits(2); pc.ZLimits(2)];
 

figure(10);
showPointCloud(pc);
hold on
edges = [pc.XLimits(2) - pc.XLimits(1), pc.YLimits(2) - pc.YLimits(1),...
         pc.ZLimits(2) - pc.ZLimits(1)]; % size of each edge
origin = [pc.XLimits(1), pc.YLimits(1), pc.ZLimits(1)]; % defined as the point from which the cube wll be drawn
transparency = 0.1;
plot_box(edges, origin, transparency)
hold off 

end

