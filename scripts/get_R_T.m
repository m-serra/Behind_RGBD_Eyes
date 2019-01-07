function [ R, T ] = get_R_T( grayseq_cam1, grayseq_cam2, dseq_cam1, dseq_cam2, cam_params, ransac_frames )

% matches_3D contains matched points from 2 cams, to calculate R and T.
% first 3 columns are the coordinates in cam1 referential (columns 1,2,3)
% last 3 columns are the coordinates in cam2 referential (columns 4,5,6)
% contains as many rows as matched pair points;
% For robustness, we will use points from the first and last frame. Note
% that one frame would be enough, but if the chosen frame has few
% keypoints, it might be helpful to have a second frame, hopefully with
% different keypoints
matches_3D = [];

for frame=ransac_frames
    % 1.1) Find keypoints for the pair of images (cam1,cam2)
    % key point detection using SIFT:
    % check http://www.vlfeat.org/overview/sift.html for detais
    peak_thresh = 0;
    edge_thresh = 20;
    [f_cam1, d_cam1] = vl_sift(single(grayseq_cam1(:,:,frame)),...
                                'PeakThresh', peak_thresh, 'edgethresh', edge_thresh);
    [f_cam2, d_cam2] = vl_sift(single(grayseq_cam2(:,:,frame)),...
                                'PeakThresh', peak_thresh, 'edgethresh', edge_thresh);
    
    % 1.2) Match keypoints
    % we can apply a 1st filter at this stage to remove noisy matches from
    % the beggining, by reducing the threshold 
    % Note: vl_ubcmatch returns the indexes of the SIFT identified points,
    % not the indices of the real points. 
    % Check http://www.vlfeat.org/overview/sift.html for complete info
 
    match_threshold = 2.5; % 1.5 is the default value
    [matches, scores] = vl_ubcmatch(d_cam1, d_cam2, match_threshold);
    matches = round([f_cam1(1:2,matches(1,:))' f_cam2(1:2,matches(2,:))']);
    
    % plotting
    % plot_sift(grayseq_cam1(:,:,frame),grayseq_cam2(:,:,frame), matches);
    
    % Convert points in 3D coordinates in the corresponding frame
    u_cam1_rgb = matches(:,1); v_cam1_rgb = matches(:,2);
    u_cam2_rgb = matches(:,3); v_cam2_rgb = matches(:,4);
    
    cam1_3D = rgb_to_xyz([u_cam1_rgb v_cam1_rgb], dseq_cam1(:,:,frame),cam_params);
    cam2_3D = rgb_to_xyz([u_cam2_rgb v_cam2_rgb], dseq_cam2(:,:,frame),cam_params);
        
    matches_3D = [matches_3D; [cam1_3D' cam2_3D']]; 
    
    if size(matches_3D,1) > 25
        break
    end
    
end

% 1.3) Filter out outlier matches by applying RANSAC method
% At this stage we have all the pair points in the variable matches_3D. See
% variable description next to its first instantiation. 

% S = log(1-P)/log(1-p^k)
% P = probability of success
% p = inliers ratio
% k = minimum points for estimate
P = 0.99;
p = 0.5;
k = 4;
max_iter = round(log10(1-P) / log10(1-p^k));

inliers = ransac_procrustes(matches_3D, max_iter);

% 1.4) Fit R and T using pair points obtained after applying RANSAC in 1.3
% We should use PROCRUSTES solution
[~, ~, tr] = procrustes(inliers(:,1:3), inliers(:,4:6), 'Scaling',false,...
                        'Reflection',false);
                    
% Checking total error:
predicted_cam1 = matches_3D(:,4:6)*tr.T + ...
                            repmat(tr.c(1,:),size(matches_3D, 1),1);
diff = matches_3D(:,1:3) - predicted_cam1;
error = sqrt(sum(diff.^2,2));
total_wrong_matches = sum(double(error>0.25));

R = tr.T';
T = tr.c(1,:)';


end

