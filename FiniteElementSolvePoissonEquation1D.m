% This code solves the Poisson equation d2u/dx2 + 1 = 0, with 10 elements by finite
% element method, choose hat functions as basis
n = 10;
x = rand(n-1, 1);
x = [0; sort(x); 1]; % 11 by 1
A = zeros(n-1); % 9 by 9
A = A + diag(1./(x(3:end) - x(2:end-1))) + diag(1./(x(2:end-1) - x(1:end-2)));
A = A - diag(1./(x(3:end-1) - x(2:end-2)), 1);
A = A - diag(1./(x(3:end-1) - x(2:end-2)), -1);
figure(1)
spy(A)
b = 0.5 * (x(3:end) - x(1:end-2));
u = A \ b; % linear combination coefficients for the hat functions
% solution visualization
figure(2)
plot(x, [0; u; 0], 'o-'); % looks very similar to the analytical solution (a parabolic)

