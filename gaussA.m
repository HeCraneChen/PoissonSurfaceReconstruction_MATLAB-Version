function u1 = gaussA(u0, A, b)
   u1 = zeros(size(b));
   n = size(A,2);
   for i = 1:size(A,1)
       A1 = A(i, 1:i-1);
       x1 = u1(1:i-1, 1);
       A2 = A(i, i+1:n);
       x2 = u0(i+1:n, 1);
       u1(i,1) = (b(i,1) - dot(A1, x1) - dot(A2, x2))/ A(i,i);
   end
end