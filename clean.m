%% ���ֶ����ֵ���ʱ����Ҫ�������ɸѡ
function [x,y] = clean(x,y,org)    
if all(size(x)==1)
    return;
end
temp = zeros(size(org));
for I = 1:length(x)
    temp(x(I),y(I)) = 1;
end
%% ������ͨ�Լ�ֵ����о����жϣ����ֻ��һ���ţ�ֱ�ӷ���
cc = bwconncomp(temp,4);
if length(cc.PixelIdxList) == 1
    return;
end
mxlen = 0;
%% ������ڶ����ֵ���ţ�ȡ�������ŷ���
for I = 1:length(cc.PixelIdxList)
    if length(cc.PixelIdxList{I}) > mxlen
        temp = cc.PixelIdxList{I};
        mxlen = length(temp);
    end
end

[x,y] = ind2sub(size(org),temp);