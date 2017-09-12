clear;
pic_o = zeros(1024,1024);
pic_o_1 = pic_o;
par = {};
for I = 1:10
    par{I} = fspecial('gaussian',[I+2,I+2],I/3.5)*I;
end
num = 0;
points = [];
points_1 = [];
for I = 50:100:1024
    for J = 50:100:1024
        dia = floor((rand(1)+0.1)*10);
        dia = 10;
        [X,Y] = meshgrid(I-ceil(dia/2):I+ceil(dia/2),J-ceil(dia/2):J+ceil(dia/2));
        posx = X+rand(1)*30-15;
        posy = Y+rand(1)*30-15;
        posx_1 = posx+10;
        posy_1 = posy+5;
        idx = size(posx);
        idx = idx(1);
        if mod(idx,2) == 1
            points = [points;[posx(ceil(idx/2),ceil(idx/2)),posy(ceil(idx/2),ceil(idx/2))]];
            points_1 = [points_1;points(end,:) + [8,5.5]];
        else
            points = [points;[posx(idx/2,idx/2)/2+X(idx/2+1,idx/2+1),posxy(idx/2,idx/2)/2+Y(idx/2+1,idx/2+1)]];
            points_1 = [points_1;points(end,:) + [8,5.5]];
        end
        if idx > 5
            idx = idx;
        end
        x = floor(posx);
        y = floor(posy);
        pic_o(min(min(x)):max(max(x)),min(min(y)):max(max(y))) = griddata(posx,posy,rand(1)*par{idx-2},x,y,'cubic');
        x = floor(posx_1);
        y = floor(posy_1);
        pic_o_1(min(min(x)):max(max(x)),min(min(y)):max(max(y))) = griddata(posx_1,posy_1,rand(1)*par{idx-2},x,y,'cubic');
        
        num = num + 1;
    end
end



