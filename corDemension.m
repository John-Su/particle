function D = corDemension(x,y,xp,yp,r)

D = zeros(size(x));        %�ֲ�
L = sqrt((max(x(:))-min(x(:)))*(max(y(:))-min(y(:))));   %���߶�

[m,n] = size(x);
for J = 1:n
    for I = 1:m
        D(I,J) = length(find((xp-x(I,J)).^2+(yp-y(I,J)).^2 <= r^2))/pi/r^2/(length(xp)/L^2);
    end
end
% D = D/(L/20)^2;