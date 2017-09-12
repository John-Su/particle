function [X_A,Y_A,X_B,Y_B,CAX,CAY,CBX,CBY,CA,CB] = cameraMatch(c1,c2,deltax,deltay)
%% 双相机同时标定到同一靶盘
% deltax = 0.0025;
% deltay = 0.0025;
%% 识别靶盘标记点
m = 20;
n = 30;
m1 = 35;
n1 = 45;
assert(size(c1,1) == size(c2,1));
if (size(c1,1)~=1024)
    c1 = imresize(c1,1024/size(c1,1));
    c2 = imresize(c2,1024/size(c2,1));
end
if (size(c1,3) ~= 1)
    c1 = rgb2gray(c1);
    c2 = rgb2gray(c2);
end
c1 = su_imadjust(c1,20);
c2 = su_imadjust(c2,20);
c2(861:876,695:705)=max(c2(:));
c2(866:876,690:700) = max(c2(:));
c2(857:862,700:705) = max(c2(:));
c2(find(c2<mean(c2(:)*1.05)))=0;

% c1(end-40:end,:) = max(c1(:));
% c2(end-40:end,:) = max(c2(:));
% c1(1:60,:) = max(c1(:));
% c2(1:60,:) = max(c2(:));
% c1 = im2bw(c1,0.3);
% c2 = im2bw(c2,0.3);
% c1(:,1:50) = max(c1(:));
% c2(:,1:50) = max(c2(:));
c2(:,end-40:end) = max(c2(:));
% c1(1:35,:) = max(c1(:));
c1(end-60:end,:) = max(c1(:));
% c2(1:40,:) = max(c2(:));
c2(end-40:end,:) = max(c2(:));

[points_A,rA] = imfindcircles(c1,[m,n],'ObjectPolarity','dark','Sensitivity',0.95);
[points_B,rB] = imfindcircles(c2,[m,n],'ObjectPolarity','dark','Sensitivity',0.97);
[center_A,cA] = imfindcircles(c1,[m1,n1],'ObjectPolarity','dark','Sensitivity',0.93);
[center_B,cB] = imfindcircles(c2,[m1,n1],'ObjectPolarity','dark','Sensitivity',0.965);
center_B = center_B(cB==max(cB),:);
cB = max(cB);
center_A = center_A(cA==max(cA),:);
cA = max(cA);
rA(sqrt((points_A(:,1)-center_A(1)).^2 + (points_A(:,2)-center_A(2)).^2)<cA,:) = [];
rB(sqrt((points_B(:,1)-center_B(1)).^2 + (points_B(:,2)-center_B(2)).^2)<cB,:) = [];
points_B(sqrt((points_B(:,1)-center_B(1)).^2 + (points_B(:,2)-center_B(2)).^2)<cB,:) = [];
points_A(sqrt((points_A(:,1)-center_A(1)).^2 + (points_A(:,2)-center_A(2)).^2)<cA,:) = [];
points_A = [points_A;center_A];
points_B = [points_B;center_B];
rA = [rA;cA];
rB = [rB;cB];

% points_A = refine(c1,points_A,rA);
% points_B = refine(c2,points_B,rB);
% 根据标记点大小识别坐标原点
% points_A1 = points_A + 55;
% points_B1 = points_B + 55;
centerA = points_A(rA == max(rA),:);
centerB = points_B(rB == max(rB),:);
% 按标记点位置整理标记点顺序，形成矩阵形式
[X_A,Y_A] = sortPoints(points_A,1,1);
[X_B,Y_B] = sortPoints(points_B,0.95,0.95);
% X_A = X_A(1:2,:);
% X_B = X_B(1:2,:);
% Y_A = Y_A(1:2,:);
% Y_B = Y_B(1:2,:);
% 获取原点在矩阵形式下的下标
CA = intersect(find(X_A==centerA(:,1)),find(Y_A == centerA(:,2)));
CB = intersect(find(X_B==centerB(:,1)),find(Y_B == centerB(:,2)));
[CAX,CAY] = ind2sub(size(X_A),CA);
[CBX,CBY] = ind2sub(size(X_B),CB);

%% 生成靶盘
[nA,mA] = size(X_A);
[nB,mB] = size(X_B);
[boardAX,boardAY] = meshgrid(1:mA,1:nA);
[boardBX,boardBY] = meshgrid(1:mB,1:nB);
% boardAY = flipud(boardAY);
% boardBY = flipud(boardBY);
boardAX = (boardAX-boardAX(CAX,CAY))*deltax;
boardAY = (boardAY-boardAY(CAX,CAY))*deltay;
boardBX = (boardBX-boardBX(CBX,CBY))*deltax;
boardBY = (boardBY-boardBY(CBX,CBY))*deltay;

%% 小孔成像模型，直接标定，生成变换矩阵
% CA = calib(reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1), reshape(boardAX,nA*mA,1), reshape(boardAY,nA*mA,1),ones(nA*mA,1));
% CB = calib(reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1), reshape(boardBX,nB*mB,1), reshape(boardBY,nB*mB,1),ones(nA*mA,1));
% A = CA*[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1),ones(nA*mA,1)]';
% B = CB*[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1),ones(nB*mB,1)]';
% PAB = CB\A;
% PBA = CA\B;
% max(max(abs(PAB-[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1),ones(nB*mB,1)]')))
% max(max(abs(PBA-[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1),ones(nA*mA,1)]')))


