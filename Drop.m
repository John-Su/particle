function [pic_temp,X,Y,pa_size] = Drop(org,img,x,y,thresh,theta)
assert(size(theta,1) == 360 && size(theta,2) == 3);
r = 15;
temp = [];
tempReal = [];
% x1 = x;
% y1 = y;
x = floor(mean(x));
y = floor(mean(y));
% peak = img(x,y);
% for I = max(1,x-3):min(1024,x+3)
%     for J = max(1,y-3):min(1024,y+3)
%         if org(I,J) > peak
%             x1 = I;
%             y1 = J;
%             peak = img(x,y);
%         end
%     end
% end
% x=x1;
% y=y1;
tic;
if floor(x-r) < 1
    if floor(y-r) < 1
        temp_particle = org(1 : 1+r, 1 : 1+r);
    elseif floor(y + r) > size(org,2)
        temp_particle = org(1 : 1+r, floor(y-r) : size(org,2));
    else
        temp_particle = org(1: 1+r, floor(y-r) : floor(y + r));
    end
elseif floor(x + r) > size(org,1)
     if floor(y-r) < 1
        temp_particle = org(floor(x-r) : size(org,1), 1 : 1+r);
    elseif floor(y + r) > size(org,2)
        temp_particle = org(floor(x-r) : size(org,1), floor(y-r) : size(org,2));
    else
        temp_particle = org(floor(x-r) : size(org,1), floor(y-r) : floor(y + r));
     end
else
    if floor(y-r) < 1
        temp_particle = org(floor(x-r) : floor(x + r), 1 : 1+r);
    elseif floor(y + r) > size(org,2)
        temp_particle = org(floor(x-r) : floor(x + r), floor(y-r) : size(org,2));
    else
        temp_particle = org( floor(x-r) : floor(x + r), floor(y-r) : floor(y + r));
    end
end
try
    thresh = graythresh(temp_particle/max(temp_particle(:)))*max(temp_particle(:));
catch
    thresh;
end

r = 1;
outRule = [];
% 确定粒子大小

edges = [];
temp = [x,y];
while any(theta(:,3)~=0)
    for I = 1:360
        if theta(I,3) == 1 
            X = floor(x-sin(theta(I,1)) * r + 0.5);
            Y = floor(y+cos(theta(I,1)) * r + 0.5);
            if ~isempty(outRule) && ~isempty(intersect(find(outRule(:,1)==X), find(outRule(:,2)==Y)))
                theta(I,3) = 0;
                continue;
            end
            if (X > size(org,1) || Y > size(org,2) || X < 1 || Y < 1)
                temp = [temp;[max(min(X,size(org,1)),1),max(min(Y,size(org,2)), 1)]];
                edges(I,:) = [max(min(X,size(org,1)),1),max(min(Y,size(org,2)), 1)];
                theta(I,3) = 0;
            elseif org(X,Y) >= thresh 
                theta(I,2) = r;
                temp = [temp;[X,Y]];
                edges(I,:) = [X,Y];
            else
                outRule = [outRule,[X,Y]];
                theta(I,3) = 0;
            end
        else
            X = floor(x-sin(theta(I,1)) * r + 0.5);
            Y = floor(y+cos(theta(I,1)) * r + 0.5);
            overLap = intersect(find(temp(:,1)==X),find(temp(:,2)==Y));
            if ~isempty(overLap)
                temp(overLap,:) = [];
            end 
            outRule = [outRule, [X,Y]];
        end
    end
    
    
    temp = unique(temp,'rows');
    try
      dt = DelaunayTri(temp);
      pt = convexHull(dt);
    catch
         temp = [];
         break;
    end
    temp_edges = unique(edges,'rows');
    if abs(length(pt)-length(temp_edges)) > 0.3 * length(temp_edges)
        break;
    end
    r = r+1;
    if r > 50
        pic_temp = zeros(size(org));
        ind_temp = sub2ind(size(org),temp(:,1),temp(:,2));
        pic_temp(ind_temp) = org(ind_temp);
        X = 0;
        Y = 0;
        pa_size = 0;
        return;
    end
end


% toc;  

pic_temp = zeros(size(org));
if any(size(temp)==0)
%     thresh = thresh /2;
    theta(:,3) = 1;
    theta(:,2) = 0;
    temp = [];
    r = 0;
    iter = 50;
    while any(theta(:,3)~=0)
        for I = 1:360
            if theta(I,3) == 1 
                X = floor(x-sin(theta(I,1)) * r + 0.5);
                Y = floor(y+cos(theta(I,1)) * r + 0.5);
                if (X > size(org,1) || Y > size(org,1) || X < 1 || Y < 1)
                    temp = [temp;[max(min(X,size(org,1)),1),max(min(Y,size(org,2)), 1)]];
                    theta(I,3) = 0;
                elseif org(X,Y) <= max(thresh,org(x,y))
                    theta(I,2) = r;
                    temp = [temp;[X,Y]];
                else
                    theta(I,3) = 0;
                end
            end
        end
        if length(find(theta(:,3)==0)) > size(theta,1)/2
            break;
        end
        iter = iter -1;
        if iter < 1
            break;
        end
        r = r+1;
    end
    temp = unique(temp,'rows');
    if any(size(temp) == 0)
        pic_temp(x,y) = org(x,y);
        X = 0; Y = 0; pa_size = 0;
        return;
    end
    ind_temp = sub2ind(size(org),temp(:,1),temp(:,2));
    pic_temp(ind_temp) = org(ind_temp);
    X = 0; Y = 0; pa_size = 0;
    return;
end

ind_temp = sub2ind(size(org),temp(:,1),temp(:,2));
pic_temp(ind_temp) = org(ind_temp);
X = mean(temp(:,1).*org(ind_temp))/mean(org(ind_temp));
Y = mean(temp(:,2).*org(ind_temp))/mean(org(ind_temp));
% plot(y,x,'r.');
% plot(Y,X,'ro');
pa_size = sqrt(length(temp(:,1)));

    