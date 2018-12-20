function [ X, Y, Z] = get_box( dimg, indices, cam_params, i)
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

X = [pc.XLimits(1) pc.XLimits(2) pc.XLimits(2) pc.XLimits(1) ...
     pc.XLimits(1) pc.XLimits(2) pc.XLimits(2) pc.XLimits(1)];
 
Y = [pc.YLimits(1) pc.YLimits(1) pc.YLimits(2) pc.YLimits(2) ...
     pc.YLimits(1) pc.YLimits(1) pc.YLimits(2) pc.YLimits(2)];
 
Z = [pc.ZLimits(1) pc.ZLimits(1) pc.ZLimits(1) pc.ZLimits(1) ...
     pc.ZLimits(2) pc.ZLimits(2) pc.ZLimits(2) pc.ZLimits(2)];
 

% %uncomment to draw component point cloud + box
% figure(10 + i);
% showPointCloud(pc);
% title(strcat('Frame ', int2str(i) ));
% %xlim([0 2.5]);
% %ylim([-0.2 1.2]);
% %zlim([2 5]);
% xlabel('x');
% ylabel('y');
% zlabel('z');
% hold on
% line([X(1) X(2)],[Y(1) Y(1)],[Z(1) Z(1)]);
% line([X(1) X(2)],[Y(1) Y(1)],[Z(5) Z(5)]);
% line([X(1) X(2)],[Y(3) Y(3)],[Z(1) Z(1)]);
% line([X(1) X(2)],[Y(3) Y(3)],[Z(5) Z(5)]);
% 
% line([X(1) X(1)],[Y(1) Y(3)],[Z(1) Z(1)]);
% line([X(1) X(1)],[Y(1) Y(3)],[Z(5) Z(5)]);
% line([X(2) X(2)],[Y(1) Y(3)],[Z(1) Z(1)]);
% line([X(2) X(2)],[Y(1) Y(3)],[Z(5) Z(5)]);
% 
% line([X(1) X(1)],[Y(1) Y(1)],[Z(1) Z(5)]);
% line([X(1) X(1)],[Y(3) Y(3)],[Z(1) Z(5)]);
% line([X(2) X(2)],[Y(1) Y(1)],[Z(1) Z(5)]);
% line([X(2) X(2)],[Y(3) Y(3)],[Z(1) Z(5)]);


end


