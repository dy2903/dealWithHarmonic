
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
load('../Data/dataOfPilot.mat')

% dataToCalibrate = dataOfPilot;
% [row , col ] = size (dataToCalibrate);
%
%  ================== figure ==================
fig_num    = 1 ; 
NumOfFigure = 2 ; 

% # ************** Main Function of Calibration ********************
 % for   i = 1 : row
  % a_mainCalibrate(finArray(i),f_test(i),fs_adc,numOfChannel,fig_num ,order, dataToCalibrate (i , : ) , dataOfPilot(i , :))    

    % fig_num = fig_num + NumOfFigure;  
 % end
 
  [ C_estima]  = f_estimateNonLinear(dataOfPilot, f_test,order ,  numOfChannel,fs_adc);
 

