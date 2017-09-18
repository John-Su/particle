function [preEds] = outCircle(points)

    preEds = [];
    for I = 1:size(points,1)
        preEds = [preEds;[points(I,1),min(points(I,2)+1,1024)]];
        preEds = [preEds;[points(I,1),max(points(I,2)-1,1)]];
        preEds = [preEds;[min(points(I,1)+1,1024),points(I,2)]];
        preEds = [preEds;[min(points(I,1)+1,1024),min(points(I,2)+1,1024)]];
        preEds = [preEds;[min(points(I,1)+1,1024),max(points(I,2)-1,1)]];
        preEds = [preEds;[max(points(I,1)-1,1),points(I,2)]];
        preEds = [preEds;[max(points(I,1)-1,1),max(points(I,2)-1,1)]];
        preEds = [preEds;[max(points(I,1)-1,1),min(points(I,2)+1,1024)]];
    end
    
    preEds = unique(preEds,'rows');
    
   