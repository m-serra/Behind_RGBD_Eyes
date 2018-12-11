function box = intersectBoxes3d(box1, box2)
    
    b1_x_min = box1(1,1);
    b1_x_max = box1(1,2);
    b1_y_min = box1(1,3);
    b1_y_max = box1(1,4);
    b1_z_min = box1(1,5);
    b1_z_max = box1(1,6);
    
    b2_x_min = box2(1,1);
    b2_x_max = box2(1,2);
    b2_y_min = box2(1,3);
    b2_y_max = box2(1,4);
    b2_z_min = box2(1,5);
    b2_z_max = box2(1,6);
    
    % intersection in x coordinate
    if b2_x_min <= b1_x_max &&  b1_x_max <= b2_x_max
        intersect_x_max = b1_x_max;
        intersect_x_min = max(b1_x_min, b2_x_min);
    elseif b1_x_min <= b2_x_max && b2_x_max <= b1_x_max
        intersect_x_max = b2_x_max;
        intersect_x_min = max(b1_x_min, b2_x_min);
    else
        box = -1;
        return
    end
    
    % intersection in y coordinate
    if b2_y_min <= b1_y_max && b1_y_max <= b2_y_max
        intersect_y_max = b1_y_max;
        intersect_y_min = max(b1_y_min, b2_y_min);
    elseif b1_y_min <= b2_y_max && b2_y_max <= b1_y_max
        intersect_y_max = b2_y_max;
        intersect_y_min = max(b1_y_min, b2_y_min);
    else
        box = -1;
        return
    end
    
    % intersection in z coordinate
    if b2_z_min <= b1_z_max && b1_z_max <= b2_z_max
        intersect_z_max = b1_z_max;
        intersect_z_min = max(b1_z_min, b2_z_min);
    elseif b1_z_min <= b2_z_max && b2_z_max <= b1_z_max
        intersect_z_max = b2_z_max;
        intersect_z_min = max(b1_z_min, b2_z_min);
    else
        box = -1;
        return
    end
    
    box = [intersect_x_min intersect_x_max intersect_y_min intersect_y_max intersect_z_min intersect_z_max];
    return 
    
end