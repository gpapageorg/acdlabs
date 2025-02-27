function [A_aug, B_aug, C_aug, D_aug] = generate_linear(linear_params)
%Linear Model Parameters
g = 982;
a1 = linear_params.tank1_opening;
a2 = linear_params.tank2_opening;
a3 = linear_params.tank3_opening;
a4 = linear_params.tank4_opening;
A1 = linear_params.tank1_area;
A2 = linear_params.tank2_area;
A3 = linear_params.tank3_area;
A4 = linear_params.tank4_area;

h1_star = linear_params.h10;
h2_star = linear_params.h20;
h3_star = linear_params.h30;
h4_star = linear_params.h40;
gamma1 = linear_params.gamma1;
gamma2 = linear_params.gamma2;
k1 = linear_params.k1;
k2 = linear_params.k2;
kc = linear_params.kc;

A_m = [- (a1 / A1) * (sqrt(2 * g) / (2 * sqrt(h1_star))),  0, (a3 / A3) * (sqrt(2 * g) / (2 * sqrt(h3_star))), 0;
      0, - (a2 / A2) * (sqrt(2 * g) / (2 * sqrt(h2_star))), 0, (a4 / A4) * (sqrt(2 * g) / (2 * sqrt(h4_star)));
      0, 0, - (a3 / A3) * (sqrt(2 * g) / (2 * sqrt(h3_star))), 0;
      0, 0, 0, - (a4 / A4) * (sqrt(2 * g) / (2 * sqrt(h4_star)))];

B_m = [ (gamma1 / A1) * k1,  0;
      0, (gamma2 / A2) * k2;
      0, ((1 - gamma2) / A3) * k2;
      ((1 - gamma1) / A4) * k1, 0];

C_m = [kc, 0, 0, 0;
     0, kc, 0, 0];

A_aug = zeros(6,6);
B_aug = zeros(6,2);
C_aug = zeros(2,6);

A_aug(1:4,1:4) = A_m;
A_aug(3,5) = -sqrt(2*g*linear_params.h30)/ linear_params.tank3_area;
A_aug(4,6) = -sqrt(2*g*linear_params.h40)/ linear_params.tank4_area;
B_aug(1:4,1:2) = B_m;
C_aug(1:2,1:4) = C_m;
C_aug(1,5) = 1;
C_aug(2,6) = 1;
A_aug(5,5) = -10^-6;
A_aug(6,6) = -10^-6;
D_aug = [0,0;0,0];

end

