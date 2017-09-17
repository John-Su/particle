clear
% rootPath = 'G:\0Experiments\particles\20170825\phase1_near\case4\speed1_6cm_80m\';
rootPath = 'G:\0Experiments\particles\20170825\phase1_near\speed1_80m\';
% rootPath = 'H:\0Experiment\case4\speed1_6cm_60m\';
% rootPath = 'H:\0Experiment\case1\';
preCalibPath = 'G:\0Experiments\particles\20170825\phase1_near\case4\speed1_6cm_60m\';
resultPath = [rootPath,'result'];
mkdir(resultPath);
matPath = [resultPath,'/mat'];
mkdir(matPath);
resultVepPath = [resultPath,'/vec'];
mkdir(resultVepPath);
f = dir(rootPath);
for I = 1:length(f)
    if ~isempty(strfind(f(I).name,'PIV')) && f(I).isdir == 1
        vecPath = [rootPath , f(I).name , '\'];
    elseif ~isempty(strfind(f(I).name,'C002'))  && f(I).isdir == 1
        picPath = [rootPath , f(I).name , '\'];
    elseif ~isempty(strfind(f(I).name,'calib'))  && f(I).isdir == 1
        calibPath = [rootPath , f(I).name , '\'];
    end
end
try 
    load(['CA_',strrep(strrep(preCalibPath,':',''),'\','')]);
    load(['CB_',strrep(strrep(preCalibPath,':',''),'\','')]);
    disp('Calibration file exists, loading succeeded...')
catch err
    disp('Calibration file not exists, begin to calibrate....');
    [CA, CB] = testC(calibPath);
    save(['CA_',strrep(strrep(rootPath,':',''),'\','')],'CA');
    save(['CB_',strrep(strrep(rootPath,':',''),'\','')],'CB');

end
fpic = dir(picPath);
fvec = dir(vecPath);
pic = [];
vec = [];
for I = 1:length(fpic)
    if ~isempty(strfind(fpic(I).name,'tif'))
         pic = [pic,fpic(I)];
    end
end
for I = 1:length(fvec)
    if ~isempty(strfind(fvec(I).name,'dat'))
        vec = [vec,fvec(I)];
    end
end
%% 初始化参数
t = 0.00002;
d = 0.125e-3;
ro = 2.5;
miu = 1e-3;
xp = [];
yp = [];
vp = [];
up = [];
Up = [];
Vp = [];
fx = [];
fy = [];
XP = [];
YP = [];
Uf = [];
Vf = [];

start = 400;
limit = 200;


% up = start_a(:,4) - start_a(:,2);
% vp = start_a(:,3) - start_a(:,1);
% up = up*500;
% vp = vp*500;
% load([resultPath, '\mat\trace_', int2str(start), '.mat']);
for I = 126:445
    load([resultPath, '\mat\trace_', int2str(I), '.mat']);
    frame_A = double(imread([picPath , pic(I).name]));
    xp = start_a(:,3);
    yp = start_a(:,2);
    if ~isempty(intersect(find(xp==0), find(yp==0)))
        idx = intersect(find(xp==0),find(yp==0));
        xp(idx) =[];
        yp(idx) = [];
    end
    [x,y,u,v] = load_vec(I,vecPath,CA,vec);
%     [x1,y1,u1,v1] = load_vec(I-1,vecPath,CA,vec);
%     iter = 0.002/t;
%     du = (griddata(x,y,u,x+u1/500,y+v1/500,'cubic') - u)/0.002;
%     dv = (griddata(x,y,v,x+u1/500,y+v1/500,'cubic') - v)/0.002;
%     pre_u = up;
%     pre_v = vp;
%     if mod(I,100) == 0 
%         up;
%     end
    disp(I);
%     
%     while iter>0
%         [up,vp,xp,yp,uf,vf] = stepforward(x,y,u,v,xp,yp,up,vp,d,t,du,dv,ro,miu);
%         pre_u((isnan(yp))) = [];
%         pre_v((isnan(yp))) = [];
%         up((isnan(yp))) = [];
%         vp((isnan(yp))) = [];
%         xp((isnan(yp))) = [];
%         if (~isempty(XP))
%           try
%               XP((isnan(yp)),:) = [];
%             YP((isnan(yp)),:) = [];
%             Up((isnan(yp)),:) = [];
%             Vp((isnan(yp)),:) = [];        
%             Uf((isnan(yp)),:) = [];
%             Vf((isnan(yp)),:) = [];
%           catch
%               UP;
%           end
%         end
%         uf((isnan(yp)),:) = [];
%         vf((isnan(yp)),:) = [];
%         yp((isnan(yp))) = [];
%         if mean(mean((abs(up-pre_u)))) + mean(mean((abs(vp-pre_v)))) < 0.000001
%                break;
%         else 
%             pre_u = up;pre_v = vp;
%         end
%         iter = iter-1;
%         if any(isnan(xp(:))) || any(isnan(yp(:)))
%             outx = find(isnan(xp));
%             outy = find(isnan(yp));
%             if ~all(outx==outy)
%                 break;
%             end
%         end
% 
%         
%         temp = [];
%         for J = 1:length(xp)
%             temp = [temp,[xp(J),yp(J)]];
%         end
%     end
    D = corDemension(x,y,xp,yp,0.001);
%     st = strain(x,y,u,v);
%     XP=[XP,xp];
%     YP = [YP,yp];
%     Up = [Up,up];
%     Vp = [Vp,vp];
%     Uf = [Uf,uf];   
%     Vf = [Vf,vf];

    m = sqrt(size(x,1));
    n=m;
    fp = fopen([resultPath,sprintf('/new_vect_%04d.dat',I)],'w');
    fprintf(fp,'TITLE = "Re20000_D0_%d" VARIABLES = "x","y","Vx","Vy","D",\nZONE T="%d",I=%d,J=%d',I,I,m,n);
    X = reshape(x,m*n,1);
    Y = reshape(y,m*n,1);
    UX = reshape(u,m*n,1);
    UY = reshape(v,m*n,1);
    D = reshape(D,m*n,1);
    for J = 1:m*n
        fprintf(fp,'\n%f,%f,%f,%f',X(J),Y(J),UX(J),UY(J),D(J ));
    end
    fclose(fp);
end

[x,y,u,v] = load_vec(I);
uf = interp2(x,y,u,xp,yp);
vf = interp2(x,y,v,xp,yp);

for K = 1:11
    plot(pos(:,2*(K-1)+1),pos(:,2*(K-1)+2),'r.')
end
