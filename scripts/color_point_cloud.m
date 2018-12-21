function color_point_cloud(dimg, rgb_img, cam_params, mode, R, T)
    
    Kd = cam_params.Kdepth;
    Krgb = cam_params.Krgb;
    R_d_to_rgb = cam_params.R;
    T_d_to_rgb = cam_params.T;
   
    Z = double(dimg(:)'); % convert from milimeters to meters

    % Compute correspondence between two images in 5 lines of code
    [v u] = ind2sub([480 640],(1:480*640));
    
    P = inv(Kd)*[Z.*u ;Z.*v;Z]; % get 3D coordinates of all points 
    
    % get rgb pixel coordinates of each 3D point in world frame
    niu = Krgb * [R_d_to_rgb T_d_to_rgb] * [P;ones(1,640*480)];        
    u2 = round(niu(1,:)./niu(3,:));
    v2 = round(niu(2,:)./niu(3,:));

    % If you are  MATLAB "proficient"
    im2=zeros(640*480,3);
    indsclean=find((u2>=1)&(u2<=641)&(v2>=1)&(v2<=480));
    indscolor=sub2ind([480 640],v2(indsclean),u2(indsclean));
    im1aux=reshape(rgb_img,[640*480 3]);
    im2(indsclean,:)=im1aux(indscolor,:);
    
    % If you are really a MATLAB Pro(fessional) you can figure out a faster
    % way!
    
    
    if(mode == 'rotate')
        pc=pointCloud(P', 'color',uint8(im2));
        points = pc.Location * R + repmat(T,size(pc.Location, 1), 1); % go from cam2 frame to cam
        showPointCloud(points, pc.Color);
    else
        pc=pointCloud(P', 'color',uint8(im2));
        showPointCloud(pc);
    end

end