%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% More info at S. Barrachina, B. Bellalta, T. Adame, and A. Bel, “Multi-hop Communication in the Uplink for LPWANs,” 
%%% arXiv preprint arXiv:1611.08703, 2016.
%%%
%%% File description: Function for computing several parameters for performing a consumption analysis corresponding 
%%% to nodes belonging to a given ring and implementing a SINGLE-HOP or NEXT-RING-HOP.

function [ connectivity_matrix ] = get_connectivity_matrix(ring_hops_combination)
% get_connectivity_matrix returns ...
%   - ring_hops_combination: array representing the hop lenght of each ring
%   - connectivity_matrix: a R x R (0,1)-matrix in which rings and corresponding payload aggregation are represented by 
%     rows and columns, respectively.

load('configuration.mat')

connectivity_matrix = zeros(num_rings,num_rings); % Matrix containing link relations (hyerarchy) for composing a branch flow

    for ring_ix_aux = 1:num_rings

        ring_ix = num_rings - ring_ix_aux + 1;                  % Begin from last ring
        dest_ring = ring_ix - ring_hops_combination(ring_ix);   % Get destination ring
        connectivity_matrix(ring_ix, ring_ix) = 1;  % Always transmit ring's payload

        if dest_ring > 0    % If destination is not the GW, add ring's payload to ring destination
            connectivity_matrix(dest_ring,:) = connectivity_matrix(dest_ring,:) + connectivity_matrix(ring_ix,:);
            connectivity_matrix(dest_ring, ring_ix) = 1;
        end
    end

end