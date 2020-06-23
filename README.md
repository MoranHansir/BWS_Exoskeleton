# BWS_Exoskeleton
This is a simulation project for a wearable body weight support exoskeleton by using the combined environment of Matlab and OpenSim.

Platform: win10, Matlab R2019a, OpenSim 4.0-2018-08-27-ae111a49

Step 1: Setting up Matlab scripting environment. Please refer to the documents of OpenSim.

Step 2: Open the Matlab, run Main.m. 

Tips:

1) Folder ExoGeometry1 holds the geometries of exoskeleton parts.

2) Folder Geometry holds the parts of human model.

3) The human-robot model is built in Main.m.

4) Simulate3.m is the entrance of the simulation. The simulation time is set as 10.5s. The simulation will begin at 1.5s.

5) The human movement is given in setNewState3.m.

6) Control method runs in ExciteCalculate_Stance.m.

7) FCMAC.m is the fuzzy CMAC controller.

8) The Control quantity is given to actuators in AddPoint.m.
