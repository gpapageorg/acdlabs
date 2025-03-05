% clc;
% clear;
% close all;
disp("Running P0!");
parameters;


%Calculating Linear model
linear_params.h10 = 12.3; %Range [0, 20]
linear_params.h20 = 12.8;
linear_params.h30 = 1.6;
linear_params.h40 = 1.4;

linear_params.k1 = 3.33;
linear_params.k2 = 3.35;
linear_params.gamma1 = 0.70;
linear_params.gamma2 = 0.60;


[sys.A, sys.B, sys.C, sys.D] = generate_linear(linear_params);

disp("Complete P0!")