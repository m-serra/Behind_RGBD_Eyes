function [] = plot_sift( gray_cam1, gray_cam2, matches )
%PLOT_SIFT Summary of this function goes here
%   Detailed explanation goes here
figure(1)
subplot(121); 
imshow(uint8(gray_cam1));
hold on
plot(matches(:,2),matches(:,1), 'r+', 'MarkerSize', 15, 'LineWidth', 2);

subplot(122); imshow(uint8(gray_cam2));
imshow(uint8(gray_cam2));
hold on
plot(matches(:,4),matches(:,3), 'r+', 'MarkerSize', 15, 'LineWidth', 2);

end

