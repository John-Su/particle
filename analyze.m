clear;
clear;    
rootPath = 'G:\0Experiments\particles\20170825\phase1_near\case4\speed1_6cm_60m\';
resultPath = [strrep(strrep(rootPath,':',''),'\',''),'\result'];
mkdir(resultPath);
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
    load(['CA_',strrep(strrep(rootPath,':',''),'\','')]);
    load(['CB_',strrep(strrep(rootPath,':',''),'\','')]);
    disp('Calibration file exists, loading succeeded...')
catch err
    disp('Calibration file not exists, begin to calibrate....');
    [CA, CB] = testC(calibPath);
    save(['CA_',strrep(strrep(rootPath,':',''),'\','')],'CA');
    save(['CB_',strrep(strrep(rootPath,':',''),'\','')],'CB');

end

pre_a = [];
start_a = [];
f_pos = [];
r = [];
rd = 0;
U = [];
V = [];
dU = [];
dV = [];
UP = [];
VP = [];
EU = [];
EV = [];
EU1 = [];
EV1 = [];
DPT = {};
%% set the partcile Stokes number
d = 0.124/1000;
ro = 2.5*2+1;
st = ro*1000*d^2/36/0.001;
%% Start to compare PIV and PTV
start = 402;  % starttig point
% first = start-400;
stopt = start + 200;
[X,Y] = meshgrid(1:1024,1:1024);
fpic = dir(picPath);
fvec = dir(vecPath);
pic = [];
vec = [];
theta = (1:360)*2*pi/360;
theta = theta';
theta = [theta,zeros(size(theta)),ones(size(theta))];

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
disp('Starting to do PTV, and compare it with PIV');
disp(picPath);
ruleOut = [];
start_a = [];
a = [];
for pic_num = start:stopt %950:1000 
%%
 [x,y,vx,vy] = importfile1([vecPath, vec(pic_num-1-399).name]);
 [x1,y1,vx1,vy1] = importfile1([vecPath, vec(pic_num-399).name]);
%  DU = griddata(x1,y1,vx1,x+vx,y+vy,'cubic') - vx;
%  DV = griddata(x1,y1,vy1,x+vx,y+vy,'cubic') - vy;
 X = CA*[x,y,ones(size(x))]';
 XX = CA*[x+vx,y+vy,ones(size(x))]';
 XX2 = CA*[x+vx1,y+vy1,ones(size(x))]';
XX = XX';
XX2 = XX2';
X = X';
xx = X(:,1);
yy = X(:,2);
vxx = XX(:,1)-xx;
vyy = XX(:,2)-yy;
vx1 = XX2(:,1)-xx;
vy1 = XX2(:,2)-yy;
DU = griddata(xx,yy,vx1,xx+vxx,yy+vyy,'cubic') - vxx;
DV = griddata(xx,yy,vy1,xx+vxx,yy+vyy,'cubic') - vyy;
% Eup1 = vxx - st*(vx1-vxx)*500;
% Evp1 = vyy - st*(vy1-vyy)*500;
Eup = vxx - st*DU*500;
Evp = vyy - st*DV*500;

%%
%  [x2,y2,vx2,vy2] = importfile([vec_path, sprintf('B00%03d.dat',pic_num-first+3)]);
% % frame_A(1014:1024,:) = 0;
% frame_B(1014:1024,:) = 0;
%  vec_size = sqrt(length(x));
%  y = 1025-y;
%  vy = -vy;
%  vy1= -vy1;
%  vy2=-vy2;
%  x1 = x;y1 = y;
%  [vor,seq] = vorticity_vec (x,y,vx,vy);
%  [vor1,seq1] = vorticity_vec (x,y,vx1,vy1);
%  [vor2,seq2] = vorticity_vec (x,y,vx2,vy2);
% vx = fliplr(rot90(reshape(vx,vec_size,vec_size),3));
% vy = fliplr(rot90(reshape(vy,vec_size,vec_size),3));
% x1 = rot90(reshape(x,vec_size,vec_size));
% % y1 = 1025-(rot90(reshape(y,vec_size,vec_size)));
% X = reshape(x,vec_size^2,1);
% Y = reshape(y,vec_size^2,1);
% 
% continue;
% UX = reshape(vx,vec_size^2,1);
% UY = reshape(vy,vec_size^2,1);
% fp = fopen(sprintf('vect_%d.dat',pic_num),'w');
% % fprintf(fid,'TITLE = "Re20000_D0_%d" VARIABLES = "x","y","Vx","Vy",\nZONE T="%d",I=%d,J=%d',K,K,len,hight);
% fprintf(fp,'TITLE = "Re20000_D0" VARIABLES = "x","y","Vx","Vy",\nZONE T = "1",I=%d,J=%d',vec_size,vec_size);
% for I = 1:vec_size^2
%     fprintf(fp,'\n%f,%f,%f,%f',X(I),Y(I),UX(I),UY(I));
% end
% fclose(fp);

if exist('points_B','var')
%     A = su_imadjust(frame_B,3);
%     frame_B = A;
% frame_A = frame_B;
% frame_B = double(imread([picPath , pic(pic_num+1).name]));
    points_A = points_B;
    r1 = r2;
    points_B = load([rootPath , 'I0Experimentsparticles20170819case4\points_' , int2str(pic_num + 1) , '.mat']);
    points_B = points_B.savetemp;
     points_B = inv(CB)*[points_B(:,2),points_B(:,1),ones(size(points_B(:,1)))]';
       points_B = points_B([2 1],:)';
    r2 = ones(size(points_B,1),1);
%     r1 = r2;
%     [points_B,r2] = par_identify(frame_B,par,theta);
%     points_B(r2<1.5,:) = [];
%     r2(r2<1.5) = [];
%     disp(pic_num);
else
%     A = su_imadjust(frame_A,3);
%     frame_A = A;
%     A = su_imadjust(frame_B,3);
%     frame_B = A;
frame_A = double(imread([picPath , pic(pic_num).name]));
frame_B = double(imread([picPath , pic(pic_num+1).name]));
    points_A = load([rootPath , 'I0Experimentsparticles20170819case4\points_' , int2str(pic_num) , '.mat']);
    points_A = points_A.savetemp;
    points_A = inv(CB)*[points_A(:,2),points_A(:,1),ones(size(points_A(:,1)))]';
    points_A = points_A([2 1],:)';
    r1 = ones(size(points_A,1),1);
    points_B = load([rootPath , 'I0Experimentsparticles20170819case4\points_' , int2str(pic_num + 1) , '.mat']);
    points_B = points_B.savetemp;
     points_B = inv(CB)*[points_B(:,2),points_B(:,1),ones(size(points_B(:,1)))]';
    points_B = points_B([2 1],:)';
    r2 = ones(size(points_B,1),1);
end

% D = corDemension(X,Y,points_A(:,1),points_A(:,2));
% continue;

if min(length(points_B),length(points_A)) < 50  %% Particle identified is too few
    break;
end
disp('Particle identifying succeeded, starting to match frame_A and frame_B');
[m,points_A] = matching(points_A,points_B,r1,r2,5,pre_a);
pre_a = [];
disp('Matching succeeded, applying the calibration to the results');
B = CB*[points_B(:,2),points_B(:,1),ones(size(points_B(:,1)))]';
B = B';
PB = B(:,[1,2]);
A = CB*[points_A(:,2),points_A(:,1),ones(size(points_A(:,1)))]';
A = A';
PA = A(:,[1,2]);
[x,y] = size(m);
a = [];
for I = 1:x-1
    idx = find(m(I,:) == max(m(I,:)));
    if idx <= length(PA)
        for J = 1:length(idx)
            v_b = [points_B(I,2),points_B(I,1)];
            v_a = [points_A(idx(J),2),points_A(idx(J),1)];
            p_b = [PB(I,2),PB(I,1)];    
            p_a = [PA(idx(J),2),PA(idx(J),1)];   % Åä¶ÔÁ£×Ó
            if rd == 0
                r = [r,mean([r2(I),r1(idx(J))])];
            end
            a = [a;[p_a,p_b,v_b-v_a]];
            pre_a = [pre_a;[points_B(I,2),points_B(I,1),v_b-v_a]];
        end
%     else
%         a = [a;[PB(I,:),[0,0],[0,0]]];
    end
end

a(a(:,1)==0,:) = [];
a(a(:,3)==0,:) = [];
if rd == 0
    r(sqrt(a(:,5).^2+a(:,6).^2)>6) = [];
end
a(sqrt(a(:,5).^2+a(:,6).^2)>6,:) = [];
a = unique(a,'rows');
rd = 1;
% disp(length(points_A));
% disp(length(points_B));
% disp(size(a));
% a = tranA(a);

for I = start:pic_num-1
    if isempty(find(ruleOut == I))
        load([resultPath, '\trace_', int2str(I), '.mat']);
        load([resultPath,'\fpos_', int2str(I),'.mat']);
        pre = size(start_a,2);
        if (I == start)
            disp(size(start_a));
        end
        [start_a,f_pos] = makeUpParticleTrace(start_a, a, f_pos);
        if pre < size(start_a,2)
            Ux = griddata(xx,yy,vx1,start_a(:,end),start_a(:,end-1),'cubic');
            Uy = griddata(xx,yy,vy1,start_a(:,end),start_a(:,end-1),'cubic');
            f_pos = [f_pos,[f_pos(:,end-1),f_pos(:,end)]+[Uy,Ux]];
            save([resultPath,'\trace_', int2str(I),'.mat'],'start_a');
            save([resultPath,'\fpos_',int2str(I),'.mat'],'f_pos');
        else
            ruleOut = [ruleOut, I];
        end
    elseif (I == start)
            break;
    end
end
start_a = a(:,1:end-2);
f_pos = a(:,1:2);
save([resultPath,'\trace_', int2str(pic_num),'.mat'],'start_a');
save([resultPath,'\fpos_', int2str(pic_num),'.mat'],'f_pos');
   

% Eu = griddata(xx,yy,Eup,start_a(:,end),start_a(:,end-1),'cubic');
% Ev = griddata(xx,yy,Evp,start_a(:,end),start_a(:,end-1),'cubic');
% 
% EU = [EU,Eu];
% EV = [EV,Ev];
% U = [U,Ux];
% V = [V,Uy]; 
% UP = [UP,start_a(:,end)-start_a(:,end-2)];
% VP = [VP,start_a(:,end-1)-start_a(:,end-3)];
% Ux = griddata(xx,yy,vx1,f_pos(:,end),f_pos(:,end-1),'cubic');
% Uy = griddata(xx,yy,vy1,f_pos(:,end),f_pos(:,end-1),'cubic');
% Ux(isnan(Ux)) = 0;
% Uy(isnan(Uy)) = 0;
% 
% pt = [512,950];
% dx = points_A(:,2) - pt(1);
% dy = points_A(:,1) - pt(2);
% 
% DPT{pic_num-start+1} = sqrt(dx.^2 + dy.^2);
% savetemp = a(:,[1,2]);
% save([resultPath,'\points','_',num2str(pic_num)],'savetemp');
if pic_num == 451
    disp(length(a));
end
% imshow(uint16(frame_A*20));
% plot(points_A(:,2),points_A(:,1),'r.')

end
save([resultPath,'\start_a','_',num2str(start),'_',num2str(pic_num)],'start_a');
save([resultPath,'\U','_',num2str(start),'_',num2str(pic_num)],'U');
save([resultPath,'\V','_',num2str(start),'_',num2str(pic_num)],'V');
save([resultPath,'\UP','_',num2str(start),'_',num2str(pic_num)],'UP');
save([resultPath,'\VP','_',num2str(start),'_',num2str(pic_num)],'VP');
save([resultPath,'\EU','_',num2str(start),'_',num2str(pic_num)],'EU');
save([resultPath,'\EV','_',num2str(start),'_',num2str(pic_num)],'EV');
save([resultPath,'\fpos','_',num2str(start),'_',num2str(pic_num)],'f_pos');
