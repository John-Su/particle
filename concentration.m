function [c] = concentration(points_A,frame_A)
c = zeros(size(frame_A));
[m,n] = size(frame_A);
for I = 1:m
    for J = 1:n
        dx = points_A(:,1) - I;
        dy = points_A(:,2) - J;
        d = sqrt(dx.^2 + dy.^2);
        c(I,J) = sum(1./(d+1));
    end
end
% num = [];
% % 
% % 
% r1 = max(abs(points_A(I,1) - m), abs(points_A(I,1)-1));
% r2 = max(abs(points_A(I,2) - n), abs(points_A(I,2) -1 ));
% r = sqrt(r1^2+r2^2);
% %     r1 = min(abs(points_A(I,1) - m), abs(points_A(I,1)-1));
% %     r2 = min(abs(points_A(I,2) - n), abs(points_A(I,2) -1 ));
% %     rr = sqrt(r1^2+r2^2);
% dx = points_A(:,1) - points_A(I,1);
% dy = points_A(:,2) - points_A(I,2);
% d = sqrt(dx.^2+dy.^2);
% for R = 5 : r
%     num(R-4) = (length(find(d < R)) -1);
% end
% %     for R = 1:rr
% %         numm(R) = length(find(d < R));
% %     end
% R = 5:r;
% c = mean(d);
