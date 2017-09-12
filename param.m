function P = param(u,v,X)

if (size(u,1) ~= 1)
    u = u';
    v = v';
    X = X';
end
a1 = u.^3;
a2 = v.^3;
a3 = u.^2.*v;
a4 = u.*v.^2;
a5 = ones(size(u));
A = [a1;a2;a3;a4;a5];

