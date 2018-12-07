function [ inliers ] = ransac_procrustes( matches_3D, max_iter )
%RANSAC_PROCRUSTES Summary of this function goes here
%   Detailed explanation goes here

inliers = [0 0 0 0 0 0];
for ransac_i=1:max_iter
    % 1. Pick randomly 4 pair of points 
    % note: randperm ensures non repeating indices
    rand_indices = randperm(size(matches_3D, 1),4);
    cam1_points = matches_3D(rand_indices,1:3);
    cam2_points = matches_3D(rand_indices,4:6);
    
    % 2. Procrustes
    [~, ~, tr] = procrustes(cam1_points, cam2_points, 'Scaling',false, ...
                            'Reflection',false);
    
    % 3. Compute error
    predicted_cam1 = matches_3D(:,4:6)*tr.T + ...
                     repmat(tr.c(1,:),size(matches_3D, 1),1);
    diff = matches_3D(:,1:3) - predicted_cam1;
    error = sqrt(sum(diff.^2,2));
    inliers_idx = error<0.2;
    if sum(double(inliers_idx)) > size(inliers,1)
        inliers = [matches_3D(inliers_idx, 1:3) ...
                   matches_3D(inliers_idx, 4:6)];
    end

end


end

