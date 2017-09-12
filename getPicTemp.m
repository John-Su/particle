%% 生成覆盖对应像素点的模板图像，用于剔除此点
function pic_temp = getPicTemp(img,x,y,w_size)

pic_temp = zeros(size(img));
[X,Y] = size(img);
if x-w_size > 0 && x+w_size <= X && y-w_size > 0 && y+w_size <= Y
    pic_temp(x-w_size:x+w_size,y-w_size:y+w_size) = img(x-w_size:x+w_size,y-w_size:y+w_size);
elseif x-w_size < 1 &&  y-w_size > 0 && y+w_size <= Y
    pic_temp(1:x+w_size,y-w_size:y+w_size) = img(1:x+w_size,y-w_size:y+w_size);
elseif x+w_size > X &&  y-w_size > 0 && y+w_size <= Y
    pic_temp(x-w_size:X,y-w_size:y+w_size)= img(x-w_size:X,y-w_size:y+w_size);
elseif x-w_size > 0 && x+w_size <= X && y-w_size < 1
    pic_temp(x-w_size:x+w_size,1:y+w_size) = img(x-w_size:x+w_size,1:y+w_size);
elseif x-w_size > 0 && x+w_size <= X && y+w_size >Y
    pic_temp(x-w_size:x+w_size,y-w_size:Y) = img(x-w_size:x+w_size,y-w_size:Y);
elseif x-w_size < 1 && y+w_size > Y
    pic_temp(1:x+w_size,y-w_size:Y) = img(1:x+w_size,y-w_size:Y);
elseif x-w_size < 1 && y-w_size < 1
    pic_temp(1:x+w_size,1:y+w_size) = img(1:x+w_size,1:y+w_size);
elseif x+w_size > X && y-w_size < 1
    pic_temp(x-w_size:X,1:y+w_size) = img(x-w_size:X,1:y+w_size);
elseif x+w_size > X && y+w_size > Y
    pic_temp(x-w_size:X,y-w_size:Y) = img(x-w_size:X,y-w_size:Y);
end