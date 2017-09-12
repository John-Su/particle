function [img1, img2] = genBorad()

img1 = zeros(1024,1024);
img2 = img1;
template = fspecial('gaussian',[21,21],5);
template2 = fspecial('gaussian',[31,31],7.5);
center = [0,0];
for I = 30:50:1010
    center(1) = center(1) + 1;
    for J = 30:60:1010
        img1(I-10:I+10,J-10:J+10) = template *1000;
        img2(I-9:I+11,J-9:J+11) = template *1000;
        center(2) = center(2) + 1;
        if center(1) == 10 && center(2) == 10
            X = I;
            Y = J;
        end
    end
    center(2) = 0;
end
img1(X-15:X+15,Y-15:Y+15) = template2*2000;
img2(X-14:X+16,Y-14:Y+16) = template2*2000;