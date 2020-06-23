% º∆À„Jp_dot£ª
clc;clear
syms q1(t) q2(t) q3(t) q4(t) q5(t) q6(t)
syms L1 L2 L3 L4 L5 L6
syms pcx pcy



Jp =[   pcy*sin(q1 + q2 + q3) - pcx*cos(q1 + q2 + q3) - L2*cos(q1 + q2) - L1*cos(q1),   pcy*sin(q1 + q2 + q3) - pcx*cos(q1 + q2 + q3) - L2*cos(q1 + q2),   pcy*sin(q1 + q2 + q3) - pcx*cos(q1 + q2 + q3), 0, 0, 0
 - L1*sin(q1) - pcy*cos(q1 + q2 + q3) - L2*sin(q1 + q2) - pcx*sin(q1 + q2 + q3), - pcy*cos(q1 + q2 + q3) - L2*sin(q1 + q2) - pcx*sin(q1 + q2 + q3), - pcy*cos(q1 + q2 + q3) - pcx*sin(q1 + q2 + q3), 0, 0, 0
                                                                                                         1,                                                                                         1,                                                                 1, 0, 0, 0];

diff(Jp);