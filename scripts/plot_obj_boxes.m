function plot_obj_boxes(obj, frame, color, width)
    
    for i = 1:length(obj)
        %for frame = 1:length(obj(i).frame)
        if ~ismember(frame,obj(i).frame)
            continue
        end
        frame_index = find(obj(i).frame==frame);
        x_min = min(obj(i).X(frame_index,:));
        x_max = max(obj(i).X(frame_index,:));
        y_min = min(obj(i).Y(frame_index,:));
        y_max = max(obj(i).Y(frame_index,:));
        z_min = min(obj(i).Z(frame_index,:));
        z_max = max(obj(i).Z(frame_index,:));
        
        figure(334);
        %figure (30 + obj(i).frame(frame))
        %title(strcat('Frame ', int2str(obj(i).frame(frame))));
        xlabel('x');
        ylabel('y');
        zlabel('z');
        hold on
        line([x_min x_max],[y_min y_min],[z_min z_min], 'Color', color, 'LineWidth', width);
        line([x_min x_max],[y_min y_min],[z_max z_max], 'Color', color, 'LineWidth', width);
        line([x_min x_max],[y_max y_max],[z_min z_min], 'Color', color, 'LineWidth', width);
        line([x_min x_max],[y_max y_max],[z_max z_max], 'Color', color, 'LineWidth', width);

        line([x_min x_min],[y_min y_max],[z_min z_min], 'Color', color, 'LineWidth', width);
        line([x_min x_min],[y_min y_max],[z_max z_max], 'Color', color, 'LineWidth', width);
        line([x_max x_max],[y_min y_max],[z_min z_min], 'Color', color, 'LineWidth', width);
        line([x_max x_max],[y_min y_max],[z_max z_max], 'Color', color, 'LineWidth', width);

        line([x_min x_min],[y_min y_min],[z_min z_max], 'Color', color, 'LineWidth', width);
        line([x_min x_min],[y_max y_max],[z_min z_max], 'Color', color, 'LineWidth', width);
        line([x_max x_max],[y_min y_min],[z_min z_max], 'Color', color, 'LineWidth', width);
        line([x_max x_max],[y_max y_max],[z_min z_max], 'Color', color, 'LineWidth', width);
    end   
end