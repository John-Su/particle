function [pic_temp,X,Y,par_size,thresh] = Flmax(org,x,y,thresh,template)
w_size = 1;

x = floor(mean(x));
y = floor(mean(y));
x_=x;y_=y;

X = 0;
Y = 0;
iter = 100;
boder = 0;
while 1
if org(x,y) >= thresh
            temp = neighbor(org,x,y,w_size);    %按窗口大小画出粒子
            img = temp;
            if boder == 0 || boder > max([temp(:,end)',temp(:,1)',temp(1,:),temp(end,:)])   %找出粒子边界
                boder = max([temp(:,end)',temp(:,1)',temp(1,:),temp(end,:)]);
            elseif boder < max([temp(:,end)',temp(:,1)',temp(1,:),temp(end,:)])             %如果前一圈的边界最大值比这一圈的小，则说明探测到了其他粒子，停止探测
                w_size = w_size -1 ;
                img = neighbor(org,x,y,w_size);
                temp = im2bw(img/max(max(img)),0.3);
                [temp,d] = deZero(temp);
                
                break;
            end
          
            if isempty(temp)
                pic_temp = zeros(size(org));
                pic_temp(x_-w_size+1:x_+w_size-1,y_-w_size+1:y_+w_size-1) = org(x_-w_size+1:x_+w_size-1,y_-w_size+1:y_+w_size-1) ;  
                return;
            end
            temp = im2bw(temp/max(max(temp)),0.3);  % 0.3的level判断粒子边界
            [temp,d] = deZero(temp);
            [t_x,t_y] = size(temp);
            
            if (length(find(d>0)) < 4 && length(find(temp<1))/(t_x*t_y) < 0.4) || (d(1)+d(2) == 0 || d(3)+d(4) == 0)
                w_size = w_size +1;
                if w_size > 50
                    
                    break;
                end
            else
                break;
            end
            iter = iter-1;
            if iter < 1
                break;
            end
else 
%     pic_temp = zeros(size(org));
    w_size = 3;
    pic_temp = getPicTemp(org,x,y,w_size);
    par_size = 1;
    return;
end
end
pic_temp = getPicTemp(org,x_,y_,w_size);
    
img_conv = xcorr2(img,template);
[x,y] = ind2sub(size(img_conv),find(img_conv == max(max(img_conv))));
shift = size(template);
shift = (shift(1)-1)/2;

x = mean(x)-shift;
y = mean(y)-shift;
x = floor(x+0.5);
y = floor(y+0.5);
try 
    window = img(floor(x-floor(w_size)/2):floor(x+floor(w_size)/2),floor(y-(w_size)/2):floor(y+(w_size)/2));
catch
    w_size = min([abs(x-size(img,1)),abs(x-1),abs(y-size(img,2)),abs(y-1)]);
    window = img(floor(x-floor(w_size)/2):floor(x+floor(w_size)/2),floor(y-(w_size)/2):floor(y+(w_size)/2));
end
w_size = size(window);
[xx,yy] = meshgrid(1:w_size(1),1:w_size(2));
if mod(w_size,2) == 0
    y_shift = sum(sum(xx.*window))/sum(window(:))-w_size/2;
    x_shift = sum(sum(yy.*window))/sum(window(:))-w_size/2;
else
    y_shift = sum(sum(xx.*window))/sum(window(:))-(w_size+1)/2;
    x_shift = sum(sum(yy.*window))/sum(window(:))-(w_size+1)/2;
end
X = x_ + x -w_size+x_shift;
Y = y_ + y -w_size+y_shift;
X = mean([X,x_]);
Y = mean([Y,y_]);
par_size = sqrt(length(find(temp(:) == 1)));
if max(img(:)) - min(img(:)) < thresh  ||  org(x_,y_) < thresh
%     plot(Y,X,'ro');
    X = 0; 
    Y = 0;
    par_size = 0;
end

if length(X) > 1
    X;
end



