function [CA,CB] = testC(path)
f = dir(path);
for I = 1:length(f)
    if ~isempty(strfind(f(I).name,'C001')) && f(I).isdir == 1
        path1 = [path , f(I).name , '\'];
    elseif ~isempty(strfind(f(I).name,'C002')) && f(I).isdir == 1
        path2 = [path , f(I).name , '\'];
    end
end
XA = [];
YA = [];
XB = [];
YB = [];
AX = {};
AY = {};
BX = {};
BY = {};
A = [];
B = [];
n = 0;
f1 = dir(path1);
f2 = dir(path2);
% f = dir(path);
for I = 1:length(f1)
% for I = 1:2:length(f)
    deltax = 0.005;
    deltay = deltax;
    if f1(I).isdir ~=1 && ~isempty(strfind(f1(I).name,'tif'))
        c1 = imread(strcat(path1, f1(I).name));
        c2 = imread(strcat(path2, f2(I).name));
%         c2 = su_imadjust(c2,20);
%         imwrite(c2,f2(I).name,'tif','Compression','none')
%         continue;
%         c1 = imread(strcat(path,f(I).name));
%         c2 = imread(strcat(path,f(I+1).name));
        
        n
        if n == 34
            n;
        end
        [X_A,Y_A,X_B,Y_B,CAX,CAY,CBX,CBY] = cameraMatch(c1,c2,deltax,deltay);
        
%         AX{end+1} = X_A;
%         AY{end+1} = Y_A;
%         BX{end+1} = X_B;
%         BY{end+1} = Y_B;
        if isempty(XA) 
            XA = X_A;
            YA = Y_A;
            XB = X_B;
            YB = Y_B;
%             A = CA;
%             B = CB;
        else
            if(mean(mean(abs(XA/n-X_A)))) > 0.5 || (mean(mean(abs(XB/n-X_B)))) > 0.5 || (mean(mean(abs(YB/n-Y_B)))) > 0.5 || (mean(mean(abs(YA/n-Y_A)))) > 0.5
               continue;
            else
                XA = XA + X_A;
                YA = YA + Y_A;
                XB = XB + X_B;
                YB = YB + Y_B;
            end
%             A = A + CA;
%             B = B + CB;
        end
         n = n+1;
        if n == 50
            break;
        end
    end
end
X_A = XA/n;
Y_A = YA/n;
X_B = XB/n;
Y_B = YB/n;
% AA = A / n;
% BB = B / n;
%% 生成靶盘
% X_A = X_A(1:end-1,:);
% Y_A = Y_A(1:end-1,:);
% X_B = X_B(1:end-1,:);
% Y_B = Y_B(1:end-1,:);
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
CA = calib(reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1), reshape(boardAX,nA*mA,1), reshape(boardAY,nA*mA,1),ones(nA*mA,1));
CB = calib(reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1), reshape(boardBX,nB*mB,1), reshape(boardBY,nB*mB,1),ones(nA*mA,1));
A = CA*[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1),ones(nA*mA,1)]';
B = CB*[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1),ones(nB*mB,1)]';
PAB = CB\A;
PBA = CA\B;
a = abs(PAB(1:2,:)-[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1)]');
b = abs(PBA(1:2,:)-[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1)]');
max(a(:))
max(b(:))
mean(a(:))
mean(b(:))
median(a(:))
median(b(:))

% CA = AA;
% CB = BB;
% A = CA*[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1),ones(nA*mA,1)]';
% B = CB*[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1),ones(nB*mB,1)]';
% PAB = CB\A;
% PBA = CA\B;
% max(max(abs(PAB(1:2,:)-[reshape(X_B,nB*mB,1), reshape(Y_B,nB*mB,1)]')))
% max(max(abs(PBA(1:2,:)-[reshape(X_A,nA*mA,1), reshape(Y_A,nA*mA,1)]')))