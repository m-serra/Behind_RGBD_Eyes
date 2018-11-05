% Code by professor João Paulo Costeira - jpcosteira@tecnico.ulisboa.pt

% load data
im = imread('../img/rgb_image_10.png');
load ../vars/depth_10.mat
load ../vars/CalibrationData.mat

% Intrinsic camera parameters K
Kd = Depth_cam.K;

% Depth information from kinect stratched into a single vector
Z = double(depth_array(:)') / 1000;

% Compute correspondence between two images (rgb and depth) in 5 lines 
% of code

% convert array indexing of 480*640 array to a coordinates of a 
% 480*640 matrix. e.g. ( u(481), v(481) ) = (2,1)
[y, x] = ind2sub([480 640],(1:480*640)); 

% coordinates of points in 3D: [X Y Z]' = Kd^-1 * Z * [x y 1]'
% where Z = miu3 is the depth values captured by the kinect
P = inv(Kd)*[Z.*x;Z.*y;Z];

% miu3[x y 1]' = [miu1 miu2 miu3]' = K[R T][X Y Z 1]'
% [X Y Z]' = P
niu = RGB_cam.K * [R_d_to_rgb T_d_to_rgb] * [P;ones(1,640*480)];

% x = miu1 / miu3    y = miu2 / miu3
x2=round(niu(1,:)./niu(3,:)); 

y2=round(niu(2,:)./niu(3,:));

% Compute new image (RGB and 3D) - the easy understandable way
tic
im3=zeros(size(im));

for i=1:length(y2)

    if ( (y2(i) > 0 & y2(i) < 482) && (x2(i) > 0 & x2(i) < 642) )
        
        yy=max([1 min([y2(i) 480])]);
        
        xx=max([1 min([x2(i) 640])]);
        
        im3(y(i),x(i),:)=im(yy,xx,:);
    end
     
end

fprintf('Normal mode %g seconds \n',toc)

tic

% If you are  MATLAB "proficient"

im2=zeros(640*480,3);

indsclean=find((x2>=1)&(x2<=641)&(y2>=1)&(y2<=480));

indscolor=sub2ind([480 640],y2(indsclean),x2(indsclean));

im1aux=reshape(im,[640*480 3]);

im2(indsclean,:)=im1aux(indscolor,:);

% If you are really a MATLAB Pro(fessional) you can figure out a faster
% way!

fprintf('Fast mode %g seconds \n',toc);

pc=pointCloud(P', 'color',uint8(im2));

figure(1); showPointCloud(pc);

figure(2);imshow(uint8(reshape(im2,[480,640,3])));
