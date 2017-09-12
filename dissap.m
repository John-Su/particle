function vor = dissap(x,y,u,v,miu)  %   (duidj+dujdi).^2

[X,Y] = size(x);
if X == 1 || Y == 1
    X = sqrt(length(x));
    Y = sqrt(length(y));
    x = reshape(x,X,Y);
    y = reshape(y,X,Y);
    u = reshape(u,X,Y);
    v = reshape(v,X,Y);
    x=flipud(x');y=flipud(y');u=flipud(u');v=flipud(v');
end
vor = u;
for I = 1:Y
    for J = 1:X
        if I == 1 && J ==1
            vor(I,J) = 2*((v(I,J+1)-v(I,J))/(x(I,J+1)-x(I,J)) + (u(I+1,J)-u(I,J))/(y(I+1,J)-y(I,J))).^2 + 4*((u(I,J+1)-u(I,J))/(x(I,J+1)-x(I,J))).^2 + 4*((v(I+1,J)-v(I,J))/(y(I+1,J)-y(I,J))).^2;
        elseif I==1 && J == X
            vor(I,J) = 2*((v(I,J)-v(I,J-1))/(x(I,J)-x(I,J-1)) + (u(I+1,J)-u(I,J))/(y(I+1,J)-y(I,J))).^2 + 4*((u(I,J)-u(I,J-1))/(x(I,J)-x(I,J-1))).^2 + 4*((v(I+1,J)-v(I,J))/(y(I+1,J)-y(I,J))).^2;
        elseif I == 1 && J ~=1 && J~=X
            vor(I,J) = 2*((v(I,J+1)-v(I,J-1))/(x(I,J+1)-x(I,J-1)) + (u(I+1,J)-u(I,J))/(y(I+1,J)-y(I,J))).^2 + 4*((u(I,J+1)-u(I,J-1))/(x(I,J+1)-x(I,J-1))).^2 + 4*((v(I+1,J)-v(I,J))/(y(I+1,J)-y(I,J))).^2;
        elseif I == Y && J == 1
            vor(I,J) = 2*((v(I,J+1)-v(I,J))/(x(I,J+1)-x(I,J)) + (u(I,J)-u(I-1,J))/(y(I,J)-y(I-1,J))) .^2 + 4*((u(I,J+1)-u(I,J))/(x(I,J+1)-x(I,J))).^2 + 4*((v(I,J)-v(I-1,J))/(y(I,J)-y(I-1,J))).^2;
        elseif I == Y && J == X
            vor(I,J) = 2*((v(I,J)-v(I,J-1))/(x(I,J)-x(I,J-1)) + (u(I,J)-u(I-1,J))/(y(I,J)-y(I-1,J))).^2 + 4*((u(I,J)-u(I,J-1))/(x(I,J)-x(I,J-1))).^2 + 4*((v(I,J)-v(I-1,J))/(y(I,J)-y(I-1,J))).^2;
        elseif I == Y && J~=1 && J~= X
            vor(I,J) = 2*((v(I,J+1) - v(I,J-1))/(x(I,J+1)-x(I,J-1)) + (u(I,J) - u(I-1,J))/(y(I,J) - y(I-1,J))).^2 + 4*((u(I,J+1) - u(I,J-1))/(x(I,J+1)-x(I,J-1))).^2 + 4*((v(I,J) - v(I-1,J))/(y(I,J) - y(I-1,J))).^2;
        elseif I ~= 1 && I ~= Y && J == 1
            vor(I,J) = 2*((v(I,J+1) - v(I,J))/(x(I,J+1)-x(I,J)) + (u(I+1,J) - u(I-1,J))/(y(I+1,J) - y(I-1,J))).^2 + 4*((u(I,J+1) - u(I,J))/(x(I,J+1)-x(I,J))).^2 + 4*((v(I+1,J) - v(I-1,J))/(y(I+1,J) - y(I-1,J))).^2;
        elseif I ~= 1 && I~= Y && J == X
            vor(I,J) = 2*((v(I,J) - v(I,J-1))/(x(I,J)-x(I,J-1)) + (u(I+1,J) - u(I-1,J))/(y(I+1,J) - y(I-1,J))).^2 + 4*((u(I,J) - u(I,J-1))/(x(I,J)-x(I,J-1))).^2 + 4*((v(I+1,J) - v(I-1,J))/(y(I+1,J) - y(I-1,J))).^2;
        else
            vor(I,J) = 2*((v(I,J+1) - v(I,J-1))/(x(I,J+1)-x(I,J-1)) + (u(I+1,J) - u(I-1,J))/(y(I+1,J) - y(I-1,J))).^2 + 4*((u(I,J+1) - u(I,J-1))/(x(I,J+1)-x(I,J-1))).^2 + 4*((v(I+1,J) - v(I-1,J))/(y(I+1,J) - y(I-1,J))).^2;
        end
    end
end

vor = miu  * vor;
            
                