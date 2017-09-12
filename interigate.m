function [x,y] = interigate(A,B,overlap)

assert(size(B,1)==size(B,2));
assert(size(A,1)==size(A,2));
assert(mod(size(B,1),size(A,1)) == 0);
assert(overlap>=0 && overlap<1);
step = ceil(size(A,1)*(1-overlap));
peaks = [];
fa = fft(A);
for I = 1:(size(B,1)-size(A,1))/step
    for J = 1:(size(B,2)-size(A,2))/step
        temp = B(step*(I-1)+1:step*(I-1)+size(A,1),step*(J-1)+1:step*(J-1)+size(A,2));
        ft = fft(temp);
        peaks(I,J) = max(max(fa*ft));
    end
end
[Y,X] = meshgrid(1:size(peaks,1),1:size(peaks,2));

x = (mean(mean(X.*abs(peaks)))/mean(mean(abs(peaks))) - 1) * step + size(A,1)/2;
y = (mean(mean(Y.*abs(peaks)))/mean(mean(abs(peaks))) - 1) * step + size(A,2)/2;



        