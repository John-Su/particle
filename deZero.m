%% 去掉粒子边缘，确定粒子形状
function [temp, d] = deZero(temp)

[x,y] = size(temp);
dx1 = 0;
dx2 = 0;
dy1 = 0;
dy2 = 0;
while length(find(temp(1,:) == 1)) < length(temp(1,:)) * 0.1   %从左开始探测，如果全零则当做粒子外围，删除
    temp(1,:) = [];
    dx1 = dx1 + 1;
end

while length(find(temp(end,:) == 1)) < length(temp(end,:)) * 0.1
    temp(end,:) = [];
    dx2 = dx2+1;
end

while length(find(temp(:,1) == 1)) < length(temp(:,1)) * 0.1
    temp(:,1) = [];
    dy1 = dy1+1;
end

while length(find(temp(:,end) == 1)) < length(temp(:,end)) * 0.1
    temp(:,end) = [];
    dy2 = dy2+1;
end

[x1,y1] = size(temp);
x = x-x1;
y = y-y1;
d = [dx1,dx2,dy1,dy2];

