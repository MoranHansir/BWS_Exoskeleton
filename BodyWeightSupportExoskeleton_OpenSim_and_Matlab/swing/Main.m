 
clc;clear;
% close all;

import org.opensim.modeling.*;

Exo = Model('simbody1.osim');
Exo.setName('LoadCarryingExoskeleton_by_Moran');

BodyName = DefineBodyName();
BodyMass = load('mass2.txt');
MassCenter = DefineMassCenter();
BodyInertia = load('inertia2.txt')/1000000;
GeoPath = SelectGeoPathName();
%% 添加外骨骼零件；
% Add exo parts;
for i=1:58
eval( [ BodyName{i} '= CreatBody( BodyName{' num2str(i) '} ,BodyMass(' num2str(i) '),MassCenter{' num2str(i) '},BodyInertia(i,:), GeoPath{' num2str(i) '} );' ] );
eval( [ 'Exo.addBody(' BodyName{i} ')' ] );
end
%% 添加外骨骼关节；
% Add joints;
AddExoJoints;
%% 添加背部负载；
% 背部连接板；
% Add connection plate on the back;
backpack1 = Body('backpack1',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(backpack1);
bp1x=0.008;bp1y=0.18;bp1z=0.2;
backpack1Geometry = Brick(Vec3(bp1x,bp1y,bp1z));
backpack1Geometry.setColor(Vec3(0.1, 0.8, 0.8));
backpack1Geometry.setOpacity(0.5);
backpack1.attachGeometry(backpack1Geometry);

% backpack2 = Body('backpack2',0,Vec3(0),Inertia(Vec3(0)));
% Exo.addBody(backpack2);
% bp2x=0.125;bp2y=bp1y;bp2z=bp1x;
% backpack2Geometry = Brick(Vec3(bp2x,bp2y,bp2z));
% backpack2Geometry.setColor(Vec3(0.1,0.8,0.8));
% backpack2Geometry.setOpacity(0.5);
% backpack2.attachGeometry(backpack2Geometry);

jbackpack1 = WeldJoint('jbackpack1',...
    Body7,Vec3(ex,ey,ez),Vec3(0),...
    backpack1,Vec3(0,0,bp1z),Vec3(0));
Exo.addJoint(jbackpack1);

% jbackpack2 = WeldJoint('jbackpack2',...
%     backpack1,Vec3(0),Vec3(0),...
%     backpack2,Vec3(-bp2x,0,-0.13),Vec3(0));
% Exo.addJoint(jbackpack2);

% loadMass = 30;
% loadHalfLength = 0.122;
% loadInertia = Inertia(Vec3(loadMass * 2/3*loadHalfLength^2));
% load = Body('load',loadMass,Vec3(0),loadInertia);
% loadGeometry = Brick(Vec3(loadHalfLength));
% loadGeometry.setColor(Vec3(1,0,0));
% load.attachGeometry(loadGeometry);
% Exo.addBody(load);

% loadConnectPoint = Body('loadConnectPoint',0,Vec3(0),Inertia(Vec3(0)));
% Exo.addBody(loadConnectPoint);

% jlcp = WeldJoint('jlcp',...
%     load,Vec3(-loadHalfLength-0.008,0,0),Vec3(0),...
%     loadConnectPoint,Vec3(0),Vec3(0));
% Exo.addJoint(jlcp);

% jload = FreeJoint('jload',...
%     backpack1,Vec3(0),Vec3(0),...
%     load,Vec3(-loadHalfLength-0.008,0,0),Vec3(0));
% jload = FreeJoint('jload',...
%     backpack1,Vec3(0),Vec3(0),...
%     loadConnectPoint,Vec3(0),Vec3(0));
% Exo.addJoint(jload);

% 锁定矢状面外得三个自由度；
% jload.upd_coordinates(0).set_locked(true);
% % jload.upd_coordinates(1).set_locked(true);
% jload.upd_coordinates(2).set_locked(true);
% % jload.upd_coordinates(3).set_locked(true);
% jload.upd_coordinates(4).set_locked(true);
% % jload.upd_coordinates(5).set_locked(true);

% 在负载和背部板间添加bushignForce；
% pHRI_load = BushingForce('pHRI_load',...
%     'backpack1',Vec3(0),Vec3(0),...
%     'load',Vec3(-loadHalfLength-0.008,0,0),Vec3(0),...
%     Vec3(10000,0,50000),Vec3(0,1000,0),Vec3(5000,0,5000),Vec3(0,100,0));
% Exo.addForce(pHRI_load);


%% 添加外骨骼关节驱动器；
% Add actuators;
tao_hip_abduction_r = TorqueActuator(Body39,Body40,Vec3(1,0,0),false);
tao_hip_abduction_r.setName('tao_hip_abduction_r');
Exo.addForce(tao_hip_abduction_r);
tao_hip_rotation_r = TorqueActuator(Body47,Body48,Vec3(0,0,1),false);
tao_hip_rotation_r.setName('tao_hip_rotation_r');
Exo.addForce(tao_hip_rotation_r);
tao_hip_flexion_r = TorqueActuator(Body41,Body42,Vec3(0,1,0),false);
tao_hip_flexion_r.setName('tao_hip_flexion_r');
Exo.addForce(tao_hip_flexion_r);
tao_knee_flexion_r = TorqueActuator(Body55,Body5,Vec3(0,1,0),false);
tao_knee_flexion_r.setName('tao_knee_flexion_r');
Exo.addForce(tao_knee_flexion_r);
tao_ankle_flexion_r = TorqueActuator(Body5,Body6,Vec3(0,1,0),false);
tao_ankle_flexion_r.setName('tao_ankle_flexion_r');
Exo.addForce(tao_ankle_flexion_r);
% 对驱动器进行分组；
Actuators_Set = SetActuators();
Actuators_Set.setName('Actuators_Set');
actuators_r = ObjectGroup('actuators_r');
actuators_r.add(tao_hip_abduction_r);
actuators_r.add(tao_hip_rotation_r);
actuators_r.add(tao_hip_flexion_r);
actuators_r.add(tao_knee_flexion_r);
actuators_r.add(tao_ankle_flexion_r);
Actuators_Set.addGroup('actuators_r');

tao_hip_abduction_l = TorqueActuator(Body10,Body11,Vec3(1,0,0),false);
tao_hip_abduction_l.setName('tao_hip_abduction_l');
Exo.addForce(tao_hip_abduction_l);
tao_hip_rotation_l = TorqueActuator(Body18,Body19,Vec3(0,0,1),false);
tao_hip_rotation_l.setName('tao_hip_rotation_l');
Exo.addForce(tao_hip_rotation_l);
tao_hip_flexion_l = TorqueActuator(Body12,Body13,Vec3(0,1,0),false);
tao_hip_flexion_l.setName('tao_hip_flexion_l');
Exo.addForce(tao_hip_flexion_l);
tao_knee_flexion_l = TorqueActuator(Body26,Body34,Vec3(0,1,0),false);
tao_knee_flexion_l.setName('tao_knee_flexion_l');
Exo.addForce(tao_knee_flexion_l);
tao_ankle_flexion_l = TorqueActuator(Body34,Body35,Vec3(0,1,0),false);
tao_ankle_flexion_l.setName('tao_ankle_flexion_l');
Exo.addForce(tao_ankle_flexion_l);
% 对驱动器进行分组；
% Actuators_Set = SetActuators();
actuators_l = ObjectGroup('actuators_l');
actuators_l.add(tao_hip_abduction_l);
actuators_l.add(tao_hip_rotation_l);
actuators_l.add(tao_hip_flexion_l);
actuators_l.add(tao_knee_flexion_l);
actuators_l.add(tao_ankle_flexion_l);
Actuators_Set.addGroup('actuators_l');
%% 添加外骨骼控制器；
% Add controllers;
ExoCtr = PrescribedController();
% ExoCtr.setActuators(Actuators_Set);
ExoCtr.setActuators(Exo.updActuators());
ExoCtr.setName('ExoCtr');
Exo.addController(ExoCtr);

Ctr_func_thar = PiecewiseConstantFunction();
Ctr_func_thrr = PiecewiseConstantFunction();
Ctr_func_thfr = PiecewiseConstantFunction();
Ctr_func_tkfr = PiecewiseConstantFunction();
Ctr_func_tafr = PiecewiseConstantFunction();
Ctr_func_thar.setName('Ctr_func_thar');
Ctr_func_thrr.setName('Ctr_func_thrr');
Ctr_func_thfr.setName('Ctr_func_thfr');
Ctr_func_tkfr.setName('Ctr_func_tkfr');
Ctr_func_tafr.setName('Ctr_func_tafr');
Ctr_func_thar.addPoint(0,0);
Ctr_func_thrr.addPoint(0,0);
Ctr_func_thfr.addPoint(0,0);
Ctr_func_tkfr.addPoint(0,0);
Ctr_func_tafr.addPoint(0,0);
ExoCtr.prescribeControlForActuator('tao_hip_abduction_r',Ctr_func_thar);
ExoCtr.prescribeControlForActuator('tao_hip_rotation_r',Ctr_func_thrr);
ExoCtr.prescribeControlForActuator('tao_hip_flexion_r',Ctr_func_thfr);
ExoCtr.prescribeControlForActuator('tao_knee_flexion_r',Ctr_func_tkfr);
ExoCtr.prescribeControlForActuator('tao_ankle_flexion_r',Ctr_func_tafr);

Ctr_func_thal = PiecewiseConstantFunction();
Ctr_func_thrl = PiecewiseConstantFunction();
Ctr_func_thfl = PiecewiseConstantFunction();
Ctr_func_tkfl = PiecewiseConstantFunction();
Ctr_func_tafl = PiecewiseConstantFunction();
Ctr_func_thal.setName('Ctr_func_thal');
Ctr_func_thrl.setName('Ctr_func_thrl');
Ctr_func_thfl.setName('Ctr_func_thfl');
Ctr_func_tkfl.setName('Ctr_func_tkfl');
Ctr_func_tafl.setName('Ctr_func_tafl');
Ctr_func_thal.addPoint(0,0);
Ctr_func_thrl.addPoint(0,0);
Ctr_func_thfl.addPoint(0,0);
Ctr_func_tkfl.addPoint(0,0);
Ctr_func_tafl.addPoint(0,0);
ExoCtr.prescribeControlForActuator('tao_hip_abduction_l',Ctr_func_thal);
ExoCtr.prescribeControlForActuator('tao_hip_rotation_l',Ctr_func_thrl);
ExoCtr.prescribeControlForActuator('tao_hip_flexion_l',Ctr_func_thfl);
ExoCtr.prescribeControlForActuator('tao_knee_flexion_l',Ctr_func_tkfl);
ExoCtr.prescribeControlForActuator('tao_ankle_flexion_l',Ctr_func_tafl);

%% 添加人机背部bushing力；
% Add spring-damper on the back;
bcp = Body('bcp',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(bcp);
bcb = Body('bcb',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(bcb);
jbcp = WeldJoint('jbcp',...
    pelvis,Vec3(px,py,pz),Vec3(0),...
    bcp,Vec3(0),Vec3(0));
Exo.addJoint(jbcp);
jbcb = WeldJoint('jbcb',...
    Body7,Vec3(ex,ey,ez),Vec3(pi/2,0,pi),...
    bcb,Vec3(0),Vec3(0));
Exo.addJoint(jbcb);

pHRI = BushingForce('pHRI',...
    'bcp','bcb',...
    Vec3(10000,10000,0),Vec3(0,0,500),Vec3(1000,1000,0),Vec3(0,0,50*1));
Exo.addForce(pHRI);

%% Add a ground.
floor = ContactHalfSpace(Vec3(0), Vec3(0, 0, -pi/2), Exo.getGround(), 'floor');
%% 右脚与地面碰撞模型；   Add right foot contact with floor.
ballRadius = 0.01;
ballTrans_foot_fr_r = Vec3(0.298818-0.28, 0.11046-0.04, 1.466);
ball_foot_fr_r = ContactSphere(ballRadius,ballTrans_foot_fr_r,Body56,'ball_foot_fr_r');
ballTrans_foot_fl_r = Vec3(0.298818-0.28, 0.11046+0.04, 1.466);
ball_foot_fl_r = ContactSphere(ballRadius,ballTrans_foot_fl_r,Body56,'ball_foot_fl_r');
ballTrans_foot_br_r = Vec3(0.298818+0.28, 0.11046-0.04, 1.466);
ball_foot_br_r = ContactSphere(ballRadius,ballTrans_foot_br_r,Body56,'ball_foot_br_r');
ballTrans_foot_bl_r = Vec3(0.298818+0.28, 0.11046+0.04, 1.466);
ball_foot_bl_r = ContactSphere(ballRadius,ballTrans_foot_bl_r,Body56,'ball_foot_bl_r');
stiffness = 1.e8; dissipation = 0.5; friction = [0.9, 0.9, 0.6];
contactForce_r = HuntCrossleyForce();
contactForce_r.setName('cfoot_r');
contactForce_r.setStiffness(stiffness);
contactForce_r.setDissipation(dissipation);
contactForce_r.setStaticFriction(friction(1));
contactForce_r.setDynamicFriction(friction(2));
contactForce_r.setViscousFriction(friction(3));
contactForce_r.addGeometry('floor');
contactForce_r.addGeometry('ball_foot_fr_r');
contactForce_r.addGeometry('ball_foot_fl_r');
contactForce_r.addGeometry('ball_foot_br_r');
contactForce_r.addGeometry('ball_foot_bl_r');
Exo.addContactGeometry(floor);
Exo.addContactGeometry(ball_foot_fr_r);
Exo.addContactGeometry(ball_foot_fl_r);
Exo.addContactGeometry(ball_foot_br_r);
Exo.addContactGeometry(ball_foot_bl_r);
Exo.addForce(contactForce_r);
%% 左脚与地面碰撞模型；   Add left foot contact with floor.
% ballRadius = 0.01;
ballTrans_foot_fr_l = Vec3(0.298818-0.28, 0.58846-0.04, 1.466);
ball_foot_fr_l = ContactSphere(ballRadius,ballTrans_foot_fr_l,Body27,'ball_foot_fr_l');
ballTrans_foot_fl_l = Vec3(0.298818-0.28, 0.58846+0.04, 1.466);
ball_foot_fl_l = ContactSphere(ballRadius,ballTrans_foot_fl_l,Body27,'ball_foot_fl_l');
ballTrans_foot_br_l = Vec3(0.298818+0.28, 0.58846-0.04, 1.466);
ball_foot_br_l = ContactSphere(ballRadius,ballTrans_foot_br_l,Body27,'ball_foot_br_l');
ballTrans_foot_bl_l = Vec3(0.298818+0.28, 0.58846+0.04, 1.466);
ball_foot_bl_l = ContactSphere(ballRadius,ballTrans_foot_bl_l,Body27,'ball_foot_bl_l');
% stiffness = 1.e8; dissipation = 0.5; friction = [0.9, 0.9, 0.6];
contactForce_l = HuntCrossleyForce();
contactForce_l.setName('cfoot_l');
contactForce_l.setStiffness(stiffness);
contactForce_l.setDissipation(dissipation);
contactForce_l.setStaticFriction(friction(1));
contactForce_l.setDynamicFriction(friction(2));
contactForce_l.setViscousFriction(friction(3));
contactForce_l.addGeometry('floor');
contactForce_l.addGeometry('ball_foot_fr_l');
contactForce_l.addGeometry('ball_foot_fl_l');
contactForce_l.addGeometry('ball_foot_br_l');
contactForce_l.addGeometry('ball_foot_bl_l');
% Exo.addContactGeometry(floor); 
Exo.addContactGeometry(ball_foot_fr_l);
Exo.addContactGeometry(ball_foot_fl_l);
Exo.addContactGeometry(ball_foot_br_l);
Exo.addContactGeometry(ball_foot_bl_l);
Exo.addForce(contactForce_l);

contactForce_r.set_appliesForce(false);
% contactForce_l.set_appliesForce(false);
%% 添加背部连接标记点；
% Add a mark of back connection point;
pelvis_marker_geometry = Sphere(0.02);
pelvis_marker_geometry.setColor(Vec3(0.8,0.1,0.1));
pelvis_marker_frame = PhysicalOffsetFrame('pmf',pelvis,...
    Transform(Vec3(px,py,pz)));
pelvis.addComponent(pelvis_marker_frame);
pelvis_marker_frame.attachGeometry(pelvis_marker_geometry);

exo_marker_geometry = pelvis_marker_geometry.clone();
exo_marker_frame = PhysicalOffsetFrame('emf',Body7,...
    Transform(Vec3(ex,ey,ez)));
Body7.addComponent(exo_marker_frame);
exo_marker_frame.attachGeometry(exo_marker_geometry);

%% 将自由度限制在矢状面；
% 锁定外骨骼矢状面以外的自由度；
% Lock the freedoms outside the sigittal plane;
jb39b40.updCoordinate().set_locked(true);
jb47b48.updCoordinate().set_locked(true);
jb6b56.updCoordinate().set_locked(true);
jb10b11.updCoordinate().set_locked(true);
jb18b19.updCoordinate().set_locked(true);
jb35b27.updCoordinate().set_locked(true);
% 锁定盆骨人机连接处矢状面外的三个自由度；
jpb7.upd_coordinates(0).set_locked(true); % x rotation;
jpb7.upd_coordinates(1).set_locked(true); % y rotation;
% jpb7.upd_coordinates(5).set_locked(true); % x transmation;
jpb7.upd_coordinates(5).set_locked(true); % z transmation;

% % 锁定左右脚人机连接处矢状面的自由度，释放矢状面以外的自由度；
foot_r.upd_coordinates(2).set_locked(true); % z rotation;
foot_r.upd_coordinates(3).set_locked(true); % x transmation;
foot_r.upd_coordinates(4).set_locked(false); % y transmation;

foot_l.upd_coordinates(2).set_locked(true);
foot_l.upd_coordinates(3).set_locked(true);
foot_l.upd_coordinates(4).set_locked(false);

%% 添加足底交互力；
% Add interaction models (spring-damper) at the foot;
fch_r = Body('fch_r',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(fch_r);
fce_r = Body('fce_r',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(fce_r);
jfch_r = WeldJoint('jfch_r',...
    toes_r,Vec3(-0.23,-0.015,0),Vec3(0,0,0),...
    fch_r,Vec3(0),Vec3(0));
Exo.addJoint(jfch_r);
jfce_r = WeldJoint('jfce_r',...
    Body56,Vec3(0.298818, 0.11046, 1.466),Vec3(pi/2,0,pi),...
    fce_r,Vec3(0),Vec3(0));
Exo.addJoint(jfce_r);

pHRI_fr = BushingForce('pHRI_fr',...
    'fch_r','fce_r',...
    Vec3(2e4*1,2e4,0),Vec3(0,0,2e3*1),Vec3(4e3*0,4e2,0),Vec3(0,0,2e2*1));
Exo.addForce(pHRI_fr);

fch_l = Body('fch_l',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(fch_l);
fce_l = Body('fce_l',0,Vec3(0),Inertia(Vec3(0)));
Exo.addBody(fce_l);
jfch_l = WeldJoint('jfch_l',...
    toes_l,Vec3(-0.23,-0.015,0),Vec3(0,0,0),...
    fch_l,Vec3(0),Vec3(0));
Exo.addJoint(jfch_l);
jfce_l = WeldJoint('jfce_l',...
    Body27,Vec3(0.298818,0.58846,1.466),Vec3(pi/2,0,pi),...
    fce_l,Vec3(0),Vec3(0));
Exo.addJoint(jfce_l);

pHRI_fl = BushingForce('pHRI_fl',...
    'fch_l','fce_l',...
    Vec3(2e4*2,2e4*2,0),Vec3(0,0,2e3*2),Vec3(4e3*4,4e2*2.5,0),Vec3(0,0,2e2*2));
Exo.addForce(pHRI_fl);

%% 限制

%% 设置初值；
% Set up the initial value;
% jb5b6.updCoordinate().setDefaultValue(20/180*pi);
% jb34b35.updCoordinate().setDefaultValue(-20/180*pi);
j1 = Coordinate.safeDownCast(Exo.updComponent('jb5b6/jb5b6_coord_0'));
j2 = Coordinate.safeDownCast(Exo.updComponent('jb55b5/jb55b5_coord_0'));
j3 = Coordinate.safeDownCast(Exo.updComponent('jb41b42/jb41b42_coord_0'));
j4 = Coordinate.safeDownCast(Exo.updComponent('jb12b13/jb12b13_coord_0'));
j5 = Coordinate.safeDownCast(Exo.updComponent('jb26b34/jb26b34_coord_0'));
j6 = Coordinate.safeDownCast(Exo.updComponent('jb34b35/jb34b35_coord_0'));
j1.set_default_value(0.61902);
j2.set_default_value(-1.0652);
j3.set_default_value(0.44625);
j4.set_default_value(-0.44624);
j5.set_default_value(1.0652);
j6.set_default_value(-0.61901);
jpy = Coordinate.safeDownCast(Exo.updComponent('ground_pelvis/pelvis_ty'));
jpx = Coordinate.safeDownCast(Exo.updComponent('ground_pelvis/pelvis_tx'));
jprz= Coordinate.safeDownCast(Exo.updComponent('ground_pelvis/pelvis_tilt'));
% jpy.set_locked(true);
jpy.set_default_value(1.0194+0.0254*0+0.1*0);
jpy.set_locked(false);
jpx.set_locked(true);
jprz.set_locked(true);
%% Reporter;
reporter = TableReporter();
reporter.setName('Exo_results');
reporter.set_report_time_interval(0.001);
reporter.addToReport(...
    Exo.getComponent('ground_pelvis/pelvis_tx').getOutput('value'),'p_tx');
reporter.addToReport(...
    Exo.getComponent('ground_pelvis/pelvis_ty').getOutput('value'),'p_ty');
reporter.addToReport(...
    Exo.getComponent('ground_pelvis/pelvis_tilt').getOutput('value'),'p_rz');
reporter.addToReport(j1.getOutput('value'),'q1');
reporter.addToReport(j2.getOutput('value'),'q2');
reporter.addToReport(j3.getOutput('value'),'q3');
reporter.addToReport(j4.getOutput('value'),'q4');
reporter.addToReport(j5.getOutput('value'),'q5');
reporter.addToReport(j6.getOutput('value'),'q6');
reporter.addToReport(j1.getOutput('speed'),'w1');
reporter.addToReport(j2.getOutput('speed'),'w2');
reporter.addToReport(j3.getOutput('speed'),'w3');
reporter.addToReport(j4.getOutput('speed'),'w4');
reporter.addToReport(j5.getOutput('speed'),'w5');
reporter.addToReport(j6.getOutput('speed'),'w6');
reporter.addToReport(j1.getOutput('acceleration'),'a1');
reporter.addToReport(j2.getOutput('acceleration'),'a2');
reporter.addToReport(j3.getOutput('acceleration'),'a3');
reporter.addToReport(j4.getOutput('acceleration'),'a4');
reporter.addToReport(j5.getOutput('acceleration'),'a5');
reporter.addToReport(j6.getOutput('acceleration'),'a6');
Exo.addComponent(reporter);
%% 打印或仿真；
% Output the built human-robot model;
Exo.print('MoranExo4.osim');
%
sExo = Exo.initSystem();
%
Simulate3(Exo, sExo, true);



