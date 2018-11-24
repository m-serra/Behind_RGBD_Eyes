function [ newdimg ] = correct_depth( dimg )
%CORRECTDEPTH Summary of this function goes here
%   Detailed explanation goes here
        % remove zeros test
        [gr, gc, gv] = find(dimg);
        F = scatteredInterpolant(gr(1:100:end), gc(1:100:end), gv(1:100:end),'nearest');
        [br, bc] = find(~dimg);
        replacements = F(br, bc);
        dimg( sub2ind(size(dimg), br, bc)) = replacements;
        newdimg = dimg;

end

