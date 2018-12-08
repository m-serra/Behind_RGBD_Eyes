function [ objects ] = match_boxes( obj1, obj2, n_frames )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% 1 - ratio -> intersection ratio
ratio_threshold = 0.7;

new_objects = struct( 'frame',cell(1,1), ...
                                   'X',cell(1,1), ...
                                   'Y',cell(1,1), ... 
                                   'Z',cell(1,1));

new_objects_count = 0;
ratio = zeros(length(obj1),length(obj2));
% matching between obj1 and obj3
for frame=1:n_frames
    for i=1:length(obj1)
        %check whether object is in frame
        if ~ismember(frame,obj1(i).frame)
            continue
        end
        
        % obj1_frame_index
        ii = find(obj1(i).frame==frame);
        
        box1 = [min(obj1(i).X(ii,:)) max(obj1(i).X(ii,:)) min(obj1(i).Y(ii,:)) max(obj1(i).Y(ii,:)) min(obj1(i).Z(ii,:)) max(obj1(i).Z(ii,:))];
        % volume
        vol1 = prod(box1(:,2:2:end) - box1(:,1:2:end) ,2 );
        for j=1:length(obj2)
           %check whether object is in frame
            if ~ismember(frame,obj2(j).frame)
                continue
            end 
            
            % obj2_frame_index
            jj = find(obj2(i).frame==frame);
            
            box2 = [min(obj2(j).X(jj,:)) max(obj2(j).X(jj,:)) min(obj2(j).Y(jj,:)) max(obj2(j).Y(jj,:)) min(obj2(j).Z(jj,:)) max(obj2(j).Z(jj,:))];
            % volume
            vol2 = prod(box2(:,2:2:end) - box2(:,1:2:end) ,2 );
            
            common_box = intersectBoxes3d(box1, box2);
            if common_box == -1
                continue
            end
            % volume
            vol_c = prod(common_box(:,2:2:end) - common_box(:,1:2:end) ,2 );
            
            ratio(i,j) = 1 - (vol_c / (min(vol1, vol2)));
            
        end
        
    end
    % Hungarian algorithm to find the best component assigment
    assignment = munkres(ratio);
    
    for i=1:length(assignment)
       
        
        % if the component in the first frame doesn't belong to a component
        % in the next frame (associated to a low cost value)
        if (assignment(i) == 0 || ratio(i,assignment(i)) > ratio_threshold)
            continue
        else
            new_objects_count = new_objects_count + 1;
            new_objects(new_objects_count).frame = union(obj1(i).frame, obj2(assignement(i)).frame);
            
            for k=1:length(new_objects(new_objects_count).frame)
                
            end
            new_objects(new_objects_count).X = frame_components_old(i).X;
            new_objects(new_objects_count).Y = frame_components_old(i).Y;
            new_objects(new_objects_count).Z = frame_components_old(i).Z;
        end
    end
    
end


%% pseudo code
    
    k=0;
    loop frame
    
        loop i in obj1

            check if i in frame (if not, ratio = 1)

            loop j in obj2
            
                check if j in frame (if not, ratio = 1)
                
                calc ratio(i,j)
                
        assignement = munkres(ratio(:,:));
        
        loop h in assignment
        
            check assignement < threshold
                
                k++
                new_objects(k).frame = union(frames1, frames2);
                
                loop l in new_objects(k).frame
                    
                    boolean one is l in obj1.frame
                    boolean two is l in obj2.frame
                    
                    if one and two
                        
                        new_objects(k).coords = mergeboxes(obj1, obj2) with respetive indexes
                        
                            
                    elif one
                        
                        new_objects(k).coords = box(obj1) with respetive indexes
                        
                    else
                         
                        new_objects(k).coords = box(obj2) with respetive indexes
                        
             remove matched objects h from obj1, assignment(h) from obj2
                        
                    
                        
                    
                
        

















%% draw boxes
% for frame = 1:20
%     figure (frame)
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
%     for i=1:length(obj1)
%         if ~ismember(frame,obj1(i).frame)
%             continue
%         end
%         frame_index = find(obj1(i).frame==frame);
%         
%         hold on
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);
% 
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);
%         line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,1)]);
%         line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,5) obj1(i).Z(frame_index,5)]);
% 
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
%         line([obj1(i).X(frame_index,1) obj1(i).X(frame_index,1)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
%         line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,1) obj1(i).Y(frame_index,1)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
%         line([obj1(i).X(frame_index,2) obj1(i).X(frame_index,2)],[obj1(i).Y(frame_index,3) obj1(i).Y(frame_index,3)],[obj1(i).Z(frame_index,1) obj1(i).Z(frame_index,5)]);
%         
%     end
%     
%     
%     for i=1:length(obj3)
%         if ~ismember(frame,obj3(i).frame)
%             continue
%         end
%         frame_index = find(obj3(i).frame==frame);
%         
%         hold on
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)],'Color','red');
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)],'Color','red');
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)],'Color','red');
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)],'Color','red');
% 
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)],'Color','red');
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)],'Color','red');
%         line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,1)],'Color','red');
%         line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,5) obj3(i).Z(frame_index,5)],'Color','red');
% 
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)],'Color','red');
%         line([obj3(i).X(frame_index,1) obj3(i).X(frame_index,1)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)],'Color','red');
%         line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,1) obj3(i).Y(frame_index,1)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)],'Color','red');
%         line([obj3(i).X(frame_index,2) obj3(i).X(frame_index,2)],[obj3(i).Y(frame_index,3) obj3(i).Y(frame_index,3)],[obj3(i).Z(frame_index,1) obj3(i).Z(frame_index,5)],'Color','red');
%         
%     end
%     
% end

end

