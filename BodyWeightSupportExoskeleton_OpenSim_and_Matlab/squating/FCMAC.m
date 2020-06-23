function [un] = FCMAC(A,E,J)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

%% 输入量化 E -> s ；
E([4 5 6])=0;
s = E;  %输入；
s(1) = (s(1) + 0.1)/( 0.1 *2/9);
s(2) = (s(2) + 0.1)/( 0.1 *2/9);
s(3) = (s(3) + 0.1)/( 0.1 *2/9);
s(4) = (s(4) + 0.1)/( 0.1 *2/9);
s(5) = (s(5) + 1)/( 1 *2/9);
s(6) = (s(6) + 1)/( 1 *2/9);

for i = 1:6     %输入量化限位；
    if s(i) < 0, s(i) = 0; elseif s(i) > 9, s(i) = 9; end
end

n_BL = 3;   %每层block的数目；
% n_BE = 4;   %每个block中元素的数目；
% n_E = 9;    %每层元素的数目；
n_L = 4;    %每个输入的层数；
n = 6;  %输入的个数；
p = 3;  %输出的个数；

% Weight = zeros(p,n_L,n_BL^n);  % 这个是所有的权重矩阵；
load data_Weight
% Miu = zeros(n_L,n);  % 这个是记录所有block高斯函数的参数；
load data_Miu
% Sigma = zeros(n_L,n); % 同上；
load data_Sigma
% yita = 0;
load data_yita

%找到当前输入对应的量化位置，即在每个输入的每个层的第几个；
in = zeros(n_L,n); %每一列表示该输入在每个层的位置；
for i=1:n
    for j=1:n_L
        in(j,i) = ceil((s(i) - j)/n_L) + 1;
        if in(j,i)==0
            in(j,i)=1;
        end
    end
end
% in
%选中的n_L个超立方体在Weight中的位置：
w_pos = ones(1,n_L);
for i=1:n_L
    for j=1:n
        w_pos(i) = w_pos(i) + (in(i,j)-1)*n_BL^(j-1);
    end
end

% w_pos

%提取权值w;
w = zeros(n_L,p);
for i=1:p
    for j=1:n_L
        w(j,i) = Weight(i,j,w_pos(j));
    end
end

%提取高斯函数参数m和sigma;
m = zeros(n_L,n);
sigma = zeros(n_L,n);
for i=1:n_L
    for j=1:n
        m(i,j) = Miu(i,in(i,j),j);
        sigma(i,j) = Sigma(i,in(i,j),j);
    end
end

%计算Gamma;
Gamma = zeros(n_L,1);
for i=1:n_L
    psi_n = 0;
    for j=1:n
        psi_n = psi_n - (s(j)-m(i,j))^2/sigma(i,j)^2;
    end
    Gamma(i) = exp(psi_n);
end

%计算G和H；
G = zeros(n*n_L,n_L);
H = zeros(n*n_L,n_L);
for i=1:n_L
    for j=1:n
        G((j-1)*n_L+i,i) = Gamma(i)*2*(s(j)-m(i,j))/sigma(i,j)^2;
        H((j-1)*n_L+i,i) = Gamma(i)*2*(s(j)-m(i,j))^2/sigma(i,j)^3;
    end
end

%计算控制量；
% w
% Gamma

uf = w'*Gamma;
uc = yita
un = uf*1 + uc;


% 权值等更新；
P =[...
    1.2550         0         0    0.0025         0         0
         0    1.3537         0         0    0.0014         0
         0         0    2.6500         0         0    0.0100
    0.0025         0         0    0.0050         0         0
         0    0.0014         0         0    0.0032         0
         0         0    0.0100         0         0    0.0510];
% V = [zeros(3,3);inv(A)*inv(J')]
% iA=inv(A)
% iJ=inv(J')
V = [zeros(3,3);eye(3)];
r1 = 1000;
r2 = 10;
r3 = 10;
r4 = 100000;
Weight_dot = Gamma*E'*P*V*diag([100000 100000*10 1000]);
Miu_dot = r2*G*w*V'*P*E;
Sigma_dot = r3*H*w*V'*P*E;
Yita_dot = diag([100000 1000000*2 1000])*V'*P*E;

T = 0.01;
for i=1:p
    for j=1:n_L
        Weight(i,j,w_pos(j)) = Weight(i,j,w_pos(j)) + Weight_dot(j,i)*T;
    end
end
for i=1:n_L
    for j=1:n
        Miu(i,in(i,j),j) = m(i,j) + Miu_dot((j-1)*n_L+i)*T;
        Sigma(i,in(i,j),j) = sigma(i,j) + Sigma_dot((j-1)*n_L+i)*T;
    end
end
yita = yita + Yita_dot*T;
%
% n_BL = 3;   %每层block的数目；
% n_L = 4;    %每个输入的层数；
% n = 6;  %输入的个数；
% p = 3;  %输出的个数；
% Weight = zeros(p,n_L,n_BL^n);
% Miu = zeros(n_L,n_BL,n);
% for i = 1:n     %miu赋初值；
%     Miu(1,1,i) = 0.5;
%     Miu(1,2,i) = 3;
%     Miu(1,3,i) = 7;
%     Miu(2,1,i) = 1;
%     Miu(2,2,i) = 4;
%     Miu(2,3,i) = 7.5;
%     Miu(3,1,i) = 1.5;
%     Miu(3,2,i) = 5;
%     Miu(3,3,i) = 8;
%     Miu(4,1,i) = 2;
%     Miu(4,2,i) = 6;
%     Miu(4,3,i) = 8.5;
% end
% Sigma = ones(n_L,n_BL,n);
% yita = zeros(n_BL,1);
%
save data_Weight Weight;
save data_Miu Miu;
save data_Sigma Sigma;
save data_Yita yita;





































































end

