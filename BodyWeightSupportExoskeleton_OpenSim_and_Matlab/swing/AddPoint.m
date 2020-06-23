function [] = AddPoint(t, model, excites)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
% 0   hip_flexion_r	
% 1   knee_angle_r	
% 2   ankle_angle_r	
% 3   hip_flexion_l	
% 4   knee_angle_l	
% 5   ankle_angle_l	
% 6   lumbar_extension

import org.opensim.modeling.*;

ExoCtr = PrescribedController.safeDownCast(...
            model.updComponent('ExoCtr'));
FuncSet = ExoCtr.upd_ControlFunctions();
% Ctr_func_thar = PiecewiseConstantFunction.safeDownCast(FuncSet.get(0));
% Ctr_func_thrr = PiecewiseConstantFunction.safeDownCast(FuncSet.get(1));
Ctr_func_thfr = PiecewiseConstantFunction.safeDownCast(FuncSet.get(2));
Ctr_func_tkfr = PiecewiseConstantFunction.safeDownCast(FuncSet.get(3));
Ctr_func_tafr = PiecewiseConstantFunction.safeDownCast(FuncSet.get(4));
% Ctr_func_thal = PiecewiseConstantFunction.safeDownCast(FuncSet.get(5));
% Ctr_func_thrl = PiecewiseConstantFunction.safeDownCast(FuncSet.get(6));
Ctr_func_thfl = PiecewiseConstantFunction.safeDownCast(FuncSet.get(7));
Ctr_func_tkfl = PiecewiseConstantFunction.safeDownCast(FuncSet.get(8));
Ctr_func_tafl = PiecewiseConstantFunction.safeDownCast(FuncSet.get(9));

f1 = Ctr_func_tafr;
f2 = Ctr_func_tkfr;
f3 = Ctr_func_thfr;
f4 = Ctr_func_thfl;
f5 = Ctr_func_tkfl;
f6 = Ctr_func_tafl;

f1.addPoint(t,excites(1));
f2.addPoint(t,excites(2));
f3.addPoint(t,excites(3));
f4.addPoint(t,excites(4));
f5.addPoint(t,excites(5));
f6.addPoint(t,excites(6));


end

