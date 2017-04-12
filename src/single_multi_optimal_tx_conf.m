%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% More info at S. Barrachina, B. Bellalta, T. Adame, and A. Bel, “Multi-hop Communication in the Uplink for LPWANs,” 
%%% arXiv preprint arXiv:1611.08703, 2016.
%%%
%%% File description: Function for computing several parameters for performing a consumption analysis corresponding 
%%% to nodes belonging to a given ring and implementing a SINGLE-HOP or NEXT-RING-HOP.

function [E_tx, P_opt, ix_P, r_opt, ix_r, E_rx, avg_num_payloads, max_num_payloads, avg_num_packets, ring_dest, num_packets_rx] =...
        single_multi_optimal_tx_conf(routing_mode, ring, aggregation_on)
% single_multi_optimal_tx_conf returns several parameters corresponding to the
% optimal TX configuration (TX output power, TX rate) in terms of energy 
% savings for the nodes in a given ring and routing mode.
%   Arguments:
%   - routing_mode: single-hop or next-ring-hop (0 or 1)
%   - ring: ring of the node
%   - aggregation_on: aggregation flag (0: no aggreagation, 1: aggregation)
%   Returned parameters:
%   - E_tx: energy consumed with the optimal configuration
%   - P_opt: optimal transmission power
%   - ix_P: index of the optimal power level
%   - r_opt: optimal rate
%   - ix_r: index of the optimal rate level
%   - E_rx: receiving energy consumption for next-ring-hop model
%   - num_packets_rx: number of packets received by a node in a ring
%   (in single-hop no E_rx is consumed)
%   - avg_num_payloads: Average number of payloads to be sent per STA
%   - max_num_payloads: Maximum number of payloads to be sent per STA (when
%   probability of transmitting is 1)
%   - avg_num_packets: Average number of DFSs to be sent per STA
%   - ring_destination: index of the destination ring

load('configuration.mat')
D_max = zeros(length(P_LVL),length(R_LVL));    % Maximum distance matrix
e_opt = 100000000000;       % Optimal consumption (to be minimized)
P_opt = 0;                  % Optimal TX power
avg_num_payloads = 0;

for pow_ix = 1:length(P_LVL)
    
    for rate_ix = 1:length(R_LVL)
        
        % Compute maximum communication range. Notice that the sensibility
        % depends on the transmission rate (i.e., modulation).
        D_max(pow_ix,rate_ix) = max_distance(prop_model, P_LVL(pow_ix), Grx, Gtx, S(rate_ix), f);
        
        % Single-hop ROUTING_MODEL_SINGLE_HOP
        if routing_mode == ROUTING_MODEL_SINGLE_HOP
            
            ring_dest = 0;              % Destination is always the GW no matter the source ring
            d_to_parent = d_ring(ring); % Distance to next-hop (direct link to GW)
            
            % If max communication distance covers distance to parent
            if D_max(pow_ix,rate_ix) >= d_to_parent       
                rate = R_LVL(rate_ix);                      % Rate [bps]
                num_payloads = 1;                           % Max number of payloads to be transmitted
                num_packets = num_payloads;                 % No aggregation in single-hop
                t_tx = (num_packets * L_DP * 8) / rate;     % Each STA sends a L_DP frame
                e_tx = t_tx * (I_LVL(pow_ix) * V);          % TX energy
                num_packets_rx = 0;                         % No packets are received in SH
                e_rx = 0;                                   % RX energy
                e = e_tx + e_rx;   % Total energy is just TX energy (no RX energy is consumed in SH)
                if e < e_opt
                    % Pick optimal transmitting values
                    P_opt = P_LVL(pow_ix);
                    ix_P = pow_ix;
                    r_opt = R_LVL(rate_ix);
                    ix_r = rate_ix;
                    E_tx = e_tx;
                    E_rx = e_rx;
                    e_opt = e;   
                end
            end
            avg_num_payloads = num_payloads;    % Number of payloads
            avg_num_packets = num_packets;      % Average number of packets
            max_num_payloads = num_payloads;    % Each node sends just its own payload
            
            
        % Next-ring-hop ROUTING_MODEL_NEXT_RING_HOP 
        elseif routing_mode == ROUTING_MODEL_NEXT_RING_HOP
            
            ring_dest = ring - 1;   % Destination is always the next hop
            if ring_dest ~= 0
                d_to_parent = d_ring(ring) - d_ring(ring_dest); % Distance to next-hop
            else
                d_to_parent = d_ring(ring); % Distance from ring 1 to the GW
            end
            
            % If max communication distance covers distance to parent
            if D_max(pow_ix,rate_ix) >= d_to_parent
                
                rate = R_LVL(rate_ix);  % Rate [bps]
                
                % TRANSMISSION ENERGY
                num_payloads = sum(n(1:(num_rings - ring + 1)));    % Max number of payload to be transmitted (subtree size)
                max_num_payloads = num_payloads;
                
                % Get number of L_DP packets to transmit depending on payload aggregation
                if aggregation_on
                    num_packets = get_num_packets(num_payloads, p_ratio);
                else
                    num_packets = num_payloads;
                end
  
                avg_num_payloads = num_payloads;
                avg_num_packets = num_packets;
                t_tx = (num_packets * L_DP * 8) / rate;
                e_tx = t_tx * (I_LVL(pow_ix) * V);
                
                % RECEPTION ENERGY
                if ring < num_rings     % Nodes belonging to last ring don't have any children
                    
                    children_subtree_size = sum(n(1:num_rings-ring));   % Payloads to be listened from each child
                    
                    % Get number of L_DP packets to listen
                    if aggregation_on
                        num_packets_per_child = get_num_packets(children_subtree_size, p_ratio);
                    else
                        num_packets_per_child = children_subtree_size;
                    end
                    
                    num_packets_rx = child_ratio * num_packets_per_child;
                    
                    t_rx = (num_packets_rx * L_DP * 8) / rate;
                    e_rx = t_rx * I_rx * V;
                    
                else
                    num_packets_rx = 0;
                    e_rx = 0;
                end
                
                e = e_tx + e_rx;    % Total energy is just the sum of TX and RX energy
                
                if e < e_opt        % Optimize the transmission energy
                    % Pick optimal transmitting values
                    P_opt = P_LVL(pow_ix);
                    ix_P = pow_ix;
                    r_opt = R_LVL(rate_ix);
                    ix_r = rate_ix;
                    E_tx = e_tx;
                    E_rx = e_rx;
                    e_opt = e;
                end
            end
            
        else
            error(['Invalid routing mode! routing mode = ' num2str(routing_mode)]);
        end
    end
end