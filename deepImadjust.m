function filted = deepImadjust(img,w_size)
if ~exist('w_size','var')
    w_size = 20;
end
bw = im2bw(uint16(img),graythresh(uint16(img)));
bw = medfilt2(bw,[w_size w_size]);
filted = bw.*img;
temp = filted(filted~=0);
temp = imadjust(uint16(temp));
filted(filted~=0) = temp;
