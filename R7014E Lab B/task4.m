clc;
clear;
close all;

linear_P0;

A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;

R1 = diag([10^-8,10^-8]);

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

Q1 = [1 0; 0 1];
R  = [2 0; 0 2];

S = icare(A,B,M'*Q1*M, R);


L = (1\Q2)*B'*S; %Checked With Matlab's lqr command

Lr = inv(M*inv((B*L -A))*B);


sys =ss(A,B,C,0);

%OTHER MODEL


% P_aug = icare(A_aug',C_aug',N*R1*N',R2,0);
% K_aug = (P_aug*C_aug')*R2;