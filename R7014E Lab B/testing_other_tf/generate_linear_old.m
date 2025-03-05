function [G, sys] = generate_linear(linear_params)
%Linear Model Parameters
g = 982;


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

end

