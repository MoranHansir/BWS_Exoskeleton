function [mass_center] = DefineMassCenter()
%UNTITLED8 此处显示有关此函数的摘要
%   此处显示详细说明

import org.opensim.modeling.*;

mc = load('mass_center2.txt');
Osw_stl = [210.9538,349.45999,0]/1000;
mc = mc/1000 + Osw_stl;

mass_center = cell(60,1);

for i = 1:58
    mass_center{i} = Vec3(mc(i,1),mc(i,2),mc(i,3));
end

% mass_center{7} = Vec3(208.87/1000,346/1000,0);


end

