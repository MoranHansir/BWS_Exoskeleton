function [NewBody] = CreatBody(name,mass,pos,interia,file)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

import org.opensim.modeling.*;


NewBody = Body(name,mass,pos,Inertia(Vec3(0)));
Geo = Mesh([file '.stl']);
% Geo.set_scale_factors(Vec3(1));
Geo.setColor(Vec3(0,1,1));
NewBody.attachGeometry(Geo);
% NewBody.set_inertia(Vec6(interia(1),interia(2),interia(3),interia(4),interia(5),interia(6)));


end

