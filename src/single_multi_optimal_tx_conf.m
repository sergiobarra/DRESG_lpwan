%%% "Ring Network Topology (RNT) Framework" project (September 2016)
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)

function [E_tx, P_opt, ix_P, r_opt, ix_r, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] =...
        single_multi_optimal_tx_conf(routing_mode, ring, payload_aggregation)
% single_multi_optimal_tx_conf returns 6 parameters corresponding to the
% optimal TX configuration (TX output power, TX rate) in terms of energy 
% savings for the nodes in a give ring and routing mode.
%   Arguments:
%   - routing_mode: single-hop or next-ring-hop (0 or 1)
%   - ring: ring of the node
%   - payload_aggregation: aggregation flag (0: no aggreagation, 1: aggregation)
%   Returned parameters:
%   - E_tx: energy consumed with the optimal configuration
%   - P_opt: optimal transmission power
%   - ix_P: index of the optimal power level
%   - r_opt: optimal rate
%   - ix_r: index of the optimal rate level
%   - E_rx: receiving energy consumption (for multi-hop model)
%   - ring_load: Average number of payloads to be sent per STA
%   - max_ring_load: Maximum number of payloads to be sent per STA (when
%   probability of transmitting is 1)
%   - dfs_ring_load: Average number of DFSs to be sent per STA
%   - ring_destination: index of the destination ring

load('configuration.mat')
Dmax = zeros(length(P_LVL),length(R_LVL));     % Maximum distance matrix
E_TX = zeros(length(P_LVL),length(R_LVL));     % TX consumption matrix for suitable configurations (else: 0)
E_RX = zeros(length(P_LVL),length(R_LVL));     % RX consumption matrix for suitable configurations (else: 0)
E_opt = 100000000000;    % Optimal consumption (to be minimized)
P_opt = 0;
ring_load = 0;
for pow_ix = 1:length(P_LVL)
    for rate_ix = 1:length(R_LVL)
        Dmax(pow_ix,rate_ix) = max_distance(prop_model, P_LVL(pow_ix), Grx, Gtx, S(rate_ix), f);
    end
    for rate_ix = 1:length(R_LVL)
        % Single-hop
        if routing_mode == 0 
            if Dmax(pow_ix,rate_ix) >= d_ring(ring) % Direct link to GW
                r_aux = R_LVL(rate_ix);
                Np = 1; % Max number of payloads to be transmitted
                num_dfs = Np;   % No aggregation in single-hop
                t_tx = (num_dfs * L_DP * 8) / r_aux;    % Each STA sends a L_DP frame
                E_TX(pow_ix,rate_ix) = t_tx * (I_LVL(pow_ix) * V);  % e [mJ]
                if E_TX(pow_ix,rate_ix) < E_opt
                    P_opt = P_LVL(pow_ix);
                    ix_P = pow_ix;
                    r_opt = R_LVL(rate_ix);
                    ix_r = rate_ix;
                    E_tx = E_TX(pow_ix,rate_ix);
                    E_rx = 0;   % No receiving energy consumption in single-hop
                    E_opt = E_tx + E_rx;   
                end
            end
            ring_load = Np;  
            dfs_ring_load = num_dfs;
            max_ring_load = Np; % Each node send just its own payload
            ring_dest = 0;  % Destination is always the GW
            
        % Multi-hop
        elseif routing_mode == 1    
            if Dmax(pow_ix,rate_ix) > d_ring(1)    % hop-to-hop
                r_aux = R_LVL(rate_ix);
                % Transmission
                Np = sum(n(1:(num_rings - ring + 1)));    % Max number of payload to be txd (subtree size)
                max_ring_load = Np;
                
                % Get number of L_DP packets to transmit
                if payload_aggregation
                    num_dfs = get_num_dfs(Np, p_ratio);
                else
                    num_dfs = Np;
                end
                
                ring_load = Np;
                dfs_ring_load = num_dfs;
                t_tx = (num_dfs * L_DP * 8) / r_aux;
                E_TX(pow_ix,rate_ix) = t_tx * (I_LVL(pow_ix) * V);
                % Reception
                if ring < num_rings
                    children_subtree_size = sum(n(1:num_rings-ring));   % Payloads to be listened from each child
                    
                    % Get number of L_DP packets to listen
                    if payload_aggregation
                        num_dfs_per_child = get_num_dfs(children_subtree_size, p_ratio);
                    else
                        num_dfs_per_child = children_subtree_size;
                    end
                    
                    t_rx = (child_ratio * num_dfs_per_child * L_DP * 8) / r_aux;
                    E_RX(pow_ix,rate_ix) = t_rx * I_rx * V;
                end
                if (E_TX(pow_ix,rate_ix)+E_RX(pow_ix,rate_ix)) < E_opt % Optimize the transmission energy
                    P_opt = P_LVL(pow_ix);
                    ix_P = pow_ix;
                    r_opt = R_LVL(rate_ix);
                    ix_r = rate_ix;
                    E_tx = E_TX(pow_ix,rate_ix);
                    E_rx = E_RX(pow_ix,rate_ix);
                    E_opt = E_tx + E_rx;
                end
            end
            ring_dest = ring - 1;   % Destination is always the next hop
        else
            error(['Invalid routing mode! routing mode = ' num2str(routing_mode)]);
        end
    end
end