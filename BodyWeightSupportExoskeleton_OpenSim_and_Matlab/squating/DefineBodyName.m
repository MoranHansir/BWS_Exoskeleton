function [name] = DefineBodyName()
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

name = cell(60,1);

for i = 1:60
    b_name = ['Body' num2str(i)];
    eval( [ 'name{' num2str(i) '} = b_name;' ] );
end

end

