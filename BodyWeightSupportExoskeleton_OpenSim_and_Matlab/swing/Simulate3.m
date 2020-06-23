function Simulate3(model, state, visualize)
% Simulate an OpenSim model from an initial state. The provided state is
% updated to be the state at the end of the simulation.
%
% Parameters
% ----------
% model: The OpenSim Model to simulate.
% state: The SimTK State to use as the initial state for the simulation.
% visualize (bool): Use the simbody-visualizer to visualize the simulation?

%-----------------------------------------------------------------------%
% The OpenSim API is a toolkit for musculoskeletal modeling and         %
% simulation. See http://opensim.stanford.edu and the NOTICE file       %
% for more information. OpenSim is developed at Stanford University     %
% and supported by the US National Institutes of Health (U54 GM072970,  %
% R24 HD065690) and by DARPA through the Warrior Web program.           %
%                                                                       %
% Copyright (c) 2017 Stanford University and the Authors                %
% Author(s): Thomas Uchida, Chris Dembia, Carmichael Ong, Nick Bianco,  %
%            Shrinidhi K. Lakshmikanth, Ajay Seth, James Dunne          %
%                                                                       %
% Licensed under the Apache License, Version 2.0 (the "License");       %
% you may not use this file except in compliance with the License.      %
% You may obtain a copy of the License at                               %
% http://www.apache.org/licenses/LICENSE-2.0.                           %
%                                                                       %
% Unless required by applicable law or agreed to in writing, software   %
% distributed under the License is distributed on an "AS IS" BASIS,     %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       %
% implied. See the License for the specific language governing          %
% permissions and limitations under the License.                        %
%-----------------------------------------------------------------------%

import org.opensim.modeling.*;

% This env. var. is used to turn off the visualizer during automated tests.
if getenv('OPENSIM_USE_VISUALIZER') == '1'
    visualize = true;
elseif getenv('OPENSIM_USE_VISUALIZER') == '0'
    visualize = false;
end

if visualize
    model.setUseVisualizer(true);
end
model.initSystem();

% Save this so that we can restart simulation from the given state.
% We use the copy constructor to perform a deep copy.
initState = State(state);

if visualize
    sviz = model.updVisualizer().updSimbodyVisualizer();
    sviz.setShowSimTime(true);
%     sviz.setRealTimeScale(0.1);
    % Show "ground and sky" background instead of just a black background.
    sviz.setBackgroundTypeByInt(3);

    % Show help text in the visualization window.
    help = DecorativeText('Press any key to start a new simulation; ESC to quit.');
    help.setIsScreenText(true);
    sviz.addDecoration(0, Transform(Vec3(0, 0, 0)), help);

    model.getVisualizer().show(initState);

    % Wait for the user to hit a key before starting the simulation.
    silo = model.updVisualizer().updInputSilo();
end

simulatedAtLeastOnce = false;

%% 定义全局变量；

while true
    if visualize
        % Ignore any previous key presses.
        silo.clear();
        % Get the next key press.
        while ~silo.isAnyUserInput()
            pause(0.01);
        end
        % The alternative `waitForKeyHit()` is not ideal for MATLAB, as MATLAB
        % is not able to interrupt native functions, and `waitForKeyHit()` will
        % hang if the simbody-visualizer is killed.
        key = silo.takeKeyHitKeyOnly();
        % Key 27 is ESC; see the SimTK::Visualizer::InputListener::KeyCode enum.
        if key == 27
            sviz.shutdown();
            if ~simulatedAtLeastOnce
                error('User exited visualizer without running any simulations.')
            end
            return;
        end
    end

    % Clear the table for all TableReporters. Note: this does not handle
    % TableReporters for Vec3s, etc.
    compList = model.getComponentsList();
    compIter = compList.begin();
    while ~compIter.equals(compList.end())
        if ~isempty(strfind(compIter.getConcreteClassName(),'TableReporter__double_'))
            comp = model.getComponent(compIter.getAbsolutePathString());
            reporter = TableReporter.safeDownCast(comp);
            reporter.clearTable();
        end
        compIter.next();
    end

    % Simulate.
    state = State(initState);
    manager = Manager(model);
    manager.initialize(state);
    
%     manager.setIntegratorMinimumStepSize(0.05);
    manager.setIntegratorMaximumStepSize(0.001);
%     manager.integrate(5);
%     %% 设置仿真时间；
    initTime = 0.5;
    simTime = 0.0;
    endTime = 10;
        
    state = manager.integrate(initTime);
    %% 初始化参数；
    k = (endTime)/0.01;
    i = 0;
    t = zeros(k,1);
    Fp = zeros(k,3);
    Ff_l = zeros(k,3);
    Ff_r = zeros(k,3);
    E = zeros(k,6);
    R_Dot = zeros(k,3);
    Dot_Er = zeros(k,1);

