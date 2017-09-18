function concave = concave(points)
    if length(points) < 3
        concave = 1;
        return;
    end
    
    for I = 1:size(points,1)
        temp = points;
        temp(I,:) = [];
        [in,on] = inpolygon(points(I,1),points(I,2),temp(:,1),temp(:,2));
        if in + on == 1
            concave = 0;
            return;
        end
    end
    concave = 1;