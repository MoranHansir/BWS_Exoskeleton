function [geo_path] = SelectGeoPathName()
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明

geo_path = cell(60,1);


for i = 1:60
    path = ['ExoGeometry1/body (' num2str(i) ')'];
    eval( [ 'geo_path{' num2str(i) '}= path;' ] );
% geo_path{1} = 'ExoGeometry/1';
end

end

