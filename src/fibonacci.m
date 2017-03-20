function F = fibonacci(n)
% FIBONACCI Fibonacci sequence
% F = FIBONACCI(n) generates the n'th Fibonacci number.
    if n == 0
        F = 0;
    elseif n == 1
        F = 1;
    else
        F = fibonacci(n-2)+fibonacci(n-1);
    end
end
