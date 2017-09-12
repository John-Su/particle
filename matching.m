function [m,points,t,A] = matching(points,points_1,r1,r2,d, pre_a)
t = [0,0]';
A = [1,0;0,1];
points_A = points;
points_B = points_1;
points_B(end+1,:) = [0,0];
points_N = [];
% m = zeros(length(points),length(points));
%% initializing
rA = [];
r2 = [r2;1];
beta = 0.01;
ratio = 1.4;
beta_max = 100;


tic;
points = [];
N = 1;
for I = 1:length(points_A)
    if ~isempty(pre_a)
        idx = intersect(find(pre_a(:,1) == points_A(I,2)),find(pre_a(:,2) == points_A(I,1)));
        if length(idx) == 1
           
            points_N(N,:) = (A*points_A(I,:)' + pre_a(idx,[4,3])')';
            rA(N) = r1(I);
            points(N,:) = points_A(I,:);
            N = N + 1;
        elseif ~isempty(idx)
            for J = 1:length(idx)
                points_N(N,:) =  (A*points_A(I,:)' + pre_a(idx(J),[4,3])')';
                points(N,:) = points_A(I,:);
                rA(N) = r1(I);
                N = N + 1;
            end
        else
            points_N(N,:) = points_A(I,:);
            points(N,:) = points_A(I,:);
            rA(N) = r1(I);
            N = N + 1;
        end
    else
        points_N(I,:) = points_A(I,:);
        points(I,:) = points_A(I,:);
        rA(I) = r1(I);
    end
end
points_N(end+1,:) = [0,0];
w_size = length(points_1);
x_size = length(points_N)-1;
m_pre = zeros(w_size+1,x_size+1);
m = zeros(w_size+1,x_size+1);
rA(end+1) = 0;
r1 = rA;
while(1)
for I = 1:w_size+1
    for J = 1:x_size+1
        if I <= w_size && J <= x_size
            m(I,J) = exp(-beta*norm(points_B(I,:)-points_N(J,:))*(1+abs(r1(J)-r2(I))));
        else        
            m(I,J) = exp(-beta*d);
        end
    end
end

for iter = 1:1
    temp = sum(m,1);
    for I = 1:w_size + 1
        for J = 1:x_size + 1
            m(I,J) = m(I,J)/temp(J);
        end
    end
    temp = sum(m,2);
    for I = 1:w_size + 1
        for J = 1:x_size + 1
            m(I,J) = m(I,J)/temp(I);
        end
    end
end
if mean(sum(abs(m_pre-m)))<0.08
    break;
end
if isnan(m(1,1))
    break;
end
m_pre = m;
% temp_t_up = [0,0]';
% temp_t_down = [0,0]';
% temp_a_up = 0;
% temp_a_down = 0;
% temp_b_up = 0;
% temp_b_down = 0;
% for I = 1:w_size
%     for J = 1:x_size
%         temp_t_up = temp_t_up + m(I,J)*(points_B(I,:)'-A * points_A(J,:)');
%         temp_t_down = temp_t_down + m(I,J);
%         temp_a_up = temp_a_up + m(I,J)*points_A(J,2)*(points_B(I,1)-t(1)-points_A(J,1));
%         temp_a_down = temp_a_down + m(I,J)*points_A(J,2)^2;
%         temp_b_up = temp_a_up + m(I,J)*points_A(J,1)*(points_B(I,1)-t(2)-points_A(J,2));
%         temp_b_down = temp_a_down + m(I,J)*points_A(J,1)^2;
%     end
% end
% t = temp_t_up./temp_t_down;
% a = temp_a_up/temp_a_down;
% b = temp_b_up/temp_b_down;
% A = [1,a;b,1];
beta = beta*ratio;
if beta > 0.5
    beta;
end

end
toc;        
% [x,y] = size(m);
% a = [];
% rd = 0;
% r=[];
% for I = 1:x-1
%     idx = find(m(I,:) == max(m(I,:)));
%     if idx <= length(points)
%         for J = 1:length(idx)
%             p_b = [points_1(I,2),points_1(I,1)];
%             p_a = [points(idx(J),2),points(idx(J),1)];
%             if rd == 0
%                 r = [r,mean([r2(I),r1(idx(J))])];
%             end
%             a = [a;[p_a,p_b,p_b-p_a]];
%         end
%     else
%         a = [a;[points_1(I,:),[0,0],[0,0]]];
%     end
% end
% a;




