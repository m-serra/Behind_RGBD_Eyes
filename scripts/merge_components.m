function [ merged_component ] = merge_components(component1, component2 )
% this function merges two components (their boxes and descriptors)

% merge boxes
x_union = [component1.X(1,:) component2.X(1,:)];
x_min = min(x_union);
x_max = max(x_union);
component1.X(1,:) = [x_min x_max x_max x_min x_min x_max x_max x_min];

y_union = [component1.Y(1,:) component2.Y(1,:)];
y_min = min(y_union);
y_max = max(y_union);
component1.Y(1,:) = [y_min y_min y_max y_max y_min y_min y_max y_max];

z_union = [component1.Z(1,:) component2.Z(1,:)];
z_min = min(z_union);
z_max = max(z_union);
component1.Z(1,:) = [z_min z_min z_min z_min z_max z_max z_max z_max];

% merge descriptors
% get centroid
component1.descriptor{1} = component1.descriptor{1}/2 + component2.descriptor{1}/2;

% sum histogram bin count
component1.descriptor{2} = component1.descriptor{2} + component2.descriptor{2};


merged_component = component1;


end

