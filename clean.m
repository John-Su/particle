%% 出现多个极值点的时候，需要对其进行筛选
function [x,y] = clean(x,y,org)    
if all(size(x)==1)
    return;
end
temp = zeros(size(org));
for I = 1:length(x)
    temp(x(I),y(I)) = 1;
end
%% 用四连通对极值点进行聚团判断，如果只有一个团，直接返回
cc = bwconncomp(temp,4);
if length(cc.PixelIdxList) == 1
    return;
end
mxlen = 0;
%% 如果存在多个极值点团，取点最多的团返回
for I = 1:length(cc.PixelIdxList)
    if length(cc.PixelIdxList{I}) > mxlen
        temp = cc.PixelIdxList{I};
        mxlen = length(temp);
    end
end

[x,y] = ind2sub(size(org),temp);