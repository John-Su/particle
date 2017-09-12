function [X,Y] = sortPoints(points,ratio1, ratio2)

temp_p1 = [];
temp1 = [];
temp2 = [];
iter = 20;
while ~all(size(temp_p1) == size(points)) || length(unique(diff(temp2))) ~= 2 || length(unique(diff(temp1))) ~= 2 || min(temp1) ~= max(temp1) || min(temp2) ~= max(temp2)
pointsTEN = points*10;
w = diff(sortrows(pointsTEN,1));
w = w(:,1);
w(w<max(w)/2,:) = [];
w = floor(max(w*ratio1));
% x_w = w;
% residual = w - mod(floor(points(:,1)-min(points(:,1))),w);
temp1 = floor(pointsTEN(:,1)-min(pointsTEN(:,1))) - mod(floor(pointsTEN(:,1)-min(pointsTEN(:,1))),w);
% t = [abs(floor(points(:,1))-temp1),abs(floor(points(:,1))-temp1_res)];
% temp1(t(:,1)>t(:,2),:) = temp1_res(t(:,1)>t(:,2),:);
w = diff(sortrows(pointsTEN,2));
w = w(:,2);
w(w<max(w)/2,:) = [];
% w = floor(max(w)*(1+0.99/(length(w)+1)));
w = floor(max(w*ratio2));
% y_w = w;
% residual =w - mod(floor(points(:,2)),w);
% temp2_res = floor(points(:,2)) + residual;
temp2 = floor(pointsTEN(:,2)) - mod(floor(pointsTEN(:,2)),w);
% t = [abs(floor(points(:,2))-temp2),abs(floor(points(:,2))-temp2_res)];
% temp2(t(:,1)>t(:,2),:) = temp2_res(t(:,1)>t(:,2),:);
temp_p = [temp1,temp2];
temp_p1 = unique(temp_p,'rows');
iter = iter - 1;
if iter < 1
    break;
end
temp1 = sort(temp_p,1);
temp2 = temp1(:,2);
temp1 = temp1(:,1);
inter1 = diff(temp1);
inter1 = find((inter1)~=0);
inter1 = diff(inter1);
inter2 = diff(temp2);
inter2 = find((inter2)~=0);
inter2 = diff(inter2);
if (length(find(inter1 == max(inter1))) < length(find(inter1 == min(inter1))))
    ratio1 = ratio1 - 0.01;
elseif (length(find(inter1 == max(inter1))) > length(find(inter1 == min(inter1))))
    ratio1 = ratio1 + 0.01;
elseif (length(find(inter1 == max(inter1))) == length(find(inter1 == min(inter1))) && max(inter1) ~= mean(inter1))
    ratio1 = ratio1 + 0.01;
elseif (length(unique(diff(temp1))) ~= 2)
    ratio1 = ratio1 + 0.01;
end
if (length(find(inter2 == max(inter2))) < length(find(inter2 == min(inter2))))
    ratio2 = ratio2 - 0.01;
elseif (length(find(inter2 == max(inter2))) > length(find(inter2 == min(inter2))))
    ratio2 = ratio2 + 0.01;
elseif (length(find(inter2 == max(inter2))) == length(find(inter2 == min(inter2))) && max(inter2) ~= mean(inter2))
    ratio2 = ratio2 + 0.01;
elseif (length(unique(diff(temp2))) ~= 2)
    ratio2 = ratio2 + 0.01;
end
% if (length(find(diff(temp1) ~=0)) > sqrt(size(points,1)) - 1)
%     ratio1 = ratio1 + 0.01;
% elseif (length(find(diff(temp1) ~=0)) < sqrt(size(points,1)) - 1)
%     ratio1 = ratio1 - 0.01;
% elseif(length(unique(diff(temp1)))>2)
%     ratio1 = ratio1 + 0.01;
% end
% 
% if (length(find(diff(temp2) ~=0)) > sqrt(size(points,1))-1)
%     ratio2 = ratio2 + 0.01;
% elseif (length(find(diff(temp2) ~=0)) < sqrt(size(points,1))-1)
%     ratio2 = ratio2 - 0.01;
% elseif (length(unique(diff(temp2)))>2)
%     ratio2 = ratio2 + 0.01;
% end

