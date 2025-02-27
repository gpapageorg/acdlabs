clc;
clear;
close all;

linear_P0;
G_state_space = ss(sys.G);
G_state_space = minreal(G_state_space);

A = zeros(6, 6);
A(1:4,1:4) = G_state_space.A;
Na = zeros(6,2);
Na(3,1) = -sqrt(2*linear_params.g*linear_params.h30) / linear_params.tank3_area;
Na(4,2) = -sqrt(2*linear_params.g*linear_params.h40) / linear_params.tank4_area;
A(1:6,5:6) = Na;
A(5,5) = -10^-6;
A(6,6) = -10^-6;
B = zeros(6,2);
B(1:4,1:2) = G_state_space.B;
C = zeros(2,6);
C(1:2,1:4) = G_state_space.C;
C(1,5) = 1;
C(2,6) = 1;


R1 = diag([10^-8,10^-8])

R2 = 10^-10;
N = zeros(6,2);
N(5,1) = 1;
N(6,2) = 1;

P = icare(A',C',N*R1*N',R2,0);
K = (P*C')*R2;
Q2 = diag([1,1]);

M = zeros(2,6);
M(1,1) = 1;
M(2,2) = 1;
Q1 = eye(2);
R  = eye(2);

S = icare(A,B,M'*Q1*M, R);
L = (1\Q2)*B'*S; %Checked With Matlab's lqr command

Lr = inv(M*inv((B*L -A))*B);


sys =ss(A,B,C,0);