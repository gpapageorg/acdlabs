%% Modeling Uncertainties
clc;
clear;
close all;

parameters
a1_nom = linear_params.tank1_opening;
a1_min = a1_nom - 10/100 * a1_nom;
a1_max = a1_nom + 10/100 * a1_nom;

a1 = linspace(a1_min,a1_max,100);


a2_nom = linear_params.tank2_opening;
a2_min = a2_nom - 10/100 * a2_nom;
a2_max = a2_nom + 10/100 * a2_nom;

a2 = linspace(a2_min,a2_max,100);

gamma1 = linspace(0.56,0.70,100);
gamma2 = linspace(0.48,0.60,100);

allSystems = {};
lr = {};

linear_params.k1 = 3.33;
linear_params.k2 = 3.35;

linear_params.h10 = 12.3; %Range [0, 20]
linear_params.h20 = 12.8;
linear_params.h30 = 1.6;
linear_params.h40 = 1.4;

linear_params.k1 = 3.33;
linear_params.k2 = 3.35;
linear_params.gamma1 = 0.70;
linear_params.gamma2 = 0.60;

[A,B,C,D] = generate_linear(linear_params);
j = ss(A,B,C,D);
Gnom = tf(j);

samples = 10;

for i = 1:samples
    index1 = randi([1 samples]);
    index2 = randi([1 samples]);
    index3 = randi([1 samples]);
    index4 = randi([1 samples]);
    

    linear_params.gamma1 = gamma1(index1);
    linear_params.gamma2 = gamma2(index2);
    linear_params.tank1_opening = a1(index3);
    linear_params.tank2_opening = a2(index4);

    [sys.A, sys.B, sys.C, sys.D] = generate_linear(linear_params);
    sys = ss(sys.A, sys.B, sys.C, sys.D);
    tfsys = tf(sys);
    
    allSystems{end + 1} = tfsys;

    lr{end+1} = inv(tfsys)*(Gnom - tfsys) ;
end 

hold on;
for i=1:length(allSystems)
    thatSys = lr{i};
    sigma(thatSys);
    disp(i)
end

G11 = tf([2 1],[2 1])
G12 = tf([1 1],[2 1])

G21 = tf(1,[1 1])
G21 = tf(1,[4 1])

G = [G11 G12;G21 G22]
sigma(G)


