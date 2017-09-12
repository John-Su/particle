for I = 1 : size(a,1)
    b = a(I,:);
    b(b==0) = [];
    if length(b) >  90
%         figure(1);
        plot(1:length(b),b,'-x');
%         figure(2);
%         b = start_a(I,:);
%         b = reshape(b,2,size(start_a,2)/2);plot(b(2,:),b(1,:),'r.');
        disp(I);
    end
end