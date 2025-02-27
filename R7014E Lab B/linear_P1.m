clc;
clear;
close all;
disp("Running P1");
parameters;

%Calculating Linear model
linear_params.h10 = 12.6; %Range [0, 20]
linear_params.h20 = 13;
linear_params.h30 = 4.8;
linear_params.h40 = 4.9;

linear_params.k1 = 3.14;
linear_params.k2 = 3.29;
linear_params.gamma1 = 0.67;
linear_params.gamma2 = 0.34;


G = generate_linear(linear_params);

poles = pole(G);
zeros = tzero(G);