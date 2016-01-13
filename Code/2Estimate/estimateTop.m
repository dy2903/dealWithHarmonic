
clc;
clear all;
close all;

% # ************************** finArray + f_test *********************#########
numOfChannel              =      4;                              
fsPerChannel            =      100*10^6; 
fs_adc                   =     numOfChannel * fsPerChannel; 
SysSampPoint        =  2^21;  
f_test  = 0.019 * fs_adc;
finArray = f_test;
order = 3;
 %==================dataOfPilot====================
load('../../Data/dataOfPilot.mat')
%  ================== figure ==================
fig_num    = 1 ; 
NumOfFigure = 2 ; 
% # ************** Main Function of Calibration ********************
  [C_estimate]  = f_estimateNonLinear(dataOfPilot, f_test,order ,  numOfChannel,fs_adc);
  save ('../../Data/C_estima.mat' , 'C_estimate') ;

