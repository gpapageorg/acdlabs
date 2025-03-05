clc;
clear;
close all;

parameters

%% Linear Model Parameters
g = 982;

%Calculating Linear model
linear_params.h10 = 12.3; %Range [0, 20]
linear_params.h20 = 12.8;
linear_params.h30 = 1.6;
linear_params.h40 = 1.4;

linear_params.k1 = 3.33;
linear_params.k2 = 3.35;
linear_params.gamma1 = 0.70;
linear_params.gamma2 = 0.60;

T1 = (linear_params.tank1_area / linear_params.tank1_opening) * sqrt(2 * linear_params.h10 / g);
T2 = linear_params.tank2_area / linear_params.tank2_opening * sqrt(2 * linear_params.h20 / g);
T3 = linear_params.tank3_area / linear_params.tank3_opening * sqrt(2 * linear_params.h30 / g);
T4 = linear_params.tank4_area / linear_params.tank4_opening * sqrt(2 * linear_params.h40 / g);

c1 = (T1 * linear_params.k1 * linear_params.kc) / linear_params.tank1_area;
c2 = (T2 * linear_params.k2 * linear_params.kc) / linear_params.tank2_area;

G11 = tf(linear_params.gamma1 * c1, [T1 1]);
G12 = tf((1 - linear_params.gamma2) * c1, conv([T1 1], [T3 1]));
G21 = tf((1 - linear_params.gamma1) * c2, conv([T2 1], [T4 1]));
G22 = tf(linear_params.gamma2 * c2, [T2 1]);

sys.G11 = G11;
sys.G12 = G12;
sys.G21 = G21;
sys.G22 = G22;

G = [G11 G12;G21 G22];
sys.G = G;

S = ss(G)
S = minreal(S)
A = S.A
B = S.B
C = S.C
D = S.D

A_aug = zeros(6,6);
B_aug = zeros(6,2);
C_aug = zeros(2,6);

A_aug(1:4,1:4) = A;
A_aug(3,5) = -sqrt(2*g*linear_params.h30)/ linear_params.tank3_area;
A_aug(4,6) = -sqrt(2*g*linear_params.h40)/ linear_params.tank4_area;
B_aug(1:4,1:2) = B;
C_aug(1:2,1:4) = C;
C_aug(1,5) = 1;
C_aug(2,6) = 1;
A_aug(5,5) = -10^-5;
A_aug(6,6) = -10^-5;
D_aug = [0,0;0,0];

A = A_aug
B = B_aug
C = C_aug
D = D_aug

R1 = diag([1e-3;1e-3]);

R2 = 10^-10;

N = zeros(6,2);
N(5,1) = 1;
N(6,2) = 1;

P = icare(A',C',N*R1*N',R2);
K = (P*C')/R2;

M = zeros(2,6);
M(1,1) = 1;
M(2,2) = 1;

Q1 = [1 0;
    0 1];
Q2  = [1 0;
    0 1];

S = icare(A,B,M'*Q1*M, Q2);


L = inv(Q2)*(B')*S %Checked With Matlab's lqr command

% eigs(A-B*L)
Lr = inv(M*inv((B*L -A))*B);
