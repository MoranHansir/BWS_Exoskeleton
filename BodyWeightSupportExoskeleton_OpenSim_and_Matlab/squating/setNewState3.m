function [] = setNewState3(t,model,state)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

import org.opensim.modeling.*;

% pelvis_tilt
% pelvis_list
% pelvis_rotation
% pelvis_tx
% pelvis_ty
% pelvis_tz
% hip_flexion_r
% hip_adduction_r
% hip_rotation_r
% knee_angle_r
% ankle_angle_r
% subtalar_angle_r
% % mtp_angle_r
% hip_flexion_l
% hip_adduction_l
% hip_rotation_l
% knee_angle_l
% ankle_angle_l
% subtalar_angle_l
% % mtp_angle_l
% lumbar_extension
% lumbar_bending
% lumbar_rotation

if t<2
    traj=0;
else
    traj=30/180*pi/2*(sin(pi/2*(t-2)-pi/2)+1);
end

pelvis_tilt = Coordinate.safeDownCast(model.updComponent('ground_pelvis/pelvis_tilt'));
% pelvis_list = Coordinate.safeDownCast(model.updComponent('ground_pelvis/pelvis_list'));
% pelvis_rotation = Coordinate.safeDownCast(model.updComponent('ground_pelvis/pelvis_rotation'));
pelvis_tx = Coordinate.safeDownCast(model.updComponent('ground_pelvis/pelvis_tx'));
pelvis_ty = Coordinate.safeDownCast(model.updComponent('ground_pelvis/pelvis_ty'));
% pelvis_tz = Coordinate.safeDownCast(model.updComponent('ground_pelvis/pelvis_tz'));
hip_flexion_r = Coordinate.safeDownCast(model.updComponent('hip_r/hip_flexion_r'));
% hip_adduction_r = Coordinate.safeDownCast(model.updComponent('hip_r/hip_adduction_r'));
% hip_rotation_r = Coordinate.safeDownCast(model.updComponent('hip_r/hip_rotation_r'));
knee_angle_r = Coordinate.safeDownCast(model.updComponent('knee_r/knee_angle_r'));
ankle_angle_r = Coordinate.safeDownCast(model.updComponent('ankle_r/ankle_angle_r'));
% subtalar_angle_r = Coordinate.safeDownCast(model.updComponent('subtalar_r/subtalar_angle_r'));
% mtp_angle_r = Coordinate.safeDownCast(model.updComponent('mtp_r/mtp_angle_r'));
hip_flexion_l = Coordinate.safeDownCast(model.updComponent('hip_l/hip_flexion_l'));
% hip_adduction_l = Coordinate.safeDownCast(model.updComponent('hip_l/hip_adduction_l'));
% hip_rotation_l = Coordinate.safeDownCast(model.updComponent('hip_l/hip_rotation_l'));
knee_angle_l = Coordinate.safeDownCast(model.updComponent('knee_l/knee_angle_l'));
ankle_angle_l = Coordinate.safeDownCast(model.updComponent('ankle_l/ankle_angle_l'));
% subtalar_angle_l = Coordinate.safeDownCast(model.updComponent('subtalar_l/subtalar_angle_l'));
% mtp_angle_l = Coordinate.safeDownCast(model.updComponent('mtp_l/mtp_angle_l'));
% lumbar_extension = Coordinate.safeDownCast(model.updComponent('back/lumbar_extension'));
% lumbar_bending = Coordinate.safeDownCast(model.updComponent('back/lumbar_bending'));
% lumbar_rotation = Coordinate.safeDownCast(model.updComponent('back/lumbar_rotation'));

pelvis_tilt.setLocked(state,false);
% pelvis_list.setLocked(state,false);
% pelvis_rotation.setLocked(state,false);
pelvis_tx.setLocked(state,false);
pelvis_ty.setLocked(state,false);
% pelvis_tz.setLocked(state,false);
hip_flexion_r.setLocked(state,false);
% hip_adduction_r.setLocked(state,false);
% hip_rotation_r.setLocked(state,false);
knee_angle_r.setLocked(state,false);
ankle_angle_r.setLocked(state,false);
% subtalar_angle_r.setLocked(state,false);
% mtp_angle_r.setLocked(state,false);
hip_flexion_l.setLocked(state,false);
% hip_adduction_l.setLocked(state,false);
% hip_rotation_l.setLocked(state,false);
knee_angle_l.setLocked(state,false);
ankle_angle_l.setLocked(state,false);
% subtalar_angle_l.setLocked(state,false);
% mtp_angle_l.setLocked(state,false);
% lumbar_extension.setLocked(state,false);
% lumbar_bending.setLocked(state,false);
% lumbar_rotation.setLocked(state,false);

% CM(:,9:10)=0;
% CM(:,16:17)=0;
% CM(:,3:4) = 0;
% CM(:,7)=0;

