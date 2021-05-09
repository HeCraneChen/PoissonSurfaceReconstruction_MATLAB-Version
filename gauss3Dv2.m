function u1 = gauss3Dv2(u0, b, dx, dy, dz)
    n_interval = size(b, 1) - 1;
    u1 = ((dx^2 * dy^2 * dz^2) / (2*(dx^2 + dy^2 + dz^2))) * b;
    for i = 2:n_interval
        for j = 2:n_interval
            for k = 2:n_interval
                 u1(i,j,k) = (dx^2 * dy^2 * dz^2) / (2 * dx^2 + 2 * dy^2 + 2 * dz^2) * u1(i,j,k) +  (dy^2 * dz^2 * (u1(i-1,j,k) + u0(i+1,j,k)) + dx^2 * dz^2 * (u1(i,j-1,k) + u0(i,j+1,k)) + dx^2 * dy^2 * (u1(i,j,k-1) + u0(i,j,k+1)))/(2*dx^2 + 2*dy^2 + 2*dz^2);
            end
        end
    end
end