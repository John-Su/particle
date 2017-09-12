function C = calib(u,v,X,Y,Z)

assert(all(size(u) == size(v)));
assert(all(size(X) == size(Y)));
assert(all(size(u) == size(X)));
if size(X,1) ~= 1
    X = X';
    Y = Y';
    u = u';
    v = v';
%     Z = Z';
end

 
 B = [X;Y;ones(size(X))];
 A1 = [u;v;ones(size(u))];
 
 C = B/A1;

 
 