end
assert(all(size(temp_p1)==size(points)));
% temp_p = temp_p/10;
% points = points/10;
% x_w = x_w/10;
% y_w = y_w/10;
X = [];
Y = [];

X_min = min(temp_p(:,1));
Y_min = min(temp_p(:,2));
% interval_x = diff(sortrows(temp_p,1));
% interval_x = interval_x(:,1);
% while (any(interval_x<mean(interval_x)/2))
%     interval_x(interval_x<mean(interval_x)/2,:) = [];
% end
% interval_y = diff(sortrows(temp_p,2));
% interval_y = interval_y(:,2);
% while (any(interval_y<mean(interval_y)/2))
%     interval_y(interval_y<mean(interval_y)/2,:) = [];
% end
% x_w = mean(interval_x);
% y_w = mean(interval_y);
x_w = diff(sortrows(temp_p,1));
y_w = diff(sortrows(temp_p,2));
x_w = x_w(:,1);
x_w(x_w==0) = [];
x_w = max(x_w);
y_w = y_w(:,2);
y_w(y_w==0) = [];
y_w = max(y_w);
while (size(points,1) > 0)
    
	temp = points(temp_p(:,2) == min(temp_p(:,2)),:);
    regu_temp = temp_p(temp_p(:,2) == min(temp_p(:,2)),:);
    assert(all(size(temp)>1));
    for K = 1:size(temp,1)
        I = floor((regu_temp(K,1)-X_min)/x_w) + 1;
        J = floor((regu_temp(K,2)-Y_min)/y_w) + 1;
        X(J,I) = temp(K,1);
        Y(J,I) = temp(K,2);
        X_reg(J,I) = regu_temp(K,1);
        Y_reg(J,I) = regu_temp(K,2);
    end
    points(temp_p(:,2) == min(temp_p(:,2)),:) = [];
    temp_p(temp_p(:,2) == min(temp_p(:,2)),:) = [];
    
end
% X = X-center(1);
% Y = Y-center(2);

if (any(X(:)==0))
    temp_X = [];
    temp_Y = [];
%     temp_Xregu = [];
%     temp_Yregu = [];
    for I = 1:size(X,2)
        for J = 1:size(X,1)
            if X(J,I) ~= 0
                temp_X(end+1) = X(J,I);
                temp_Y(end+1) = Y(J,I);
%                 temp_Xregu(end+1) = X_reg(J,I);
%                 temp_Yregu(end+1) = Y_reg(J,I);                
            end
        end
    end
    temp = [temp_X;temp_Y]';
%     temp_regu = [temp_Xregu;temp_Yregu]';
    
    
    Y_interval = diff(sortrows(temp,2));
    Y_interval = Y_interval(:,2);
    Y_interval(abs(Y_interval) < max(abs(Y_interval))/2) = [];

    Y_step = length(Y_interval)+1;
    X_interval = diff(sortrows(temp,1));
    X_interval = X_interval(:,1);
    X_interval(abs(X_interval) < max(abs(X_interval))/2) = [];
    X_step = length(X_interval)+1;
    temp = sortrows(temp,1);
    X = reshape(temp(:,1),Y_step,X_step);
    Y = reshape(temp(:,2),Y_step,X_step);
    for I = 1:size(X,2)
        temp = [X(:,I),Y(:,I)];
        temp = sortrows(temp,-2);
        X(:,I) = temp(:,1);
        Y(:,I) = temp(:,2);
    end
else
%     X = X/10;
%     Y = Y/10;
    for I = 1:size(X,2)
        temp = [X(:,I),Y(:,I)];
        temp = sortrows(temp,-2);
        X(:,I) = temp(:,1);
        Y(:,I) = temp(:,2);
    end
end



