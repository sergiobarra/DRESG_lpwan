%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% File description: Main script for running DRESG analyses

% Close open figures and clear variables
clc
clear
close all


disp('**********************');
disp('*** DRESG ANALYSIS ***');
disp('**********************');

%%  SETUP
% NOTE: run 'set_configuration.m' script to generate the configuration .mat file

load('configuration.mat')   % Load configuration into local workspace



display_dresg_configuration = true;    % Print DRESG configuration? (0: No, 1: Yes)

if display_dresg_configuration

    disp('- DRESG deployment and scenario configuration:');
    
    disp('  · Physical parameters:');
    disp(['    - Propagation model: ' prop_model_str]);
    disp(['    - frequency =  ' num2str(f/(10^6)) ' MHz  (lambda = ' num2str(lambda) ' m)']);
    disp(['    - TX power output: Pt_{min} =  ' num2str(min(P_LVL)) ' dBm  Pt_{max} = ' num2str(max(P_LVL)) ' dBm']);
    disp(['    - No = ' num2str(No) ' dBm']);
    disp(['    - max. distance =  ' num2str(d_max) ' m']);
    disp('  · Hardware paremeters:');
    disp(['    - Transceiver model:  ' transceiver_model_str]);
    disp('  · Network parameters:');
    disp(['    - Fix packet length =  ' num2str(L_DP) ' B']);
    disp(['    - header length =  ' num2str(L_header) ' B']);
    disp(['    - payload length =  ' num2str(L_payload) ' B']);
    disp(['    - Max. payloads per L_DP (payload ratio) =  ' num2str(p_ratio)]);
    disp('  · DRESG topology:');
    disp(['    - child ratio =  ' num2str(child_ratio)]);
    disp(['    - number of rings =  ' num2str(num_rings)]);
    disp(['    - ring spreading model:  ' spread_model_str]);
    disp(['    - number of branches =  ' num2str(br)]);
    disp(['    - number of nodes =  ' num2str(n_total)]);
    for ring_ix=1:num_rings
        disp(['      * ring ' num2str(ring_ix) ': n = ' num2str(n(ring_ix)  * br) '  d = ' num2str(d_ring(ring_ix)) ' m']);
    end
    disp(' ')
end



%% IDENTIFY OF OPTIMAL CONFIGURATIONS

% Get optimal configuration for each ring. Stored it in 'results' matrix TO
% BE PROPERLY EXPLAINED!
sh_results = zeros(num_rings, RESULTS_NUM_ELEMENTS);           % Single-hop results
nrh_results = zeros(num_rings, RESULTS_NUM_ELEMENTS);          % Next-ring-hop results
nrh_noagg_results = zeros(num_rings, RESULTS_NUM_ELEMENTS);    % Next-ring-hop without aggregation results

disp('- Obtaining single-hop and Next-ring-hop transmission configurations (TX power & rate).')
disp('  NOTE: routing is pre-established by definition!')

% disp('  · progress: 0%')

