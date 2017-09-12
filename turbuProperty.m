clear;    
rootPath = 'case4\';
resultPath = [strrep(strrep(rootPath,':',''),'\',''),'\result'];
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


start = 402;  % starttig point
stopt = start + 200;
vec = [];
fvec = dir(vecPath);
for I = 1:length(fvec)
    if ~isempty(strfind(fvec(I).name,'dat'))
        vec = [vec,fvec(I)];
    end
end
for pic_num = start:stopt %950:1000 
%%
    load([resultPath, '\trace_', int2str(pic_num), '.mat']);
    [x,y,vx,vy] = importfile1([vecPath, vec(pic_num-1-399).name]);
    X = CA*[x,y,ones(size(x))]';
    XX = CA*[x+vx,y+vy,ones(size(x))]';
    XX = XX';
    X = X';
    xx = X(:,1);
    yy = X(:,2);
    vxx = XX(:,1)-xx;
    vyy = XX(:,2)-yy;
    U = [];
    V = [];
% 
    for J = 1:2:size(start_a,2)
        U = [U,griddata(xx,yy,vxx,start_a(:,J+1),start_a(:,J),'cubic')];
        V = [V,griddata(xx,yy,vyy,start_a(:,J+1),start_a(:,J),'cubic')];
    end
end