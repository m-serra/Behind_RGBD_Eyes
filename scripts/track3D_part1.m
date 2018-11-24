function [ objects ] = track3D_part1( imgseq1, cam_params )
%The function receives the images as inputs and  returns the 8 points describing the time trajectories 
%of the enclosing box of the objects in world (camera) coordinates

imgs_rgb = zeros(480, 640, length(imgseq1)); % cube to put all rgb images converted to grayscale
imgs_depth = zeros(480, 640, length(imgseq1)); % cube to put all depth images

for i = 1:length(imgseq1)
   isstring(imgseq1(i).rgb);
   s = strcat('../datasets/movingpeople/maizena_chocapics1/', imgseq1(i).rgb);
   isstring(s);
end



    for i = 1:length(imgseq1) % iterate all images
        imgs_rgb(:,:,i) = rgb2gray(imread(strcat('../datasets/movingpeople/maizena_chocapics1/', imgseq1(i).rgb)));
        depth_array = load(strcat('../datasets/movingpeople/maizena_chocapics1/', imgseq1(i).depth));
        imgs_depth(:,:,i) = double(depth_array)/1000;

        % plot the images
        figure(1);dg
        subplot(211); imshow(uint8(imgs_rgb(:,:,i)));
        subplot(212); imagesc(imgs_depth(:,:,i));
        colormap(gray);

        pause(0.1);
    end



end

% imgseq1:
%  Array of structures with the name of the files for the RGB and DEPTH images.
%  Each element has the following fields

%  imgseq1(i).rgb - the file name of rgb image i
%  imgseq1(i).depth - the file name of depth image i

%  RGB images are jpg or png (opened with imread() and depth files are matlab files that must be loaded. The depth image is in the depth_array variable (like you did in the lab)

% cam_params:
%{
A structure with the instrinsic and extrinsic camera parameters.
cam_params.Kdepth  - the 3x3 matrix for the intrinsic parameters for depth
cam_params.Krgb - the 3x3 matrix for the intrinsic parameters for rgb
cam_params.R - the Rotation matrix from depth to RGB (extrinsic params)
cam_params.T - The translation from depth to RGB
This is also like you did in the lab, except that everything is in one structure. For example,
cam_params.R should be Rdtorgb that you use in the lab
%}

%{
objects:
An array of structures with the objects detected and the coordinates of the "box" in all frames where each object was detected.
Each element of the  array (say objects(i) ) has the following fields

objects(i). X 	 A matrix with 8 columns and variable number of rows (for each objects(i) ). 
Each row of this matrix represents the 8 X coordinates of the "box" in one frame where the object was detected. 
So if you track the same object for 6 images this matrix should be 6x8
objects(i).Y
	The same as objects(i).X  but with the Y coordinate of the box
objects(i).Z
	The same as objects(i).X but for the Z coordinate of the box
objects(i).frames_tracked
	 An array with the index of all images where the object was detected. The length of this 1D array is the 
    same as the number of rows of objects(i).X . For example,  objects(i).X(3,:) are the 8 X coordinates of 
    the box of object i,  detectedin  image  number objects(i).frames_tracked(3) 
%}