for ring_ix = 1:num_rings
    
    ring = num_rings-ring_ix+1;
    
    % Single-hop (STA to GW)
    routing_mode = ROUTING_MODEL_SINGLE_HOP;
    payload_aggregation = false;
        
    [E_tx, P_opt, ix_P, r_opt, ix_R, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] =...
        single_multi_optimal_tx_conf(routing_mode, ring, payload_aggregation);
    
    sh_results(num_rings-ring_ix+1,RESULTS_IX_ENERGY_TX) = E_tx;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_POWER_OPT) = P_opt;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_POWER_LVL) = ix_P;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_R_OPT) = r_opt;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_R_LVL) = ix_R;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_ENERGY_RX) = E_rx;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_RING_LOAD) = ring_load;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_MAX_RING_LOAD) = max_ring_load;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_DFS_RING_LOAD) = dfs_ring_load;
    sh_results(num_rings-ring_ix+1,RESULTS_IX_RING_DESTIINATION) = ring_dest;
    
    
    %  Next-ring-hop (STA to parent in next ring)
    routing_mode = ROUTING_MODEL_NEXT_RING_HOP;
    payload_aggregation = true;
    
    [E_tx, P_opt, ix_P, r_opt, ix_R, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] =...
        single_multi_optimal_tx_conf(routing_mode, ring, payload_aggregation);
    
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_ENERGY_TX) = E_tx;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_POWER_OPT) = P_opt;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_POWER_LVL) = ix_P;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_R_OPT) = r_opt;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_R_LVL) = ix_R;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_ENERGY_RX) = E_rx;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_RING_LOAD) = ring_load;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_MAX_RING_LOAD) = max_ring_load;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_DFS_RING_LOAD) = dfs_ring_load;
    nrh_results(num_rings-ring_ix+1,RESULTS_IX_RING_DESTIINATION) = ring_dest;
       
    % Next-ring-hop without payload aggregation
    payload_aggregation = false;
    
    [E_tx, P_opt, ix_P, r_opt, ix_R, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] =...
        single_multi_optimal_tx_conf(routing_mode, ring, payload_aggregation);
    
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_ENERGY_TX) = E_tx;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_POWER_OPT) = P_opt;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_POWER_LVL) = ix_P;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_R_OPT) = r_opt;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_R_LVL) = ix_R;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_ENERGY_RX) = E_rx;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_RING_LOAD) = ring_load;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_MAX_RING_LOAD) = max_ring_load;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_DFS_RING_LOAD) = dfs_ring_load;
    nrh_noagg_results(num_rings-ring_ix+1,RESULTS_IX_RING_DESTIINATION) = ring_dest;
    
%     if(ring_ix == num_rings)
%         disp('  · progress: 100 %')
%     else
%         disp(['  · progress: ' num2str(ceil(ring_ix*100 / num_rings)) '%'])
%     end
end

% Optimal-hop
disp('- Obtaining Optimal-hop routing and optimal transmission configurations (TX power & rate)...')
disp('  NOTE: optimal routing will depend on DRESG deployment and scenario!')
[oh_results, optimal_diverse_delta_conf ] = fair_optimal_tx_conf(1);
[oh_noagg_results, optimal_diverse_delta_conf_no_agg ] = fair_optimal_tx_conf(0);

% Bottlenecks
[sh_btle_e, sh_btle_ix] = max(sh_results(:,1) + sh_results(:,6));       % Single-hop bottleneck energy and index
[nrh_btle_e, nrh_btle_ix] = max(nrh_results(:,1) + nrh_results(:,6));   % Next-ring-hop botteleneck enery and index
[nrh_noagg_btle_e, nrh_noagg_btle_ix] = max(nrh_noagg_results(:,1) + nrh_noagg_results(:,6));
[oh_btle_e, oh_btle_ix] = max(oh_results(:,1) + oh_results(:,6));
[oh_noagg_btle_e, oh_noagg_btle_ix] = max(oh_noagg_results(:,1) + oh_noagg_results(:,6));

disp(['- Optimal transmission configurations for Single-hop, Next-Ring-hop & Optimal-hop (with corresponding '...
    'optimal routing links in the last case) identified!'])

%% DISPLAY RESULTS

% ----------------------------------------------------------------------------------------------------------------------
% CONSOLE LOGS

% Flags for displaying routing modes results
display_sh = true;
display_nrh = true;
display_nrh_noagg = true;
display_oh = true;
display_oh_noagg = true;

if (display_sh || display_nrh || display_nrh_noagg || display_oh || display_oh_noag)
    disp(' ')
     disp('------------------------------------------------------------------------------------------ ')
    disp('DISPLAYING ENERGY CONSUMPTION RESULTS')
end

