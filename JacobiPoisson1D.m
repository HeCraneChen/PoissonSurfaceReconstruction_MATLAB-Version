% Authors: He "Crane" Chen, Misha Kazhdan
% hchen136@jhu.edu
% Johns Hopkins University, 2021

close all;
n = 16;
f = ones(n, 1);
u = zeros(n, 1); % initial guess, zero initlal guess is common
dx = 1 / (n+1); % domain
for k = 1:1000
    u_k_p_1 = -dx.^2 / 2 * f;
    for i = 1:n
        if i < n
            u_k_p_1(i) = u_k_p_1(i) + u(i+1)/2;
        end
        if i > 1
            u_k_p_1(i) = u_k_p_1(i) + u(i-1)/2;

        end

    end
    u = u_k_p_1;
end
plot(u_k_p_1, 'o-')
r = f;
for i = 1:n
    if i > 1
        r(i) = r(i) - u(i-1) / dx^2;
    end
    if i < n
        r(i) = r(i) - u(i+1) / dx^2;
    end
    r(i) = r(i) + 2 * u(i) / dx^2;
end


% compare with exact solution
A = -2 * eye(n) / dx^2;
A = A + diag(ones(n-1, 1), -1) / dx^2;
A = A + diag(ones(n-1, 1), 1) / dx^2;
u_exact = A \ f;
hold on;
plot(u_exact, 'd--')

    