% pa = GetDesiredData(t,2,CM);
% pelvis_tilt.setValue(state,pa);
% pelvis_tilt.setValue(state,GetDesiredData(t,2,CM));
% pelvis_list.setValue(state,GetDesiredData(t,3,CM));
% pelvis_rotation.setValue(state,GetDesiredData(t,4,CM));
% pelvis_tx.setValue(state,GetDesiredData(t,5,CM) + v*t);
% [x_worldo,x0_worldo,x0_bodyo,flag,y_body] = xDistanceCalculate(t,x0_body,x0_world,last_flag,model,state);
% pelvis_tx.setValue(state,x_worldo);
% y_body
% pelvis_ty.setValue(state,GetDesiredData(t,6,CM));
% pelvis_ty.setValue(state,-y_body+0.0725);
% pelvis_tz.setValue(state,GetDesiredData(t,7,CM));
% pelvis_tilt.setValue(state,0);
% har = GetDesiredData(t,8,CM);
har = traj;
hip_flexion_r.setValue(state,har*1);
% hip_flexion_r.setValue(state,GetDesiredData(t,8,CM));
% hip_adduction_r.setValue(state,GetDesiredData(t,9,CM));
% hip_rotation_r.setValue(state,GetDesiredData(t,10,CM));
% kar = GetDesiredData(t,11,CM);
kar = -2*har;
knee_angle_r.setValue(state,kar*1);
% knee_angle_r.setValue(state,GetDesiredData(t,11,CM));
% aar = -(pa + har + kar);
aar = har;
ankle_angle_r.setValue(state,aar*1);
% aar = GetDesiredData(t,12,CM);
% ankle_angle_r.setValue(state,aar);
% ankle_angle_r.setValue(state,GetDesiredData(t,12,CM));
% subtalar_angle_r.setValue(state,GetDesiredData(t,13,CM));
% mtp_angle_r.setValue(state,GetDesiredData(t,14,CM));
% mar = -(pa + har + kar + aar);
% mtp_angle_r.setValue(state,mar);
% hal = GetDesiredData(t,15,CM);
hal = har;
hip_flexion_l.setValue(state,hal*1);
% hip_flexion_l.setValue(state,GetDesiredData(t,15,CM));
% hip_adduction_l.setValue(state,GetDesiredData(t,16,CM));
% hip_rotation_l.setValue(state,GetDesiredData(t,17,CM));
% kal = GetDesiredData(t,18,CM);
kal = kar;
knee_angle_l.setValue(state,kal*1);
% knee_angle_l.setValue(state,GetDesiredData(t,18,CM));
% aal = -(pa + hal + kal);
% ankle_angle_l.setValue(state,aal);
% aal = GetDesiredData(t,19,CM);
aal = aar;
ankle_angle_l.setValue(state,aal*1);
% mal = -(pa + hal + kal + aal);
% ankle_angle_l.setValue(state,GetDesiredData(t,19,CM));
% subtalar_angle_l.setValue(state,GetDesiredData(t,20,CM));
% mtp_angle_l.setValue(state,GetDesiredData(t,21,CM));
% mtp_angle_l.setValue(state,mal);
% lumbar_extension.setValue(state,GetDesiredData(t,22,CM));
% lumbar_bending.setValue(state,GetDesiredData(t,23,CM));
% lumbar_rotation.setValue(state,GetDesiredData(t,24,CM));

pelvis_tilt.setLocked(state,true);
% pelvis_list.setLocked(state,true);
% pelvis_rotation.setLocked(state,true);
pelvis_tx.setLocked(state,true);
% pelvis_ty.setLocked(state,true);
% pelvis_tz.setLocked(state,true);
hip_flexion_r.setLocked(state,true);
% hip_adduction_r.setLocked(state,true);
% hip_rotation_r.setLocked(state,true);
knee_angle_r.setLocked(state,true);
ankle_angle_r.setLocked(state,true);
% subtalar_angle_r.setLocked(state,true);
% mtp_angle_r.setLocked(state,true);
hip_flexion_l.setLocked(state,true);
% hip_adduction_l.setLocked(state,true);
% hip_rotation_l.setLocked(state,true);
knee_angle_l.setLocked(state,true);
ankle_angle_l.setLocked(state,true);
% subtalar_angle_l.setLocked(state,true);
% mtp_angle_l.setLocked(state,true);
% lumbar_extension.setLocked(state,true);
% lumbar_bending.setLocked(state,true);
% lumbar_rotation.setLocked(state,true);

% jb39b40.updCoordinate().setLocked(state,true);
% jb47b48.updCoordinate().set_locked(state,true);
% jb6b56.updCoordinate().set_locked(state,true);
% jb10b11.updCoordinate().set_locked(state,true);
% jb18b19.updCoordinate().set_locked(state,true);
% jb35b27.updCoordinate().set_locked(state,true);


end