% Single
if display_sh
    disp(' ');
    disp('- SINGLE-HOP');
    for ring_ix = 1:num_rings
        disp(['  · Ring ' num2str(ring_ix) ' (d = ' num2str(d_ring(ring_ix)) ' m): ']);
        disp(['    * Destination ring: ' num2str(sh_results(ring_ix,10))]);
        disp(['    * Payloads per node (L_DPs): ' num2str(sh_results(ring_ix,7)) ' (' num2str(sh_results(ring_ix,9)) ')']);
        disp(['    * Max. payloads per node (L_DPs): ' num2str(sh_results(ring_ix,8)) ' (' num2str(get_num_dfs(sh_results(ring_ix,8),p_ratio)) ')']);
        disp(['    * Configuration: P_opt = ' num2str(sh_results(ring_ix,2)) ' dBm (level ' num2str(sh_results(ring_ix,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(sh_results(ring_ix,4) / 1000) ' Kbps (level ' num2str(sh_results(ring_ix,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['    * Energy cons.: E_tx = ' num2str(sh_results(ring_ix,1) * 1000) ' uJ - E_rx = ' num2str(sh_results(ring_ix,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('- Summary:')
    disp(['    * Bottleneck ring: ' num2str(sh_btle_ix) ' (' num2str(sh_btle_e * 1000) ' uJ)']);
    disp(['    * Overall energy cons.: ' num2str(sum((sh_results(:,1)+sh_results(:,6))'.* n)) ' mJ']);
end

% Multi
if display_nrh
    disp(' ');
    disp('- NEXT-RING-HOP');
    for ring_ix = 1:num_rings
        disp(['  · Ring ' num2str(ring_ix) ' (d = ' num2str(d_ring(ring_ix)) ' m): ']);
        disp(['    * Destination ring: ' num2str(nrh_results(ring_ix,10))]);
        disp(['    * Payloads per node (L_DPs): ' num2str(nrh_results(ring_ix,7)) ' (' num2str(nrh_results(ring_ix,9)) ')']);
        disp(['    * Max. payloads per node (L_DPs): ' num2str(nrh_results(ring_ix,8)) ' (' num2str(get_num_dfs(nrh_results(ring_ix,8),p_ratio)) ')']);
        disp(['    * Configuration: P_opt = ' num2str(nrh_results(ring_ix,2)) ' dBm (level ' num2str(nrh_results(ring_ix,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(nrh_results(ring_ix,4) / 1000) ' Kbps (level ' num2str(nrh_results(ring_ix,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['    *  Energy cons.: E_tx = ' num2str(nrh_results(ring_ix,1) * 1000) ' uJ - E_rx = ' num2str(nrh_results(ring_ix,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('  · Summary:')
    disp(['    * Bottleneck ring: ' num2str(nrh_btle_ix) ' (' num2str(nrh_btle_e * 1000) ' uJ)']);
    disp(['    * Overall energy cons.: ' num2str(sum((nrh_results(:,1)+nrh_results(:,6))'.* n)) ' mJ']);
end

% Multi without aggregation
if display_nrh_noagg
    disp(' ');
    disp('- NEXT-RING-HOP (NO AGGREGATION)');
    for ring_ix = 1:num_rings
        disp(['  · Ring ' num2str(ring_ix) ' (d = ' num2str(d_ring(ring_ix)) ' m): ']);
        disp(['    * Destination ring: ' num2str(nrh_noagg_results(ring_ix,10))]);
        disp(['    * Payloads per node (L_DPs): ' num2str(nrh_noagg_results(ring_ix,7)) ' (' num2str(nrh_noagg_results(ring_ix,9)) ')']);
        disp(['    * Max. payloads per node (L_DPs): ' num2str(nrh_noagg_results(ring_ix,8)) ' (' num2str(get_num_dfs(nrh_noagg_results(ring_ix,8),p_ratio)) ')']);
        disp(['    * Configuration: P_opt = ' num2str(nrh_noagg_results(ring_ix,2)) ' dBm (level ' num2str(nrh_noagg_results(ring_ix,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(nrh_noagg_results(ring_ix,4) / 1000) ' Kbps (level ' num2str(nrh_noagg_results(ring_ix,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['    * Energy cons.: E_tx = ' num2str(nrh_noagg_results(ring_ix,1) * 1000) ' uJ - E_rx = ' num2str(nrh_noagg_results(ring_ix,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('  · Summary:')
    disp(['    * Bottleneck ring: ' num2str(nrh_noagg_btle_ix) ' (' num2str(nrh_noagg_btle_e * 1000) ' uJ)']);
    disp(['    * Overall energy cons.: ' num2str(sum((nrh_noagg_results(:,1)+nrh_noagg_results(:,6))'.* n)) ' mJ']);
end

if display_oh
    % Optimal-hop
    disp(' ');
    disp('- OPTIMAL-HOP');
    disp(['  · Optimal delta configuration: ' num2str(optimal_diverse_delta_conf)]);
    for ring_ix = 1:num_rings
        disp(['    * Ring ' num2str(ring_ix) ' (d = ' num2str(d_ring(ring_ix)) ' m): ']);
        disp(['    * Destination ring: ' num2str(oh_results(ring_ix,10))]);
        disp(['    * Payloads per node (L_DPs): ' num2str(oh_results(ring_ix,7)) ' (' num2str(oh_results(ring_ix,9)) ')']);
        disp(['    * Max. payloads per node (L_DPs): ' num2str(oh_results(ring_ix,8)) ' (' num2str(get_num_dfs(oh_results(ring_ix,8),p_ratio)) ')']);
        disp(['    * Configuration: P_opt = ' num2str(oh_results(ring_ix,2)) ' dBm (level ' num2str(oh_results(ring_ix,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(oh_results(ring_ix,4) / 1000) ' Kbps (level ' num2str(oh_results(ring_ix,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['    * Energy cons.: E_tx = ' num2str(oh_results(ring_ix,1) * 1000) ' uJ - E_rx = ' num2str(oh_results(ring_ix,6) * 1000) ' uJ']);
        disp(['    * L_DPs received: ' num2str(oh_results(ring_ix,11))]);
    end
    disp(' ');
    disp('  · Summary:')
    disp(['    * Bottleneck ring: ' num2str(oh_btle_ix) ' (' num2str(oh_btle_e * 1000) ' uJ)']);
    disp(['    * Overall energy cons.: ' num2str(sum((oh_results(:,1)+oh_results(:,6))'.* n)) ' mJ']);
end

if display_oh_noagg
    % Fair-hop without aggregation
    disp(' ');
    disp('- OPTIMAL-HOP (NO AGGREGATION)');
    disp(['  · Optimal delta configuration: ' num2str(optimal_diverse_delta_conf_no_agg)]);
    for ring_ix = 1:num_rings
        disp(['  · Ring ' num2str(ring_ix) ' (d = ' num2str(d_ring(ring_ix)) ' m): ']);
        disp(['    * Destination ring: ' num2str(oh_noagg_results(ring_ix,10))]);
        disp(['    * Payloads per node (L_DPs): ' num2str(oh_noagg_results(ring_ix,7)) ' (' num2str(oh_noagg_results(ring_ix,9)) ')']);
        disp(['    * Max. payloads per node (L_DPs): ' num2str(oh_noagg_results(ring_ix,8)) ' (' num2str(get_num_dfs(oh_noagg_results(ring_ix,8),p_ratio)) ')']);
        disp(['    * Configuration: P_opt = ' num2str(oh_noagg_results(ring_ix,2)) ' dBm (level ' num2str(oh_noagg_results(ring_ix,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(oh_noagg_results(ring_ix,4) / 1000) ' Kbps (level ' num2str(oh_noagg_results(ring_ix,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['    * Energy cons.: E_tx = ' num2str(oh_noagg_results(ring_ix,1) * 1000) ' uJ - E_rx = ' num2str(oh_noagg_results(ring_ix,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('  · Summary:')
    disp(['    * Bottleneck ring: ' num2str(oh_noagg_btle_ix) ' (' num2str(oh_noagg_btle_e * 1000) ' uJ)']);
    disp(['    * Overall energy cons.: ' num2str(sum((oh_noagg_results(:,1)+oh_noagg_results(:,6))'.* n)) ' mJ']);
end

disp(['  · Optimal-hop bottleneck improvement against single / Next: ' num2str(sh_btle_e/oh_btle_e) ' ' num2str(nrh_btle_e/oh_btle_e)])
disp(['  · Optimal-hop bottleneck improvement against no aggregation: ' num2str(oh_noagg_btle_e/oh_btle_e)])


% ----------------------------------------------------------------------------------------------------------------------
% PLOTS

% Flags for ploting

% Routing modes energy consumption
plot_e_per_node = true;
plot_network_tx_e = false;
plot_network_total_e = true;
plot_bottlenecks_e = true;

% Aggregation vs no aggregation
plot_e_per_node_nrh_aggregation = true;
plot_e_per_node_oh_aggregation = true;
% All routings (with/out aggregation)
plot_e_per_node_all = true;
plot_e_per_node_single_fair_agg = true;

if(plot_e_per_node || plot_network_tx_e || plot_network_total_e || plot_bottlenecks_e...
        || plot_e_per_node_nrh_aggregation || plot_e_per_node_oh_aggregation || plot_e_per_node_all)
    disp(' ')
    disp('- Plotting...')
end
% Energy per node
if plot_e_per_node
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [sh_results(1,1) nrh_results(1,1) oh_results(1,1)];
    for ring_ix = 2:num_rings
        y = [y; [sh_results(ring_ix,1) nrh_results(ring_ix,1) oh_results(ring_ix,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Next-ring-hop';  l{3}='Optimal-hop';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
    ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [sh_results(1,6) nrh_results(1,6) oh_results(1,6)];
    for ring_ix = 2:num_rings
        y = [y; [sh_results(ring_ix,6) nrh_results(ring_ix,6) oh_results(ring_ix,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Next-ring-hop';  l{3}='Optimal-hop';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(sh_results(1,1)+sh_results(1,6)) (nrh_results(1,1)+nrh_results(1,6)) (oh_results(1,1)+oh_results(1,6))];
    for ring_ix = 2:num_rings
        y = [y; [(sh_results(ring_ix,1)+sh_results(ring_ix,6)) (nrh_results(ring_ix,1)+nrh_results(ring_ix,6)) (oh_results(ring_ix,1)+oh_results(ring_ix,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Next-ring-hop';  l{3}='Optimal-hop';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    suptitle('Energy consumption per STA')
    % linkaxes([ax2,ax1],'xy')
end

if plot_network_tx_e
    % Network TX energy
    figure
    y = [sh_results(:,1)' .* n; nrh_results(:,1)' .* n; oh_results(:,1)' .* n];
    B = bar(y,'stacked');
    set(gca, 'XTick',1:3, 'XTickLabel',{'Single-hop' 'Next-ring-hop' 'Optimal-hop'})
    % title('Network TX energy comparison')
    ylabel('e_{tx} [mJ]')
    legend_str = [];
    for ring_ix=1:num_rings
        aux_str = strcat('ring ', num2str(ring_ix));
        legend_str{end+1} = aux_str;
    end
    AX1=legend(B, legend_str, 'location', 'northwest','FontSize',8);
    suptitle('Total transmission energy consumed by the network')
end

if plot_network_total_e
    % Network total energy
    figure
    y = [(sh_results(:,1)+sh_results(:,6))' .* n; (nrh_results(:,1)+nrh_results(:,6))'.* n; (oh_results(:,1)+oh_results(:,6))'.* n];
    y_casCAS = y;
    B = bar(y./1000,'stacked');
    set(gca, 'XTick',1:3, 'XTickLabel',{'Single-hop' 'Next-ring-hop' 'Optimal-hop'})
    % title('Network total energy comparison')
    ylabel('e_{t} [mJ]')
    legend_str = [];
    for ring_ix=1:num_rings
        aux_str = strcat('r = ', num2str(ring_ix));
        legend_str{end+1} = aux_str;
    end
    grid on
    AX2=legend(B, legend_str, 'location', 'northeast','FontSize',8);
    suptitle('Total energy consumed by the network (transmitting + receiving)')
end

if plot_bottlenecks_e
    % Bottlenecks
    figure
    y = [sh_btle_e nrh_btle_e oh_btle_e; sh_results(sh_btle_ix,1) nrh_results(nrh_btle_ix,1) oh_results(oh_btle_ix,1); sh_results(sh_btle_ix,6) nrh_results(nrh_btle_ix,6) oh_results(oh_btle_ix,6)];
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}=(['Single-hop: ' num2str(sh_btle_ix)]); l{2}=['Next-ring-hop: ' num2str(nrh_btle_ix)]; l{3}=['Optimal-hop: ' num2str(oh_btle_ix)];
    legend(h_total_node,l);
    % title('Bottleneck energy consumption')
    set(gca,'XTickLabel',{'Total', 'TX', 'RX'})
    ylabel('e [mJ]')
    suptitle('Total energy consumed by BOTTLENECK STAs')
end

if plot_e_per_node_nrh_aggregation
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [nrh_results(1,1) nrh_noagg_results(1,1)];
    for ring_ix = 2:num_rings
        y = [y; [nrh_results(ring_ix,1) nrh_noagg_results(ring_ix,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Next-ring-hop (agg)'; l{2}='Next-ring-hop';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
     ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [nrh_results(1,6) nrh_noagg_results(1,6)];
    for ring_ix = 2:num_rings
        y = [y; [nrh_results(ring_ix,6) nrh_noagg_results(ring_ix,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Next-ring-hop (agg)'; l{2}='Next-ring-hop';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(nrh_results(1,1)+nrh_results(1,6)) (nrh_noagg_results(1,1)+nrh_noagg_results(1,6))];
    for ring_ix = 2:num_rings
        y = [y; [(nrh_results(ring_ix,1)+nrh_results(ring_ix,6)) (nrh_noagg_results(ring_ix,1)+nrh_noagg_results(ring_ix,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Next-ring-hop (agg)'; l{2}='Next-ring-hop';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    suptitle('Energy consumed per STA in NRH with/without payload aggregation')
    % linkaxes([ax2,ax1],'xy')
end

if plot_e_per_node_oh_aggregation
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [oh_results(1,1) oh_noagg_results(1,1)];
    for ring_ix = 2:num_rings
        y = [y; [oh_results(ring_ix,1) oh_noagg_results(ring_ix,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Aggregation'; l{2}='Forwarding';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
     ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [oh_results(1,6) oh_noagg_results(1,6)];
    for ring_ix = 2:num_rings
        y = [y; [oh_results(ring_ix,6) oh_noagg_results(ring_ix,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Aggregation'; l{2}='Forwarding';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(oh_results(1,1)+oh_results(1,6)) (oh_noagg_results(1,1)+oh_noagg_results(1,6))];
    for ring_ix = 2:num_rings
        y = [y; [(oh_results(ring_ix,1)+oh_results(ring_ix,6)) (oh_noagg_results(ring_ix,1)+oh_noagg_results(ring_ix,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Aggregation'; l{2}='Forwarding';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    suptitle('Energy consumed per STA in OH with/without payload aggregation')
    % linkaxes([ax2,ax1],'xy')
end

% Energy per node
if plot_e_per_node_all
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [sh_results(1,1) nrh_results(1,1) nrh_noagg_results(1,1) oh_results(1,1) oh_noagg_results(1,1)];
    for ring_ix = 2:num_rings
        y = [y; [sh_results(ring_ix,1) nrh_results(ring_ix,1) nrh_noagg_results(ring_ix,1) oh_results(ring_ix,1) oh_noagg_results(ring_ix,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(5));
    grid on
    l = cell(1,5);
    l{1}='Single-hop'; l{2}='Next-ring-hop (agg)';  l{3}='Next-ring-hop'; l{4}='Optimal-hop (agg)'; l{5}='Optimal-hop';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
    ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [sh_results(1,6) nrh_results(1,6) nrh_noagg_results(1,6) oh_results(1,6) oh_noagg_results(1,6)];
    for ring_ix = 2:num_rings
        y = [y; [sh_results(ring_ix,6) nrh_results(ring_ix,6) nrh_noagg_results(ring_ix,6) oh_results(ring_ix,6) oh_noagg_results(ring_ix,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(5));
    grid on
    l = cell(1,5);
    l{1}='Single-hop'; l{2}='Next-ring-hop (agg)';  l{3}='Next-ring-hop'; l{4}='Optimal-hop (agg)'; l{5}='Optimal-hop';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(sh_results(1,1)+sh_results(1,6)) (nrh_results(1,1)+nrh_results(1,6)) (nrh_noagg_results(1,1)+nrh_noagg_results(1,6)) (oh_results(1,1)+oh_results(1,6)) (oh_noagg_results(1,1)+oh_noagg_results(1,6))];
    for ring_ix = 2:num_rings
        y = [y; [(sh_results(ring_ix,1)+sh_results(ring_ix,6)) (nrh_results(ring_ix,1)+nrh_results(ring_ix,6)) (nrh_noagg_results(ring_ix,1)+nrh_noagg_results(ring_ix,6)) (oh_results(ring_ix,1)+oh_results(ring_ix,6)) (oh_noagg_results(ring_ix,1)+oh_noagg_results(ring_ix,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(5));
    grid on
    l = cell(1,5);
    l{1}='Single-hop'; l{2}='Next-ring-hop (agg)';  l{3}='Next-ring-hop'; l{4}='Optimal-hop (agg)'; l{5}='Optimal-hop';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    suptitle('Energy consumption per STA (All routings)')
    % linkaxes([ax2,ax1],'xy')
end

% Energy per node
if plot_e_per_node_single_fair_agg
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [sh_results(1,1)  oh_noagg_results(1,1) oh_results(1,1)]; 
    for ring_ix = 2:num_rings
        y = [y; [sh_results(ring_ix,1)  oh_noagg_results(ring_ix,1) oh_results(ring_ix,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Optimal-hop (no agg)'; l{3}='Optimal-hop (agg)';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
    ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [sh_results(1,6) oh_noagg_results(1,6) oh_results(1,6) ];
    for ring_ix = 2:num_rings
        y = [y; [sh_results(ring_ix,6) oh_noagg_results(ring_ix,6)  oh_results(ring_ix,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Optimal-hop (no agg)'; l{3}='Optimal-hop (agg)';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(sh_results(1,1)+sh_results(1,6)) (oh_noagg_results(1,1)+oh_noagg_results(1,6)) (oh_results(1,1)+oh_results(1,6))];
    for ring_ix = 2:num_rings
        y = [y; [(sh_results(ring_ix,1)+sh_results(ring_ix,6)) (oh_noagg_results(ring_ix,1)+oh_noagg_results(ring_ix,6)) (oh_results(ring_ix,1)+oh_results(ring_ix,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Optimal-hop (no agg)'; l{3}='Optimal-hop (agg)';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    suptitle('Energy consumption per STA (SH vs. OH with/without aggregation)')
    
    % linkaxes([ax2,ax1],'xy')
end


if(plot_e_per_node || plot_network_tx_e || plot_network_total_e || plot_bottlenecks_e)
    disp('- Plots finished!')
end


disp('- Exit successfully!')