function temp = neighbor(img,x,y,w_size)

[X,Y] = size(img);
if x-w_size > 0 && x+w_size <= X && y-w_size > 0 && y+w_size <= Y
    temp = img(x-w_size:x+w_size,y-w_size:y+w_size);
elseif x-w_size < 1 &&  y-w_size > 0 && y+w_size <= Y    %�����������Ե
    temp = img(1:1+2*w_size,y-w_size:y+w_size);
elseif x+w_size > X &&  y-w_size > 0 && y+w_size <= Y    %���������ұ�Ե
    temp = img(X-2*w_size:X,y-w_size:y+w_size);
elseif x-w_size > 0 && x+w_size <= X && y-w_size < 1     %���������±�Ե
    temp = img(x-w_size:x+w_size,1:1+2*w_size);
elseif x-w_size > 0 && x+w_size <= X && y+w_size >Y      %���������ϱ�Ե
    temp = img(x-w_size:x+w_size,Y-2*w_size:Y);
elseif x-w_size < 1 && y+w_size > Y                      %�����������Ͻ�
    temp = img(1:1+2*w_size,Y-2*w_size:Y);
elseif x-w_size < 1 && y-w_size < 1                      %�����������½�
    temp = img(1:1+2*w_size,1:1+2*w_size);
elseif x+w_size > X && y-w_size < 1                      %�����������½�
    temp = img(X-2*w_size:X,1:1+2*w_size);
elseif x+w_size > X && y+w_size > Y                      %�����������Ͻ�
    temp = img(X-2*w_size:X,Y-w_size:Y);
end