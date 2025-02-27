linear_P0;
lambda1 = 50;
lambda2 = 50;

Fr = 3;
d1 = 0.071 * 0.25; % range [0, 0.071]
d2 = 0.057 * 0.25; % range = [0, 057]
% IMC for h1
[numG11, denG11] = tfdata(sys.G11);
numG11 = numG11{1};
denG11 = denG11{1};

Q1 = tf(1, conv([lambda1 1],[lambda1 1])) * (1/ sys.G11);
[numQ1, denQ1] = tfdata(Q1);
numQ1 = numQ1{1};
denQ1 = denQ1{1};

% IMC for h2
[numG22, denG22] = tfdata(sys.G22);
numG22 = numG22{1};
denG22 = denG22{1};

Q2 = tf(1, conv([lambda2 1],[lambda2 1])) * (1/ sys.G22);
[numQ2, denQ2] = tfdata(Q2);
numQ2 = numQ2{1};
denQ2 = denQ2{1};

