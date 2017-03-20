%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% More info at S. Barrachina, B. Bellalta, T. Adame, and A. Bel, “Multi-hop Communication in the Uplink for LPWANs,” 
%%% arXiv preprint arXiv:1611.08703, 2016.
%%%
%%% File description: function for setting the ring locations.

function [d_ring] = spread_rings(spread_model, fibo_stress, num_rings, d_max)
% SPREAD_RINGS sets the ring distances depending on the selected model.
%   Arguments:
%   - spread_model: equidistant, fibonacci or reverse fibonnaci (0, 1 or 2)
%   - fibo_stress: first fibonnaci number to consider (0 if usual)
%   - num_rings: ring of the node
%   - d_max: GW max range (with max TX power and min TX rate). Last ring
%   is placed at d_max
%   - d_ring: distance between each ring and the GWn

    load('configuration.mat','RING_SPREAD_MODEL_EQUIDISTANT','RING_SPREAD_MODEL_FIBONACCI',...
        'RING_SPREAD_MODEL_INVERSE_FIBONACCI')   % Load configuration into local workspace
    
    d_ring = zeros(1,num_rings);
    % Equidistant model
    if spread_model == RING_SPREAD_MODEL_EQUIDISTANT
        d_unit = floor(d_max / num_rings);  % Distance between consecutive rings [m]
        d_ring = d_unit .* (1:num_rings);   % Distance between each ring and the GW
    % Fibonacci spreading
    elseif spread_model == RING_SPREAD_MODEL_FIBONACCI
        fibo_distance_factor = d_max/fibonacci(num_rings+fibo_stress);
        for ring_ix = 1:num_rings
            d_ring(ring_ix)=fibonacci(ring_ix + fibo_stress)*fibo_distance_factor;
        end

    % Rev-Fibonnaci spreading
    elseif spread_model == RING_SPREAD_MODEL_INVERSE_FIBONACCI
        % Fibonacci spreading
        d_fibo = zeros(1,num_rings);
        fibo_distance_factor = d_max/fibonacci(num_rings+fibo_stress);
        for ring_ix = 1:num_rings
            d_fibo(ring_ix)=fibonacci(ring_ix + fibo_stress)*fibo_distance_factor;
        end
        for ring_ix = 1:num_rings
            if(ring_ix==num_rings)
                d_ring(ring_ix) = d_max;
            elseif(ring_ix==1)
                d_ring(ring_ix)= 0 +(d_fibo(num_rings-ring_ix+1)-d_fibo(num_rings-ring_ix));
            else
                d_ring(ring_ix)=d_ring(ring_ix-1)+(d_fibo(num_rings-ring_ix+1)-d_fibo(num_rings-ring_ix));
            end
        end
    end
end
