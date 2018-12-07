% inliers
n_inliers = 20;
C2 = rand(n_inliers,3)*2-1;
[~,~,R]=svd(rand(3,3));
if det(R) == -1
    R=-R;
end
T=rand(3,1);
C1 = C2*R' + repmat(T',n_inliers,1) + rand(n_inliers,3)/10;
C=[C1 C2];

%outliers
n_outliers = 3;
C=[C;rand(n_outliers,3)*2-1 rand(n_outliers,3)*2-1];

[~,~,tr] = procrustes(C1,C2,'Scaling',false,'Reflection',false);

pred_C1 = C2*tr.T + tr.c;

inliers = ransac_procrustes(C, 10);

% %%
% 
% % inliers
% n_inliers = 100;
% A = rand(n_inliers,3)*2-1;
% [~,~,R]=svd(rand(3,3));
% 
% if det(R) == -1
%     R=-R;
% end
% T=rand(3,1);
% B = A*R + repmat(T',n_inliers,1);% + rand(n_inliers,3)/10;
% 
% %outliers
% %n_outliers = 3;
% %C=[C;rand(n_outliers,3)*2-1 rand(n_outliers,3)*2-1];
% 
% [d,Z,tr] = procrustes(B,A,'Scaling',false,'Reflection',false);
% 
% pred_B = A*tr.T + tr.c;
% 
% 
% %inliers = ransac_procrustes(C, 200);