function [xx,yy,vxx,vyy] = load_vec(d, vecPath, CA, vec)

[x,y,vx,vy] = importfile1([vecPath, vec(d).name]);

%  DU = griddata(x1,y1,vx1,x+vx,y+vy,'cubic') - vx;
%  DV = griddata(x1,y1,vy1,x+vx,y+vy,'cubic') - vy;
X = CA*[x,y,ones(size(x))]';
XX = CA*[x+vx,y+vy,ones(size(x))]';
XX = XX';
X = X';
xx = X(:,1);
yy = X(:,2);
vxx = XX(:,1)-xx;
vyy = XX(:,2)-yy;
vxx = vxx*500;
vyy = vyy*500;