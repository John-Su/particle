function [up,vp,xp,yp,uf,vf] = stepforward(x,y,u,v,xp,yp,up,vp,d,t,du,dv,ro,miu)
%基于去掉Basset项的BBO方程仿真固定流场下粒子的运动
uf = griddata(x,y,u,xp,yp,'cubic');
vf = griddata(x,y,v,xp,yp,'cubic');
ac_x = griddata(x,y,du,xp,yp,'cubic')/ro;
ac_y = griddata(x,y,dv,xp,yp,'cubic')/ro;
pac_x = griddata(x,y,u,xp+up*t,yp+vp*t,'cubic') - uf;
pac_y = griddata(x,y,v,xp+up*t,yp+vp*t,'cubic') - vf;
pac_x = pac_x/t;
pac_y = pac_y/t;
% stokes_f_x = [];
% stokes_f_y = [];
% Stk = [];
stokes_f_x = 18*miu/d^2/ro/1000*(uf-up);
stokes_f_y = 18*miu/d^2/ro/1000*(vf-vp);
% tao = dissap(x,y,u,v,miu/1000);
% % eta = ((miu/1000)^3./tao).^0.25;
% tao = sqrt(miu/1000./tao);
% tao = griddata(x,y,tao,xp,yp,'cubic');
% eta = griddata(x,y,eta,xp,yp,'cubic');
% Stk = ro*1000*d^2/18/miu./tao;% ro*1000*d*sqrt((uf-up).^2 + (vf-vp).^2)/18/miu;


g_y = 9.8*(ro-1)/ro;
% A = 36*miu/(2*(ro+1)*1000)/d^2;
% B = 3/(2*ro+1)-1;
up_n = up + (ac_x+stokes_f_x) / (1+0.5/ro) *t;
vp_n = vp + (ac_y+stokes_f_y - g_y) / (1+0.5/ro) * t;
% up_n = uf + B/A*ac_x*ro/1.5;
% vp_n = vf + B/A*ac_y*ro/1.5 - (ro-1)*1000*d^2/18/miu*9.8;


xp = xp + (up_n+up)/2*t;
yp = yp + (vp_n+vp)/2*t;
% xp = xp + up_n*t;
% yp = yp + vp_n*t;
up = up_n;
vp = vp_n;
% uf = griddata(x,y,u,xf,yf,'cubic');
% vf = griddata(x,y,v,xf,yf,'cubic');
% xf = xf + uf *t;
% yf = yf + vf * t;
% stokes_f_x = stokes_f_x(1);
% stokes_f_y = stokes_f_y(1);
