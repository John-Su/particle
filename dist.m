pre = start_a;
start_a = start_a(find(start_a(:,4)~=0),:);
indx = find(start_a(:,4)~=0);
dx = [];
dy = [];
flag = 1;
for J = 1:2:size(start_a,2)
    for I=1:size(start_a,1)
        if all(start_a(I,[J,J+1]) ~=0 )
            temp = start_a(:,J) - start_a(I,J);
            dx(I,(J+1)/2) = sum(temp)/(length(temp)-1);
            temp = start_a(:,J+1) - start_a(I,J+1);
            dy(I,(J+1)/2) = sum(temp)/(length(temp)-1);
        else
            flag = 0;
        end
    end
    if ~flag
        break;
    end
end
start_a = pre;
            