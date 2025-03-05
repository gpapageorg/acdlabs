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

[Anom,Bnom,Cnom,Dnom]= generate_linear(linear_params);
Gnom = ss(Anom,Bnom,Cnom,Dnom);
usefull.Gnom = Gnom;
samples = 100;

for i = 1:samples
    index1 = randi([1 samples]);
    index2 = randi([1 samples]);
    index3 = randi([1 samples]);
    index4 = randi([1 samples]);
    

    linear_params.gamma1 = gamma1(index1);
    linear_params.gamma2 = gamma2(index2);
    linear_params.tank1_opening = a1(index3);
    linear_params.tank2_opening = a2(index4);

    [A,B,C,D]= generate_linear(linear_params);
    G = tf(ss(A,B,C,D));
    
    allSystems{end + 1} = G;

    lr{end+1} = (G - Gnom)*inv(G) ;
end 


% hold on;
% for i=1:length(allSystems)
%     thatSys = lr{i};
%     bode(thatSys)
%     disp(i)
% end
s = tf('s');

G11 = (s + 5)/(s+1);
G12 = 5 /(s+1);
G21 = 5 /(s+1);
G22 = (s + 5)/(s+1);
% bode([G11 G12;G21 G22])

usefull.D = [G11 G12;G21 G22];

R1 = diag([1e-15;1e-15]);

R2 = 10^-10;

N = zeros(6,2);
N(5,1) = 1;
N(6,2) = 1;

P = icare(Anom',Cnom',N*R1*N',R2);
K = (P*C')/R2;

M = zeros(2,6);
M(1,1) = 1;
M(2,2) = 1;

Q1 = [1 0;
    0 1];
Q2  = [40 0;
    0 20];

S = icare(Anom,Bnom,M'*Q1*M, Q2);


L = inv(Q2)*(Bnom')*S; %Checked With Matlab's lqr command


% eigs(A-B*L)
Lr = inv(M*inv((B*L -A))*B);

Lg = usefull.D*L;

hinfnorm(usefull.D*L)