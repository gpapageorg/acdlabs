clc;
clear;
close all;

linear_P0;

A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;

% R1 = diag([10^-15.28;10^-15.3]);
% R1 = diag([0.0001;0.0001])
R1 = diag([1e-15;1e-15])

R2 = 10^-10;

N = zeros(6,2);
N(5,1) = 1;
N(6,2) = 1;

P = icare(A',C',N*R1*N',R2);
K = (P*C')/R2

M = zeros(2,6);
M(1,1) = 1;
M(2,2) = 1;

Q1 = [1 0;
    0 1];
Q2  = [40 0;
    0 20];

S = icare(A,B,M'*Q1*M, Q2);


L = inv(Q2)*(B')*S; %Checked With Matlab's lqr command
    

% eigs(A-B*L)
Lr = inv(M*inv((B*L -A))*B);


sys =ss(A,B,C,0);

d1 = linear_params.tank1_opening * 0.25;
d2 = linear_params.tank2_opening * 0.25;
disp(datestr(now, 'HH:MM:SS'))
