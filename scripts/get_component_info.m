function [ frame_components_new ] = get_component_info( cc, dimg, rgbimg, cam_params, frame )

    %if at least one component was identified, then store info
    if cc.NumObjects > 0
        frame_components_new = struct( 'frame',cell(1,cc.NumObjects), ...
                                   'label',cell(1,cc.NumObjects), ...
                                   'indices',cell(1,cc.NumObjects), ...
                                   'descriptor',cell(1,cc.NumObjects), ...
                                   'X',cell(1,cc.NumObjects), ...
                                   'Y',cell(1,cc.NumObjects), ... 
                                   'Z',cell(1,cc.NumObjects));
                               
        %for each component identified, store its info                       
        for i = 1:cc.NumObjects
            frame_components_new(i).frame = frame;
            frame_components_new(i).label = i;
            frame_components_new(i).indices = cc.PixelIdxList{i};
            frame_components_new(i).descriptor = get_component_descriptor(dimg, ...
                rgbimg, cc.PixelIdxList{i}, cam_params);
            %get box coordinates
            [X, Y, Z] = get_box(dimg ,cc.PixelIdxList{i},...
                                cam_params, frame);
            frame_components_new(i).X = X;
            frame_components_new(i).Y = Y;
            frame_components_new(i).Z = Z;
        end
        
    else
        frame_components_new = struct( 'frame',cell(1,cc.NumObjects), ...
                                   'label',cell(1,cc.NumObjects), ...
                                   'indices',cell(1,cc.NumObjects), ...
                                   'descriptor',cell(1,cc.NumObjects), ...
                                   'X',cell(1,cc.NumObjects), ...
                                   'Y',cell(1,cc.NumObjects), ... 
                                   'Z',cell(1,cc.NumObjects));
    end


end

