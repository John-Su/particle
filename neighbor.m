function temp = neighbor(img,x,y,w_size)

[X,Y] = size(img);
if x-w_size > 0 && x+w_size <= X && y-w_size > 0 && y+w_size <= Y
    temp = img(x-w_size:x+w_size,y-w_size:y+w_size);
elseif x-w_size < 1 &&  y-w_size > 0 && y+w_size <= Y    %粒子落在左边缘
    temp = img(1:1+2*w_size,y-w_size:y+w_size);
elseif x+w_size > X &&  y-w_size > 0 && y+w_size <= Y    %粒子落在右边缘
    temp = img(X-2*w_size:X,y-w_size:y+w_size);
elseif x-w_size > 0 && x+w_size <= X && y-w_size < 1     %粒子落在下边缘
    temp = img(x-w_size:x+w_size,1:1+2*w_size);
elseif x-w_size > 0 && x+w_size <= X && y+w_size >Y      %粒子落在上边缘
    temp = img(x-w_size:x+w_size,Y-2*w_size:Y);
elseif x-w_size < 1 && y+w_size > Y                      %粒子落在左上角
    temp = img(1:1+2*w_size,Y-2*w_size:Y);
elseif x-w_size < 1 && y-w_size < 1                      %粒子落在左下角
    temp = img(1:1+2*w_size,1:1+2*w_size);
elseif x+w_size > X && y-w_size < 1                      %粒子落在右下角
    temp = img(X-2*w_size:X,1:1+2*w_size);
elseif x+w_size > X && y+w_size > Y                      %粒子落在右上角
    temp = img(X-2*w_size:X,Y-w_size:Y);
end