%     
%     
%     
    pHRI = BushingForce.safeDownCast(model.updComponent('pHRI'));   
    pHRI_fl = BushingForce.safeDownCast(model.updComponent('pHRI_fl'));
    pHRI_fr = BushingForce.safeDownCast(model.updComponent('pHRI_fr'));

%     contactForce_r = HuntCrossleyForce.safeDownCast(model.updComponent('cfoot_r'));
%     contactForce_l = HuntCrossleyForce.safeDownCast(model.updComponent('cfoot_l')); 
     

    %% 控制回环；
    while simTime < endTime

        i = i + 1;
        
        %% 实施控制；
        
        setNewState3(simTime,model,state);
        
        simTime = simTime + 0.01;
        state = manager.integrate(simTime+initTime);
       
        [Excites,e,r_dot] = ExciteCalculate_Stance(simTime, model, state);
        AddPoint(simTime, model, Excites);
        
        %% 记录数据；
        t(i) = simTime + initTime;
        iv = pHRI.getRecordValues(state);
        Fp(i,:) = [iv.get(7-1),iv.get(8-1),iv.get(12-1)];
        iv_fl = pHRI_fl.getRecordValues(state);
        Ff_l(i,:) = [iv_fl.get(7-1),iv_fl.get(8-1),iv_fl.get(12-1)];
        iv_fr = pHRI_fr.getRecordValues(state);
        Ff_r(i,:) = [iv_fr.get(7-1),iv_fr.get(8-1),iv_fr.get(12-1)];  
        
        E(i,:) = e';
        R_Dot(i,:) = r_dot';
%         Dot_Er(i) = dot_Er;
        
    end

    save('Stance_without_CMAC2.mat','t','Fp','Ff_l','Ff_r','E');
    
    figure(11);clf;
    subplot(3,1,1);
    plot(t,Ff_l(:,1));title('left foot interaction force - x');ylabel('Fx(N)');
    subplot(3,1,2);
    plot(t,Ff_l(:,2));title('left foot interaction force - y');ylabel('Fy(N)');
    subplot(3,1,3);
    plot(t,Ff_l(:,3));title('left foot interaction torque - z');xlabel('t(s)');ylabel('Tz(Nm)');

    figure(12);clf;
    subplot(3,1,1);
    plot(t,Ff_r(:,1));title('right foot interaction force - x');ylabel('Fx(N)');
    subplot(3,1,2);
    plot(t,Ff_r(:,2));title('right foot interaction force - y');ylabel('Fy(N)');
    subplot(3,1,3);
    plot(t,Ff_r(:,3));title('right foot interaction torque - z');xlabel('t(s)');ylabel('Tz(Nm)');
%     
% % save('rd.mat','t','rd_td_s');
% 
%     save('NoControl.mat','t','Fp','Fload','results','r_s','r_dot_s','r_dot2_s','rd_td_s','rd_dot_td2_s','rd_dot2_td_s');
% 
    figure(2);clf;
    subplot(3,1,1);
    plot(t,Fp(:,1));title('pelvis interaction force - x');ylabel('Fx(N)');
    subplot(3,1,2);
    plot(t,Fp(:,2));title('pelvis interaction force - y');ylabel('Fy(N)');
    subplot(3,1,3);
    plot(t,Fp(:,3));title('pelvis interaction torque - z');ylabel('Tz(Nm)');
    
    figure(3);clf;
    subplot(3,1,1);
    plot(t,E(:,1));title('x error');grid on;
    subplot(3,1,2);
    plot(t,E(:,2));title('y error');grid on;
    subplot(3,1,3);
    plot(t,E(:,3));title('tilt error');grid on;
    
    figure(4);clf;
    subplot(3,1,1);
    plot(t,E(:,4));title('dx error');grid on;
    subplot(3,1,2);
    plot(t,E(:,5));title('dy error');grid on;
    subplot(3,1,3);
    plot(t,E(:,6));title('dtilt error');grid on;
  
    figure(5);clf;
    subplot(3,1,1);
    plot(t,R_Dot(:,1));title('x dot');grid on;
    subplot(3,1,2);
    plot(t,R_Dot(:,2));title('y dot');grid on;
    subplot(3,1,3);
    plot(t,R_Dot(:,3));title('tilt dot');grid on;
    
%     figure(6);clf;
%     plot(t,Dot_Er)
%     hold on;
%     plot(t,E(:,5));title('Dot_Er');grid on;
    
    simulatedAtLeastOnce = true;

    % If there is no visualizer, only simulate once.
    if ~visualize
        return;
    end
%     model.print('IfLoced2.osim');
end
% model.print('IfLocked.osim');
end
