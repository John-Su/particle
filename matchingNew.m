function [m,t] = matchingNew(points_A,points_B)

A_size = length(points_A);
B_size = length(points_B);

m = zeros(A_size+1,B_size+1);
b = 10;
A = [1,0;0,1];
t = [0,0]';
for I = 1:A_size+1
    for J = 1:B_size+1
        if I < A_size + 1 && J < B_size + 1
            m(I,J) = exp(-norm(points_A(I,:)-points_B(J,:)));
        else
            m(I,J) = exp(-b);
        end
    end
end
A = [];
B = [];
for I = 1:A_size
    A = [A;I];
    B = [B;find(m(I,:) == max(m(I,:)))];
end
A(B == B_size+1) = [];
B(B == B_size+1) = [];
t = [A,B];