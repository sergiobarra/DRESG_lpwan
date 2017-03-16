%%% "Ring Network Topology (RNT) Framework" project (September 2016)
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)

function [ fair_optimal_conf, optimal_delta_conf ] = fair_optimal_tx_conf(aggregation)
% fair_optimal_tx_conf returns 2 parameters corresponding to the best TX
% configuration and routing links (hops) for the fair-hop routing mode
%   Arguments:
%   - aggregation: aggregation flag (0: no aggreagation, 1: aggregation)
%   Returned parameters:
%   - diverse_optimal_conf: optimal configuration
%   - optimal_delta_conf: optimal delta values for each ring

load('configuration.mat')
balanced_results = zeros(num_delta_combinations, num_rings, 10);
disp('- progress: 0%')
for delta_conf_ix = 1:num_delta_combinations
    
    % delta_combinations(delta_conf,:)
    balanced_ring_links = zeros(num_rings,num_rings); % Matrix containing link relations (hyerarchy) for composing a branch flow
    for pow_ix = 1:num_rings
        ring_ix = num_rings - pow_ix + 1;
        dest_ring = ring_ix - delta_combinations(delta_conf_ix,ring_ix);
        if dest_ring > 0
            balanced_ring_links(dest_ring,:) = balanced_ring_links(dest_ring,:) + balanced_ring_links(ring_ix,:);
            balanced_ring_links(dest_ring, ring_ix) = 1;
        end
    end
    balanced_num_hops = delta_combinations(delta_conf_ix,:);
    
    ring_dest = (1:num_rings) - balanced_num_hops;
    
    % balanced_ring_links
    % balanced_num_hops
    % ring_dest
    
    for aux_ix = 1:num_rings
        ring = num_rings - aux_ix + 1;
        Dmax = zeros(length(P_LVL),length(R_LVL));     % Maximum distance matrix
        E_TX = zeros(length(P_LVL),length(R_LVL));     % TX consumption matrix for suitable configurations (else: 0)
        E_RX = zeros(length(P_LVL),length(R_LVL));     % RX consumption matrix for suitable configurations (else: 0)
        E_opt = 100000000000;                          % Optimal consumption (to be minimized)
        P_opt = 0;
        for pow_ix = 1:length(P_LVL)
            for rate_ix = 1:length(R_LVL)
                Dmax(pow_ix,rate_ix) = max_distance(prop_model, P_LVL(pow_ix), Grx, Gtx, S(rate_ix), f);
            end
            for j = 1:length(R_LVL)
                if Dmax(pow_ix,j) >= d_ring(balanced_num_hops(ring))  % Link to correspondent parent ring
                    r_aux = R_LVL(j);
                    % Transmission
                    ring_payloads_ix = find(balanced_ring_links(ring,:)==1);
                    Np = sum(n(ring_payloads_ix)) / n(ring) + 1;    % Max number of payload to be txd (subtree size)
                    max_ring_load = Np;
                    % num_dfs_tx = ceil(num_payloads / p_ratio);  % Padding taken into account
                    
                    % Get number of DFS packets to transmit
                    if aggregation == 1
                        num_dfs = get_num_dfs(Np, p_ratio);
                    elseif aggregation == 0
                        num_dfs = Np;
                    else
                        error('Aggregation flag unknown!')
                    end
                    ring_load = Np;
                    dfs_ring_load = num_dfs;
                    t_tx = (num_dfs * DFS * 8) / r_aux;
                    E_TX(pow_ix,j) = t_tx * (I_LVL(pow_ix) * V);
                    % Reception
                    t_rx = 0;
                    dfs_received = 0;
                    for source_ring_ix=1:num_rings
                        if ring_dest(source_ring_ix) == ring     % If source ring is linked to current ring
                            link_children_ratio = n(source_ring_ix)/n(ring);
                            num_dfs_per_child =  balanced_results(delta_conf_ix, source_ring_ix, 9);
                            dfs_received = dfs_received + link_children_ratio * num_dfs_per_child;
                            t_rx = t_rx + (link_children_ratio * num_dfs_per_child * DFS * 8) / R_LVL(balanced_results(delta_conf_ix, source_ring_ix, 5));
                        end
                    end;
                    E_RX(pow_ix,j) = t_rx * I_rx * V;
                    
                    if (E_TX(pow_ix,j)+E_RX(pow_ix,j)) < E_opt % Optimize the transmission energy
                        P_opt = P_LVL(pow_ix);
                        ix_P = pow_ix;
                        r_opt = R_LVL(j);
                        ix_r = j;
                        E_tx = E_TX(pow_ix,j);
                        E_rx = E_RX(pow_ix,j);
                        E_opt = E_tx + E_rx;
                        balanced_results(delta_conf_ix, ring, 1) = E_tx;
                        balanced_results(delta_conf_ix, ring, 2) = P_opt;
                        balanced_results(delta_conf_ix, ring, 3) = ix_P;
                        balanced_results(delta_conf_ix, ring, 4) = r_opt;
                        balanced_results(delta_conf_ix, ring, 5) = ix_r;
                        balanced_results(delta_conf_ix, ring, 6) = E_rx;
                        balanced_results(delta_conf_ix, ring, 7) = ring_load;
                        balanced_results(delta_conf_ix, ring, 8) = max_ring_load;
                        balanced_results(delta_conf_ix, ring, 9) = dfs_ring_load;
                        balanced_results(delta_conf_ix, ring, 10) = ring - balanced_num_hops(ring);
                        balanced_results(delta_conf_ix, ring, 11) = dfs_received;
                    end
                end
            end
        end
    end
    if(delta_conf_ix == num_delta_combinations)
        disp('- progress: 100% completed!')
%     else
%         disp(['- progress: ' num2str(delta_conf_ix*100 / num_delta_combinations) '%'])
    end
end

% Get optimal delta configuration
bottleneck_delta = zeros(num_delta_combinations,2);
for delta_conf_ix = 1:num_delta_combinations
    [bottleneck_e, ix] = max((balanced_results(delta_conf_ix,:,1) + balanced_results(delta_conf_ix,:,6)));
    bottleneck_delta(delta_conf_ix,:) = [bottleneck_e, ix];
end
[~, optimal_delta_conf_ix] = min(bottleneck_delta(:,1));
fair_optimal_conf = squeeze(balanced_results(optimal_delta_conf_ix,:,:));

optimal_delta_conf = delta_combinations(optimal_delta_conf_ix, :);