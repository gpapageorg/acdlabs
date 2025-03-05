clc; clear; close all;

%% System Parameters
A1 = 28; A2 = 32; A3 = 28; A4 = 32; % Tank cross-section areas (cm²)
a1 = 0.071; a2 = 0.057; a3 = 0.071; a4 = 0.057; % Outlet valve coefficients (cm²)
g = 981; % Gravity (cm/s²)
gamma1 = 0.6; gamma2 = 0.7; % Valve distribution ratios

%% Steady-State Heights
h1_ss = 12; h2_ss = 12; h3_ss = 20; h4_ss = 20; % Steady-state heights (cm)

%% Compute Flow Coefficients
c1 = a1 * sqrt(2*g/h1_ss);
c2 = a2 * sqrt(2*g/h2_ss);
c3 = a3 * sqrt(2*g/h3_ss);
c4 = a4 * sqrt(2*g/h4_ss);

%% State-Space Model
A = [-c1/A1,  0,      c3/A1,   0;
      0,    -c2/A2,   0,      c4/A2;
      0,     0,      -c3/A3,   0;
      0,     0,       0,     -c4/A4];

B = [gamma1/A1, 0;
      0, gamma2/A2;
      (1-gamma1)/A3, 0;
      0, (1-gamma2)/A4];

C = [1 0 0 0; 0 1 0 0]; % We measure h1 and h2
D = [0; 0];

%% Choose Q and R Matrices
Q = diag([10, 10, 1, 1]); % Penalize h1, h2 more
R = diag([1, 1]);         % Penalize control effort

%% Compute LQR Gain
K = lqr(A, B, Q, R);

%% Compute Reference Gain l_r
% Solve for l_r: (C*(-A)^-1*B) * l_r = I
l_r = inv(C * (-A) \ B);

%% Simulate the Closed-Loop System with Reference Tracking
T = 0:0.1:50; % Time vector
r = [15 * ones(length(T),1), 15 * ones(length(T),1)]; % Reference height (cm)

% Initialize state
x = zeros(4,1);
X_hist = zeros(length(T),4);
U_hist = zeros(length(T),2);

for i = 1:length(T)
    u = -K*x + l_r * r(i,:)'; % Control Law
    x = x + (A*x + B*u) * 0.1; % Euler integration (simple discretization)
    
    X_hist(i,:) = x'; % Store state
    U_hist(i,:) = u'; % Store input
end

%% Plot Results
figure;
subplot(2,1,1);
plot(T, X_hist(:,1), 'b', 'LineWidth', 2); hold on;
plot(T, X_hist(:,2), 'r', 'LineWidth', 2);
plot(T, r(:,1), 'k--', 'LineWidth', 2); % Reference
xlabel('Time (s)'); ylabel('Tank Heights (cm)');
legend('h1', 'h2', 'Reference');
title('Water Level Response with LQR + Reference Tracking');
grid on;

subplot(2,1,2);
plot(T, U_hist(:,1), 'b', 'LineWidth', 2); hold on;
plot(T, U_hist(:,2), 'r', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Control Inputs (V)');
legend('u1', 'u2');
title('Pump Voltage Control');
grid on;
