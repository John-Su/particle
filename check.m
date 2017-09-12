[X,Y] = meshgrid(1:1024,1:1024);
cam = [reshape(X,1024*1024,1),reshape(Y,1024*1024,1),ones(1024*1024,1)]';
phyA = CA * cam;
camB = CB\phyA;
phyB = CB * camB;
camA = CA\phyB;
max(max(abs(cam-camA)))

