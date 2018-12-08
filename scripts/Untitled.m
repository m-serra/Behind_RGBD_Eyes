obj3 = obj2;
for frame=1:20
    for i = 1:length(obj2)
        if ~ismember(frame,obj2(i).frame)
            continue
        end
        frame_index = find(obj2(i).frame==frame);
        for j = 1:8
            A = tr.T'*[obj2(i).X(frame_index,j);obj2(i).Y(frame_index,j);obj2(i).Z(frame_index,j)] + tr.c(1,:)';
            obj3(i).X(frame_index,j) = A(1);
            obj3(i).Y(frame_index,j) = A(2);
            obj3(i).Z(frame_index,j) = A(3);
        end
    end
end


%%
for frame = 1:20
    figure (frame)
    xlabel('x');
    ylabel('y');
    zlabel('z');
    for i=1:length(obj1)
        if ~ismember(frame,obj1(i).frame)
            continue
        end
        frame_index = find(obj1(i).frame==frame);
        
        hold on
        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);
        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);

        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);
        line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
        line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);

        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
        line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
        line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
        line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
        
    end
    
    
    for i=1:length(obj3)
        if ~ismember(frame,obj3(i).frame)
            continue
        end
        frame_index = find(obj3(i).frame==frame);
        
        hold on
        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)]);
        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)]);
        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)]);
        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)]);

        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)]);
        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)]);
        line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)]);
        line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)]);

        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)]);
        line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)]);
        line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)]);
        line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)]);
        
    end
    
end
% figure(1);
% title('Obj1 and Obj2');
% xlabel('x');
% ylabel('y');
% zlabel('z');
% i = 1;
% frame = 1;
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% 
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% 
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% 
% hold on
% i=2;
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,2)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% 
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,1)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,3)],[obj1(i).Z(frame,5) obj1(i).Z(frame,5)]);
% 
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,1) obj1(i).X(frame,1)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,1) obj1(i).Y(frame,1)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% line([obj1(i).X(frame,2) obj1(i).X(frame,2)],[obj1(i).Y(frame,3) obj1(i).Y(frame,3)],[obj1(i).Z(frame,1) obj1(i).Z(frame,5)]);
% 
% i=2;
% frame = 2;
% line([obj3(i).X(frame,1) obj3(i).X(frame,2)],[obj3(i).Y(frame,1) obj3(i).Y(frame,1)],[obj3(i).Z(frame,1) obj3(i).Z(frame,1)]);
% line([obj3(i).X(frame,1) obj3(i).X(frame,2)],[obj3(i).Y(frame,1) obj3(i).Y(frame,1)],[obj3(i).Z(frame,5) obj3(i).Z(frame,5)]);
% line([obj3(i).X(frame,1) obj3(i).X(frame,2)],[obj3(i).Y(frame,3) obj3(i).Y(frame,3)],[obj3(i).Z(frame,1) obj3(i).Z(frame,1)]);
% line([obj3(i).X(frame,1) obj3(i).X(frame,2)],[obj3(i).Y(frame,3) obj3(i).Y(frame,3)],[obj3(i).Z(frame,5) obj3(i).Z(frame,5)]);
% 
% line([obj3(i).X(frame,1) obj3(i).X(frame,1)],[obj3(i).Y(frame,1) obj3(i).Y(frame,3)],[obj3(i).Z(frame,1) obj3(i).Z(frame,1)]);
% line([obj3(i).X(frame,1) obj3(i).X(frame,1)],[obj3(i).Y(frame,1) obj3(i).Y(frame,3)],[obj3(i).Z(frame,5) obj3(i).Z(frame,5)]);
% line([obj3(i).X(frame,2) obj3(i).X(frame,2)],[obj3(i).Y(frame,1) obj3(i).Y(frame,3)],[obj3(i).Z(frame,1) obj3(i).Z(frame,1)]);
% line([obj3(i).X(frame,2) obj3(i).X(frame,2)],[obj3(i).Y(frame,1) obj3(i).Y(frame,3)],[obj3(i).Z(frame,5) obj3(i).Z(frame,5)]);
% 
% line([obj3(i).X(frame,1) obj3(i).X(frame,1)],[obj3(i).Y(frame,1) obj3(i).Y(frame,1)],[obj3(i).Z(frame,1) obj3(i).Z(frame,5)]);
% line([obj3(i).X(frame,1) obj3(i).X(frame,1)],[obj3(i).Y(frame,3) obj3(i).Y(frame,3)],[obj3(i).Z(frame,1) obj3(i).Z(frame,5)]);
% line([obj3(i).X(frame,2) obj3(i).X(frame,2)],[obj3(i).Y(frame,1) obj3(i).Y(frame,1)],[obj3(i).Z(frame,1) obj3(i).Z(frame,5)]);
% line([obj3(i).X(frame,2) obj3(i).X(frame,2)],[obj3(i).Y(frame,3) obj3(i).Y(frame,3)],[obj3(i).Z(frame,1) obj3(i).Z(frame,5)]);