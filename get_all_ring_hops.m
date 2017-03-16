function [num_delta_combinations, delta_combinations] = get_all_ring_hops(R)
    % This algorithm computes the set of possible ring hops for a given 
    % number of rings by considering every possible routing link among the 
    % rings in the network.
    %   Arguments:
    %   - R: number of rings in the network
    %   Returned parameters:
    %   - num_delta_combinations: number of possible combinations of ring hops
    %   - delta_combinations: set of possible ring hops

    num_delta_combinations = factorial(R);
    delta_combinations = zeros(num_delta_combinations,R);
    start_ix = 1;
    for ring_ix = 1:R
        for j=1:factorial(ring_ix)
            portion = (factorial(R)/factorial(ring_ix));
            value = mod(j,ring_ix);
            if value == 0
                value = ring_ix;
            end
            delta_combinations(start_ix:portion*j,ring_ix) = value;
            start_ix = portion*j + 1;
        end
        start_ix = 1;
    end
end