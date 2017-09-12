function points = refine(img,points,r)

assert(any(size(points)==2));
if size(points,2) ~= 2
    points = points';
end
p = zeros(size(points));
for I = 1:length(r)
    R = ceil(r(I));
    temp = fspecial('disk',R);
    [m,n] = size(temp);
    X = points(I,2);
    Y = points(I,1);
    X = floor(X);
    Y = floor(Y);
    aim = double(img(X-R:X+R,Y-R:Y+R));
    temp = max(temp(:))-temp;
    temp = (temp -min(temp(:))) * (max(aim(:))-min(aim(:))) / (max(temp(:))-min(temp(:))) + min(aim(:));
    c = conv2(aim,temp,'same');
    
    [x,y] = ind2sub(size(c),find(c==max(c(:))));
    peak = c(x-1:x+1,y-1:y+1);
    [y0,x0] = meshgrid(x-1:x+1,y-1:y+1);
    x = mean(mean(peak.*x0))/mean(peak(:))-x;
    y = mean(mean(peak.*y0))/mean(peak(:))-y;
    p(I,1) = X+x;
    p(I,2) = Y+y;
end
points = p;

    
    
