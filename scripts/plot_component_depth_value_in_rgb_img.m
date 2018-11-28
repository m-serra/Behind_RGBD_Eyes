function plot_component_depth_value_in_rgb_img(depth_img, rgb_img, component_indices)

    for j = 1:1

            [y, x] = ind2sub(size(rgb_img(:,:,1)), component_indices);

            for i = 1:length(y)
                d(i) = depth_img(y(i), x(i));
                color = interp1([2,5],[0,255],depth_img(y(i), x(i)));
                rgb_img(y(i), x(i), :) = [color 100 50];
            end
    end
    
    imshow(uint8(rgb_img));
    
end
    