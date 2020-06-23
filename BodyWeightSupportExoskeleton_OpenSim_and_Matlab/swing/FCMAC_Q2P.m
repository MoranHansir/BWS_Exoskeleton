
clc;clear;

%%
%求解 M'*P + P*M = -Q 中的P；
K1 = diag([700-300 700 150-50])/2;
K2 = diag([155-55 155 10]);
M = [zeros(3,3) eye(3,3);-K1 -K2];
Q = 1*eye(6,6);
syms    p11 p12 p13 p14 p15 p16...
        p12 p22 p23 p24 p25 p26...
        p13 p23 p33 p34 p35 p36...
        p14 p24 p34 p44 p45 p46...
        p15 p25 p35 p45 p55 p56...
        p16 p26 p36 p46 p56 p66
P =    [p11 p12 p13 p14 p15 p16
        p12 p22 p23 p24 p25 p26
        p13 p23 p33 p34 p35 p36
        p14 p24 p34 p44 p45 p46
        p15 p25 p35 p45 p55 p56
        p16 p26 p36 p46 p56 p66];
PP=[p11 p12 p13 p14 p15 p16 p22 p23 p24 p25 p26 p33 p34 p35 p36 p44 p45 p46 p55 p56 p66];
[p11, p12, p13, p14, p15, p16, p22, p23, p24, p25, p26, p33, p34, p35, p36, p44, p45, p46, p55, p56, p66]=solve(M'*P + P*M == -Q,PP);
P1 = subs(P);%以分数表示的sys变量；
P2 = eval(P1);%以小数表示的double变量；
%%
