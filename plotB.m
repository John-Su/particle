[m,y] = size(start_a);
acc_x= [];
acc_y= [];
du = [];
dv = [];
for I = 1:m
b = start_a(I,:);
b = reshape(b,2,y/2);
% c = f_pos(I,:);
% c = reshape(c,2,y/2-1);
% acc_x = [acc_x;diff(diff(b(1,:)))];
% acc_y = [acc_y;diff(diff(b(2,:)))];
% c(:,b(1,:)==0 & b(2,:)==0) = [];
b(:,b(1,:)==0 & b(2,:)==0) = []; 
% up = UP(I,:);
% u = U(I,:);
% vp = VP(I,:);
% v = V(I,:);
% up(UP(I,:)==0 & VP(I,:)==0) = [];
% u(UP(I,:)==0 & VP(I,:)==0) = [];
% v(UP(I,:)==0 & VP(I,:)==0) = [];
% vp(UP(I,:)==0 & VP(I,:)==0) = [];
% up = up(1:end-1);
% vp = vp(1:end-1);
% v = v(1:end-1);
% u = u(1:end-1);
% if length(up) < 10 
%     du(I) = 0;
%     dv(I) = 0;
% else
% du(I)= mean(abs((up-u)./(u+up)*2));
% dv(I) = mean(abs((vp-v)./(v+vp)*2));
% end
% % % figure(1);
plot(b(2,:),b(1,:),'r.');   %粒子
% plot(c(2,:),c(1,:),'g.');   %流体微团
% d = b-c;
% % figure(2);
% % plot(1:length(d),d(1,:));
% % plot(1:length(d),d(2,:),'r');
% plot(1:length(d),sqrt(d(1,:).^2 + d(2,:).^2));
% I
end

[m,n] = size(XP);
for I = 1:m
    plot(XP(I,:),YP(I,:),'y.');
end