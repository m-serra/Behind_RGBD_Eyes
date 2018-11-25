function [ descriptor ] = get_component_descriptor( dimg, rgbimg, indices, cam_params )
%GET_COMPONENTS_DESCRIPTOR Summary of this function goes here
%   Detailed explanation goes here

    size_dimg = size(dimg);
    
    pc = get_point_cloud(dimg(indices),size_dimg,indices',cam_params);
    
    P = [pc.Location(:,1)';pc.Location(:,2)';pc.Location(:,3)'];
    
    niu = cam_params.Krgb * [cam_params.R cam_params.T] * [P;ones(1,size(P,2))];

    % x = miu1 / miu3    y = miu2 / miu3
    x2=round(niu(1,:)./niu(3,:)); 

    y2=round(niu(2,:)./niu(3,:));
    
    component_rgb=zeros(size(P,2),3);
    indsclean=find((x2>=1)&(x2<=641)&(y2>=1)&(y2<=480));
    indscolor=sub2ind([480 640],y2(indsclean),x2(indsclean));
    rgb_img_aux=reshape(rgbimg,[640*480 3]);
    component_rgb(indsclean,:)=rgb_img_aux(indscolor,:)/255;
    component_hsv = rgb2hsv(component_rgb);
    h_histogram = histcounts(component_hsv(:,1),10);
    s_histogram = histcounts(component_hsv(:,2),10);
    descriptor = [h_histogram; s_histogram];
    
%     pc=pointCloud(P', 'color',uint8(component_rgb*255));
%     figure(7); showPointCloud(pc);
%     title('Component rgb');

    
end