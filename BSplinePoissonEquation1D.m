% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

% This code solves the Poisson equation d2u/dx2 = V, V = [-1, 0, 0, 1]
n = 4;
x = linspace(0, 4, n+1);
% x = [0, 1, 2, 3, 4];
A = zeros(n-1);
A = A + diag(1./(x(3:end) - x(2:end-1))) + diag(1./(x(2:end-1) - x(1:end-2)));
A = A - diag(1./(x(3:end-1) - x(2:end-2)), 1);
A = A - diag(1./(x(3:end-1) - x(2:end-2)), -1);
b = zeros(n-1, 1);
b(1) = 1;
b(3) = 1;
u = A \ b;
plot(x, [0; u; 0], 'o-');




