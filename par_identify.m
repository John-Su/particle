function [pos,r,img,num] = par_identify(img, theta, meanPic)

    
debug = 0;
pos = [];
r = [];
org = img;
% img = img1;
% img = deepImadjust(img);
% img = deepImadjust(img,5);
% img = deepImadjust(img,3);

% img = img./max(img(:));

threshold_org = max(max(img))*0.3;
% img(img<threshold_org) = img(img<threshold_org) /2;
% threshold_org = mean(mean(img))*2;
% I = length(par)-8;
 template = fspecial('gaussian',[10,10],5/3.5)*threshold_org*25;
% template = ones(10,10);

% threshold= threshold_org; %max(max(img))*0.27;
threshold = graythresh(img/max(img(:)))*max(img(:));
img(img<min(img(:))*1.1) = min(threshold,mean(img(:)));
org = img;
threshold = graythresh(img/max(img(:)))*max(img(:));
ercount = 0;

[a,b] = hist(img(:)-meanPic(:),(0:min(threshold*2,max(org(:))*0.9)));
% tic;
iter = 50;
while a(end)>35
        img_conv = conv2(img,template,'same');
%         img_conv = xcorr2(img,template);
        [x,y] = ind2sub(size(img_conv),find(img_conv == max(max(img_conv))));
%         x = x-shift;y = y-shift;
%         plot(y,x,'ro')
        [x,y] = clean(x,y,img);
%         [pic_temp,X,Y,w_size] = Flmax(img,x,y,threshold,template);
        [pic_temp,X,Y,w_size] = Dropbackup(org,img,x,y,threshold,theta);
        if debug
            plot(y,x,'ro');
            plot(Y,X,'go');
        end
        if length(pic_temp) == 1
            break
        elseif X==0 && Y == 0
            img = img - pic_temp;
            iter = iter -1;
            if iter < 1
                break;
            end
            continue;
        end
        iter = 10;
        if(length(X)) > 5 || (X == 0 && Y == 0)
            img = img-pic_temp;
            continue;
            
        end
        if mod((size(pos,1)) ,100) == 1
            disp(size(pos,1));
        end
        
        img = img-pic_temp;
        if w_size>=1 && org(floor(X),floor(Y)) - meanPic(floor(X),floor(Y)) > threshold
            iter = 50;
            pos = [pos;[X,Y]];
            r = [r;w_size];
        else
            iter = iter -1;
        end
        if iter < 1
            break;
        end
    
     [a,b] = hist(img(:)-meanPic(:),(0:min(threshold*2,max(org(:))*0.9)));
    
%     disp(length(pos));
    if length(pos) < 200 && max(max(img)) <= threshold
            break;
    elseif length(pos) >= 200 && max(max(img)) <= threshold
        break;
    end
    if ercount > 100
        break;
    end
%     disp(size(pos));
%     imshow(uint16(img*20));
end
%         disp('identifying particles takes up:');
    num = size(pos,1);
% toc;
            