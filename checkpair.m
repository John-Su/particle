clear;
clear;    
% rootPath = 'G:\0Experiments\particles\20170825\phase1_near\case4\speed1_6cm_60m\';
rootPath = 'G:\0Experiments\particles\20170825\phase1_near\speed1_80m\';
% rootPath = 'H:\0Experiment\case4\speed1_6cm_60m\';
% rootPath = 'H:\0Experiments\particles\20170825\phase1_near\speed2_100m\';
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
start = 1;  % starttig point
% first = start-400;
stopt = start + 2000;
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
try
    load([rootPath,'result\meanPic']);
    disp('loading meanPic succeeded');
catch
    meanPic = zeros(1024,1024);
    for I = 1:10:2500
        frame_A = double(imread([picPath , pic(I).name]));
        meanPic = meanPic + frame_A;
    end
    meanPic = meanPic/250;
    save([rootPath,'result\meanPic'], 'meanPic');
end

for pic_num = start:stopt %950:1000 
%%
% if pic_num == start
%     pic_num = 146;
% end
% [xx,yy,vx1,vy1] = load_vec(pic_num+1, vecPath,CA,vec);
%  DU = griddata(x1,y1,vx1,x+vx,y+vy,'cubic') - vx;
%  DV = griddata(x1,y1,vy1,x+vx,y+vy,'cubic') - vy;
% DU = griddata(xx,yy,vx1,xx+vxx,yy+vyy,'cubic') - vxx;
% DV = griddata(xx,yy,vy1,xx+vxx,yy+vyy,'cubic') - vyy;
% Eup1 = vxx - st*(vx1-vxx)*500;
% Evp1 = vyy - st*(vy1-vyy)*500;
% Eup = vxx - st*DU*500;
% Evp = vyy - st*DV*500;

%%
%  [x2,y2,vx2,vy2] = importfile([vec_path, sprintf('B00%03d.dat',pic_num-first+3)]);
% % frame_A(1014:1024,:) = 0;
% frame_B(1014:1024,:) = 0;

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


if exist('points_B','var')
    frame_A = frame_B;
    frame_B = double(imread([picPath , pic(pic_num+1).name]));
%     frame_B = frame_B -meanPic;
    [gray,b] = hist(frame_B(:));
    if (gray(end) < 1000)
        continue;
    end
%      frame_B = frame_B +meanPic;
    points_A = points_B;
    r1 = r2;
    savetemp = [points_A,r1];
    save([resultPath,'\points','_',num2str(pic_num)],'savetemp');
    tic;
        [points_B,r2] = par_identify(frame_B,theta, meanPic);
        points_B(r2<1.5,:) = [];
        r2(r2<1.5) = [];
        disp('identifying particles takes up:');
    toc;
else
    %     A = su_imadjust(frame_A,3);
    %     frame_A = A;
    %     A = su_imadjust(frame_B,3);
    %     frame_B = A;
    frame_A = double(imread([picPath , pic(pic_num).name]));
    frame_B = double(imread([picPath , pic(pic_num+1).name]));
%     frame_A = frame_A - meanPic;
    [gray,b] = hist(frame_A(:));
    if (gray(end) < 1000)
        continue;
    end
%     frame_A = frame_A + meanPic;
    tic;
    [points_A,r1] = par_identify(frame_A,theta, meanPic); 
    disp('identifying particles takes up: ');
    toc;
    points_A(r1<1.5,:) = [];
    r1(r1<1.5) = [];
    savetemp = [points_A,r1];
    save([resultPath,'\points','_',num2str(pic_num)],'savetemp');
    [points_B,r2] = par_identify(frame_B,theta, meanPic);
    points_B(r2<1.5,:) = [];
    r2(r2<1.5) = [];
   
end
 tic;
    [xx,yy,vxx,vyy] = load_vec(pic_num,vecPath,CA,vec);
    disp('loading vectors takes up:');
toc;
vec_size = sqrt(length(xx));
% D = corDemension(X,Y,points_A(:,1),points_A(:,2));
% continue;

if min(length(points_B),length(points_A)) < 50  %% Particle identified is too few
    continue;
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
            a = [a;[r(end),p_a,p_b,v_b-v_a]];
            pre_a = [pre_a;[points_B(I,2),points_B(I,1),v_b-v_a]];
        end
%     else
%         a = [a;[PB(I,:),[0,0],[0,0]]];
    end
end

a(a(:,2)==0,:) = [];
a(a(:,4)==0,:) = [];
a = unique(a,'rows');
if rd == 0
    a(sqrt(a(:,6).^2+a(:,7).^2)>6,:) = [];
end

rd = 1;
% disp(length(points_A));
% disp(length(points_B));
% disp(size(a));
% a = tranA(a);
tic;
for I = start:pic_num-1
    if isempty(find(ruleOut == I))
        try
            load([matPath, '\trace_', int2str(I), '.mat']);
            load([matPath,'\fpos_', int2str(I),'.mat']);
        catch
            ruleOut = [ruleOut,I];
            continue;
        end
        pre = size(start_a,2);
        if (I == start)
            disp(size(start_a));
        end
        [start_a,f_pos] = makeUpParticleTrace(start_a, a, f_pos);
        if pre < size(start_a,2)
            Ux = griddata(xx,yy,vxx,start_a(:,end),start_a(:,end-1),'cubic');
            Uy = griddata(xx,yy,vyy,start_a(:,end),start_a(:,end-1),'cubic');
            f_pos = [f_pos,[f_pos(:,end-1),f_pos(:,end)]+[Uy*0.002,Ux*0.002]];
            save([matPath,'\trace_', int2str(I),'.mat'],'start_a');
            save([matPath,'\fpos_',int2str(I),'.mat'],'f_pos');
        else
            ruleOut = [ruleOut, I];
        end
    end
end
disp('making up trace takes: ');
toc;
start_a =a(:,1:end-2);
f_pos = a(:,1:2);
save([matPath,'\trace_', int2str(pic_num),'.mat'],'start_a');
save([matPath,'\fpos_', int2str(pic_num),'.mat'],'f_pos');

D = corDemension(xx,yy,a(:,3),a(:,2),0.001);
fp = fopen([resultVepPath,sprintf('/vect_%04d.dat',pic_num)],'w');
% fprintf(fid,'TITLE = "Re20000_D0_%d" VARIABLES = "x","y","Vx","Vy",\nZONE T="%d",I=%d,J=%d',K,K,len,hight);
fprintf(fp,'TITLE = "Re20000_D0" VARIABLES = "x","y","Vx","Vy","D",\nZONE T = "1",I=%d,J=%d',vec_size,vec_size);
for I = 1:vec_size^2
    fprintf(fp,'\n%f,%f,%f,%f',xx(I),yy(I),vxx(I),vyy(I), D(I));
end
fclose(fp);

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
% savetemp = [a(:,[1,2]);

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
