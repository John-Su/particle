function dst = su_imadjust(org,parts)

[x_size,y_size] = size(org);    
while parts >= 1
x = 1:floor(x_size/parts):x_size;
y = 1:floor(y_size/parts):y_size;
if x(end) ~= x_size
    x(end+1) = x_size;
end
if y(end)~=y_size
    y(end+1) = y_size;
end
assert(length(x)==length(y), 'partition wrong');
if mod(length(x),2) == 1
    parts = parts-1;
    continue;
end
dst = org;
for I = length(x)-2:-1:1
    for J = length(y)-2:-1:1
        temp = org(x(I):x(I+2),y(J):y(J+2));
        temp = imadjust(temp);
        if any(isnan(temp))
            temp;
        end
        dst(x(I):x(I+2),y(J):y(J+2)) = temp;
    end
end
org = dst;
parts = parts-1;
end
dst = medfilt2(dst);



