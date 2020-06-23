clc;clear;close all;
load('NoControl_named.mat')
load('DirecForceControl_named.mat')
figure(1);clf;
subplot(1,3,1)
plot(NC_t,NC_Fp(:,1),DFC_t,DFC_Fp(:,1));legend('NCx','DFCx')
subplot(1,3,2)
plot(NC_t,NC_Fp(:,2),DFC_t,DFC_Fp(:,2));legend('NCy','DFCy')
subplot(1,3,3)
plot(NC_t,NC_Fp(:,3),DFC_t,DFC_Fp(:,3));legend('NCz','DFCz')

figure(2);clf;
subplot(2,3,1)
plot(NC_t,NC_Fload(:,1));ylim([-200 200])
subplot(2,3,2)
plot(NC_t,NC_Fload(:,2));ylim([-600 600])
subplot(2,3,3)
plot(NC_t,NC_Fload(:,3));ylim([-50 150])
subplot(2,3,4)
plot(DFC_t,DFC_Fload(:,1));ylim([-200 200])
subplot(2,3,5)
plot(DFC_t,DFC_Fload(:,2));ylim([-600 600])
subplot(2,3,6)
plot(DFC_t,DFC_Fload(:,3));ylim([-50 150])