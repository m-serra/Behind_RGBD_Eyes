function [obj3] = transform_object( obj2, R, T, n_frames)

% R=tr.T' T=tr.c(1,:)'
% convert obj2 to cam1 reference frame
obj3 = obj2;
for frame=1:n_frames
    for i = 1:length(obj2)
        if ~ismember(frame,obj2(i).frame)
            continue
        end
        frame_index = find(obj2(i).frame==frame);
        for j = 1:8
            A = R*[obj2(i).X(frame_index,j);obj2(i).Y(frame_index,j);obj2(i).Z(frame_index,j)] + T;
            obj3(i).X(frame_index,j) = A(1);
            obj3(i).Y(frame_index,j) = A(2);
            obj3(i).Z(frame_index,j) = A(3);
        end
    end
end

end