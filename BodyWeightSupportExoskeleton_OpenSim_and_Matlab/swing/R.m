function [Rxyz] = R(theta_x,theta_y,theta_z)
%UNTITLED4 此处显示有关此函数的摘要
%   hip joint rotation : z x y
Rz = [cos(theta_z) -sin(theta_z) 0
      sin(theta_z)  cos(theta_z) 0
      0             0            1];
Ry = [cos(theta_y) 0 -sin(theta_y)
      0            1  0
      sin(theta_y) 0  cos(theta_y)];
Rx = [1 0             0
      0 cos(theta_x) -sin(theta_x)
      0 sin(theta_x)  cos(theta_x)];
% Rxyz = Rz*Ry*Rx;
Rxyz = Rx*Ry*Rz; % ；
end

