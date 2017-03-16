%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% File description: Main script for running DRESG analyses

% Close open figures and clear variables
clc
clear
close all

%%  Load DRESG configuration parameters
% NOTE: run 'set_configuration.m' script to generate the configuration .mat file
load('configuration.mat')
info_on = 1;    % Print DRESG configuration? (0: No, 1: Yes)
if info_on == 1
    disp('*************************');
    disp('*** DRESG CONFIGURATION ***');
    disp('*************************');
    disp('Physical parameters:');
    disp(['- Propagation model: ' prop_model_str]);
    disp(['- frequency =  ' num2str(f/(10^6)) ' MHz  (lambda = ' num2str(lambda) ' m)']);
    disp(['- TX power output: Pt_{min} =  ' num2str(min(P_LVL)) ' dBm  Pt_{max} = ' num2str(max(P_LVL)) ' dBm']);
    disp(['- No = ' num2str(No) ' dBm']);
    disp(['- max. distance =  ' num2str(d_max) ' m']);
    disp('Hardware paremeters:');
    disp(['- Transceiver model:  ' transceiver_model_str]);
    disp('Network parameters:');
    disp(['- packet length =  ' num2str(L_data) ' B']);
    disp(['- header length =  ' num2str(L_header) ' B']);
    disp(['- DFS =  ' num2str(DFS) ' B']);
    disp(['- Max. payloads per DFS (payload ratio) =  ' num2str(p_ratio)]);
    disp('Topology:');
    disp(['- child ratio =  ' num2str(child_ratio)]);
    disp(['- number of rings =  ' num2str(num_rings)]);
    disp(['- ring spreading model:  ' spread_model_str]);
    disp(['- number of branches =  ' num2str(br)]);
    disp(['- number of nodes =  ' num2str(n_total)]);
    for i=1:num_rings
        disp(['  * ring ' num2str(i) ': n = ' num2str(n(i)  * br) '  d = ' num2str(d_ring(i)) ' m']);
    end
    disp(' ')
end



%% ROUTING MODES RESULTS

% Get optimal configuration for each ring
single_results = zeros(num_rings, 8);
multi_results = zeros(num_rings, 8);
multi_results_no_agg = zeros(num_rings, 8);

disp('Obtaining single-hop and multi-hop optimal configurations...')
disp('- progress: 0%')

for i = 1:num_rings
    
    % Single-hop
    routing_mode = 0;
    [E_tx, P_opt, ix_P, r_opt, ix_R, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] = single_multi_optimal_tx_conf(routing_mode, num_rings-i+1, 0);
    single_results(num_rings-i+1,1) = E_tx;
    single_results(num_rings-i+1,2) = P_opt;
    single_results(num_rings-i+1,3) = ix_P;
    single_results(num_rings-i+1,4) = r_opt;
    single_results(num_rings-i+1,5) = ix_R;
    single_results(num_rings-i+1,6) = E_rx;
    single_results(num_rings-i+1,7) = ring_load;
    single_results(num_rings-i+1,8) = max_ring_load;
    single_results(num_rings-i+1,9) = dfs_ring_load;
    single_results(num_rings-i+1,10) = ring_dest;
    
    % Multi-hop
    routing_mode = 1;
    [E_tx, P_opt, ix_P, r_opt, ix_R, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] = single_multi_optimal_tx_conf(routing_mode, num_rings-i+1, 1);
    multi_results(num_rings-i+1,1) = E_tx;
    multi_results(num_rings-i+1,2) = P_opt;
    multi_results(num_rings-i+1,3) = ix_P;
    multi_results(num_rings-i+1,4) = r_opt;
    multi_results(num_rings-i+1,5) = ix_R;
    multi_results(num_rings-i+1,6) = E_rx;
    multi_results(num_rings-i+1,7) = ring_load;
    multi_results(num_rings-i+1,8) = max_ring_load;
    multi_results(num_rings-i+1,9) = dfs_ring_load;
    multi_results(num_rings-i+1,10) = ring_dest;
    
    % Multi-hop without aggregation
    routing_mode = 1;
    [E_tx, P_opt, ix_P, r_opt, ix_R, E_rx, ring_load, max_ring_load, dfs_ring_load, ring_dest] = single_multi_optimal_tx_conf(routing_mode, num_rings-i+1, 0);
    multi_results_no_agg(num_rings-i+1,1) = E_tx;
    multi_results_no_agg(num_rings-i+1,2) = P_opt;
    multi_results_no_agg(num_rings-i+1,3) = ix_P;
    multi_results_no_agg(num_rings-i+1,4) = r_opt;
    multi_results_no_agg(num_rings-i+1,5) = ix_R;
    multi_results_no_agg(num_rings-i+1,6) = E_rx;
    multi_results_no_agg(num_rings-i+1,7) = ring_load;
    multi_results_no_agg(num_rings-i+1,8) = max_ring_load;
    multi_results_no_agg(num_rings-i+1,9) = dfs_ring_load;
    multi_results_no_agg(num_rings-i+1,10) = ring_dest;
    
    if(i == num_rings)
        disp('- progress: 100 % completed!')
    else
        disp(['- progress: ' num2str(ceil(i*100 / num_rings)) '%'])
    end
end

% fair-hop
disp('Obtaining fair-hop routing and optimal configurations...')
[fair_results, optimal_diverse_delta_conf ] = fair_optimal_tx_conf(1);
[fair_results_no_agg, optimal_diverse_delta_conf_no_agg ] = fair_optimal_tx_conf(0);

% Bottlenecks
[single_bottle_e, single_bottle_ix] = max(single_results(:,1) + single_results(:,6));
[multi_bottle_e, multi_bottle_ix] = max(multi_results(:,1) + multi_results(:,6));
[multi_no_agg_bottle_e, multi_no_agg_bottle_ix] = max(multi_results_no_agg(:,1) + multi_results_no_agg(:,6));
[fair_bottle_e, fair_bottle_ix] = max(fair_results(:,1) + fair_results(:,6));
[fair_bottle_e_no_agg, fair_bottle_ix_no_agg] = max(fair_results_no_agg(:,1) + fair_results_no_agg(:,6));


%% DISPLAY RESULTS

% Flags for displaying routing modes results
display_single = 1;
display_multi = 1;
display_multi_no_agg = 0;
display_fair = 1;
display_fair_no_agg = 1;

if (display_single + display_multi + display_multi_no_agg + display_fair + display_fair_no_agg >= 1)
    disp(' ')
    disp('************************************');
    disp('***** ROUTING MODES ANALYSIS *******');
    disp('************************************');
end

% Single
if display_single == 1
    disp(' ');
    disp('----------');
    disp('SINGLE-HOP');
    disp('----------');
    for i = 1:num_rings
        disp(['Ring ' num2str(i) ' (d = ' num2str(d_ring(i)) ' m): ']);
        disp(['- Destination ring: ' num2str(single_results(i,10))]);
        disp(['- Payloads per node (DFSs): ' num2str(single_results(i,7)) ' (' num2str(single_results(i,9)) ')']);
        disp(['- Max. payloads per node (DFSs): ' num2str(single_results(i,8)) ' (' num2str(get_num_dfs(single_results(i,8),p_ratio)) ')']);
        disp(['- Configuration: P_opt = ' num2str(single_results(i,2)) ' dBm (level ' num2str(single_results(i,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(single_results(i,4) / 1000) ' Kbps (level ' num2str(single_results(i,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['- Energy cons.: E_tx = ' num2str(single_results(i,1) * 1000) ' uJ - E_rx = ' num2str(single_results(i,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('Summary:')
    disp(['- Bottleneck ring: ' num2str(single_bottle_ix) ' (' num2str(single_bottle_e * 1000) ' uJ)']);
    disp(['- Overall energy cons.: ' num2str(sum((single_results(:,1)+single_results(:,6))'.* n)) ' mJ']);
end

% Multi
if display_multi == 1
    disp(' ');
    disp('---------');
    disp('MULTI-HOP');
    disp('---------');
    for i = 1:num_rings
        disp(['Ring ' num2str(i) ' (d = ' num2str(d_ring(i)) ' m): ']);
        disp(['- Destination ring: ' num2str(multi_results(i,10))]);
        disp(['- Payloads per node (DFSs): ' num2str(multi_results(i,7)) ' (' num2str(multi_results(i,9)) ')']);
        disp(['- Max. payloads per node (DFSs): ' num2str(multi_results(i,8)) ' (' num2str(get_num_dfs(multi_results(i,8),p_ratio)) ')']);
        disp(['- Configuration: P_opt = ' num2str(multi_results(i,2)) ' dBm (level ' num2str(multi_results(i,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(multi_results(i,4) / 1000) ' Kbps (level ' num2str(multi_results(i,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['- Energy cons.: E_tx = ' num2str(multi_results(i,1) * 1000) ' uJ - E_rx = ' num2str(multi_results(i,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('Summary:')
    disp(['- Bottleneck ring: ' num2str(multi_bottle_ix) ' (' num2str(multi_bottle_e * 1000) ' uJ)']);
    disp(['- Overall energy cons.: ' num2str(sum((multi_results(:,1)+multi_results(:,6))'.* n)) ' mJ']);
end

% Multi without aggregation
if display_multi_no_agg == 1
    disp(' ');
    disp('---------');
    disp('MULTI-HOP (WITHOUT AGGREGATION)');
    disp('---------');
    for i = 1:num_rings
        disp(['Ring ' num2str(i) ' (d = ' num2str(d_ring(i)) ' m): ']);
        disp(['- Destination ring: ' num2str(multi_results_no_agg(i,10))]);
        disp(['- Payloads per node (DFSs): ' num2str(multi_results_no_agg(i,7)) ' (' num2str(multi_results_no_agg(i,9)) ')']);
        disp(['- Max. payloads per node (DFSs): ' num2str(multi_results_no_agg(i,8)) ' (' num2str(get_num_dfs(multi_results_no_agg(i,8),p_ratio)) ')']);
        disp(['- Configuration: P_opt = ' num2str(multi_results_no_agg(i,2)) ' dBm (level ' num2str(multi_results_no_agg(i,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(multi_results_no_agg(i,4) / 1000) ' Kbps (level ' num2str(multi_results_no_agg(i,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['- Energy cons.: E_tx = ' num2str(multi_results_no_agg(i,1) * 1000) ' uJ - E_rx = ' num2str(multi_results_no_agg(i,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('Summary:')
    disp(['- Bottleneck ring: ' num2str(multi_no_agg_bottle_ix) ' (' num2str(multi_no_agg_bottle_e * 1000) ' uJ)']);
    disp(['- Overall energy cons.: ' num2str(sum((multi_results_no_agg(:,1)+multi_results_no_agg(:,6))'.* n)) ' mJ']);
end

if display_fair == 1
    % Fair-hop
    disp(' ');
    disp('------------------');
    disp('FAIR-HOP');
    disp('------------------');
    disp(['Optimal delta configuration: ' num2str(optimal_diverse_delta_conf)]);
    for i = 1:num_rings
        disp(['Ring ' num2str(i) ' (d = ' num2str(d_ring(i)) ' m): ']);
        disp(['- Destination ring: ' num2str(fair_results(i,10))]);
        disp(['- Payloads per node (DFSs): ' num2str(fair_results(i,7)) ' (' num2str(fair_results(i,9)) ')']);
        disp(['- Max. payloads per node (DFSs): ' num2str(fair_results(i,8)) ' (' num2str(get_num_dfs(fair_results(i,8),p_ratio)) ')']);
        disp(['- Configuration: P_opt = ' num2str(fair_results(i,2)) ' dBm (level ' num2str(fair_results(i,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(fair_results(i,4) / 1000) ' Kbps (level ' num2str(fair_results(i,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['- Energy cons.: E_tx = ' num2str(fair_results(i,1) * 1000) ' uJ - E_rx = ' num2str(fair_results(i,6) * 1000) ' uJ']);
        disp(['- DFSs received: ' num2str(fair_results(i,11))]);
    end
    disp(' ');
    disp('Summary:')
    disp(['- Bottleneck ring: ' num2str(fair_bottle_ix) ' (' num2str(fair_bottle_e * 1000) ' uJ)']);
    disp(['- Overall energy cons.: ' num2str(sum((fair_results(:,1)+fair_results(:,6))'.* n)) ' mJ']);
end

if display_fair_no_agg == 1
    % Fair-hop without aggregation
    disp(' ');
    disp('------------------');
    disp('FAIR-HOP (WITHOUT AGGREGATION)');
    disp('------------------');
    disp(['Optimal delta configuration: ' num2str(optimal_diverse_delta_conf_no_agg)]);
    for i = 1:num_rings
        disp(['Ring ' num2str(i) ' (d = ' num2str(d_ring(i)) ' m): ']);
        disp(['- Destination ring: ' num2str(fair_results_no_agg(i,10))]);
        disp(['- Payloads per node (DFSs): ' num2str(fair_results_no_agg(i,7)) ' (' num2str(fair_results_no_agg(i,9)) ')']);
        disp(['- Max. payloads per node (DFSs): ' num2str(fair_results_no_agg(i,8)) ' (' num2str(get_num_dfs(fair_results_no_agg(i,8),p_ratio)) ')']);
        disp(['- Configuration: P_opt = ' num2str(fair_results_no_agg(i,2)) ' dBm (level ' num2str(fair_results_no_agg(i,3)) '/' num2str(length(P_LVL)) ') - r_opt = ' num2str(fair_results_no_agg(i,4) / 1000) ' Kbps (level ' num2str(fair_results_no_agg(i,5)) '/' num2str(length(R_LVL)) ')']);
        disp(['- Energy cons.: E_tx = ' num2str(fair_results_no_agg(i,1) * 1000) ' uJ - E_rx = ' num2str(fair_results_no_agg(i,6) * 1000) ' uJ']);
    end
    disp(' ');
    disp('Summary:')
    disp(['- Bottleneck ring: ' num2str(fair_bottle_ix_no_agg) ' (' num2str(fair_bottle_e_no_agg * 1000) ' uJ)']);
    disp(['- Overall energy cons.: ' num2str(sum((fair_results_no_agg(:,1)+fair_results_no_agg(:,6))'.* n)) ' mJ']);
end

disp(' ');
disp(' ');
disp('*********************************');
disp('All configurations were computed!')
disp('*********************************');


%% PLOTS

% Flags for ploting

% Routing modes energy consumption
plot_e_per_node = 1;
plot_network_tx_e = 0;
plot_network_total_e = 1;
plot_bottlenecks_e = 0;
% Aggregation vs no aggregation
plot_e_per_node_multi_aggregation = 0;
plot_e_per_node_fair_aggregation = 0;
% All routings (with/out aggregation)
plot_e_per_node_all = 0;
plot_e_per_node_single_fair_agg = 1;

if(plot_e_per_node + plot_network_tx_e + plot_network_total_e + plot_bottlenecks_e + plot_e_per_node_multi_aggregation + plot_e_per_node_fair_aggregation + plot_e_per_node_all >= 1)
    disp(' ')
    disp('Plotting...')
end
% Energy per node
if plot_e_per_node == 1
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [single_results(1,1) multi_results(1,1) fair_results(1,1)];
    for i = 2:num_rings
        y = [y; [single_results(i,1) multi_results(i,1) fair_results(i,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Multi-hop';  l{3}='Fair-hop';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
    ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [single_results(1,6) multi_results(1,6) fair_results(1,6)];
    for i = 2:num_rings
        y = [y; [single_results(i,6) multi_results(i,6) fair_results(i,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Multi-hop';  l{3}='Fair-hop';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(single_results(1,1)+single_results(1,6)) (multi_results(1,1)+multi_results(1,6)) (fair_results(1,1)+fair_results(1,6))];
    for i = 2:num_rings
        y = [y; [(single_results(i,1)+single_results(i,6)) (multi_results(i,1)+multi_results(i,6)) (fair_results(i,1)+fair_results(i,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Multi-hop';  l{3}='Fair-hop';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    % linkaxes([ax2,ax1],'xy')
end

if plot_network_tx_e == 1
    % Network TX energy
    figure
    y = [single_results(:,1)' .* n; multi_results(:,1)' .* n; fair_results(:,1)' .* n];
    B = bar(y,'stacked');
    set(gca, 'XTick',1:3, 'XTickLabel',{'Single-hop' 'Multi-hop' 'Fair-hop'})
    % title('Network TX energy comparison')
    ylabel('e_{tx} [mJ]')
    legend_str = [];
    for i=1:num_rings
        aux_str = strcat('ring ', num2str(i));
        legend_str{end+1} = aux_str;
    end
    AX1=legend(B, legend_str, 'location', 'northwest','FontSize',8);
end

if plot_network_total_e == 1
    % Network total energy
    figure
    y = [(single_results(:,1)+single_results(:,6))' .* n; (multi_results(:,1)+multi_results(:,6))'.* n; (fair_results(:,1)+fair_results(:,6))'.* n];
    y_casCAS = y;
    B = bar(y,'stacked');
    set(gca, 'XTick',1:3, 'XTickLabel',{'Single-hop' 'Multi-hop' 'Fair-hop'})
    % title('Network total energy comparison')
    ylabel('e_{t} [mJ]')
    legend_str = [];
    for i=1:num_rings
        aux_str = strcat('r = ', num2str(i));
        legend_str{end+1} = aux_str;
    end
    grid on
    AX2=legend(B, legend_str, 'location', 'northeast','FontSize',8);
end

if plot_bottlenecks_e == 1
    % Bottlenecks
    figure
    y = [single_bottle_e multi_bottle_e fair_bottle_e; single_results(single_bottle_ix,1) multi_results(multi_bottle_ix,1) fair_results(fair_bottle_ix,1); single_results(single_bottle_ix,6) multi_results(multi_bottle_ix,6) fair_results(fair_bottle_ix,6)];
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}=(['Single-hop: ' num2str(single_bottle_ix)]); l{2}=['Multi-hop: ' num2str(multi_bottle_ix)]; l{3}=['Fair-hop: ' num2str(fair_bottle_ix)];
    legend(h_total_node,l);
    % title('Bottleneck energy consumption')
    set(gca,'XTickLabel',{'Total', 'TX', 'RX'})
    ylabel('e [mJ]')
end
disp(['Fair-hop bottleneck improvement against single / multi: ' num2str(single_bottle_e/fair_bottle_e) ' ' num2str(multi_bottle_e/fair_bottle_e)])

if plot_e_per_node_multi_aggregation == 1
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [multi_results(1,1) multi_results_no_agg(1,1)];
    for i = 2:num_rings
        y = [y; [multi_results(i,1) multi_results_no_agg(i,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Multi-hop (agg)'; l{2}='Multi-hop';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
     ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [multi_results(1,6) multi_results_no_agg(1,6)];
    for i = 2:num_rings
        y = [y; [multi_results(i,6) multi_results_no_agg(i,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Multi-hop (agg)'; l{2}='Multi-hop';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(multi_results(1,1)+multi_results(1,6)) (multi_results_no_agg(1,1)+multi_results_no_agg(1,6))];
    for i = 2:num_rings
        y = [y; [(multi_results(i,1)+multi_results(i,6)) (multi_results_no_agg(i,1)+multi_results_no_agg(i,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(2));
    grid on
    l = cell(1,2);
    l{1}='Multi-hop (agg)'; l{2}='Multi-hop';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    % linkaxes([ax2,ax1],'xy')
end

if plot_e_per_node_fair_aggregation == 1
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [fair_results(1,1) fair_results_no_agg(1,1)];
    for i = 2:num_rings
        y = [y; [fair_results(i,1) fair_results_no_agg(i,1)]];
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
    y = [fair_results(1,6) fair_results_no_agg(1,6)];
    for i = 2:num_rings
        y = [y; [fair_results(i,6) fair_results_no_agg(i,6)]];
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
    y = [(fair_results(1,1)+fair_results(1,6)) (fair_results_no_agg(1,1)+fair_results_no_agg(1,6))];
    for i = 2:num_rings
        y = [y; [(fair_results(i,1)+fair_results(i,6)) (fair_results_no_agg(i,1)+fair_results_no_agg(i,6))]];
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
    % linkaxes([ax2,ax1],'xy')
end

disp(['Fair-hop bottleneck improvement against no aggregation: ' num2str(fair_bottle_e_no_agg/fair_bottle_e)])


% Energy per node
if plot_e_per_node_all == 1
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [single_results(1,1) multi_results(1,1) multi_results_no_agg(1,1) fair_results(1,1) fair_results_no_agg(1,1)];
    for i = 2:num_rings
        y = [y; [single_results(i,1) multi_results(i,1) multi_results_no_agg(i,1) fair_results(i,1) fair_results_no_agg(i,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(5));
    grid on
    l = cell(1,5);
    l{1}='Single-hop'; l{2}='Multi-hop (agg)';  l{3}='Multi-hop'; l{4}='Fair-hop (agg)'; l{5}='Fair-hop';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
    ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [single_results(1,6) multi_results(1,6) multi_results_no_agg(1,6) fair_results(1,6) fair_results_no_agg(1,6)];
    for i = 2:num_rings
        y = [y; [single_results(i,6) multi_results(i,6) multi_results_no_agg(i,6) fair_results(i,6) fair_results_no_agg(i,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(5));
    grid on
    l = cell(1,5);
    l{1}='Single-hop'; l{2}='Multi-hop (agg)';  l{3}='Multi-hop'; l{4}='Fair-hop (agg)'; l{5}='Fair-hop';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(single_results(1,1)+single_results(1,6)) (multi_results(1,1)+multi_results(1,6)) (multi_results_no_agg(1,1)+multi_results_no_agg(1,6)) (fair_results(1,1)+fair_results(1,6)) (fair_results_no_agg(1,1)+fair_results_no_agg(1,6))];
    for i = 2:num_rings
        y = [y; [(single_results(i,1)+single_results(i,6)) (multi_results(i,1)+multi_results(i,6)) (multi_results_no_agg(i,1)+multi_results_no_agg(i,6)) (fair_results(i,1)+fair_results(i,6)) (fair_results_no_agg(i,1)+fair_results_no_agg(i,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(5));
    grid on
    l = cell(1,5);
    l{1}='Single-hop'; l{2}='Multi-hop (agg)';  l{3}='Multi-hop'; l{4}='Fair-hop (agg)'; l{5}='Fair-hop';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    % linkaxes([ax2,ax1],'xy')
end

% Energy per node
if plot_e_per_node_single_fair_agg == 1
    figure
    ax1 = subplot(1,3,1);
    % TX energy per node plot
    y = [single_results(1,1)  fair_results_no_agg(1,1) fair_results(1,1)]; 
    for i = 2:num_rings
        y = [y; [single_results(i,1)  fair_results_no_agg(i,1) fair_results(i,1)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Fair-hop (no agg)'; l{3}='Fair-hop (agg)';
    legend(h_total_node,l);
    % title('TX energy per node')
    xlabel('r')
    ylabel('e_{tx} [mJ]')
    
    ax2 = subplot(1,3,2);
    % RX energy per node plot
    y = [single_results(1,6) fair_results_no_agg(1,6) fair_results(1,6) ];
    for i = 2:num_rings
        y = [y; [single_results(i,6) fair_results_no_agg(i,6)  fair_results(i,6)]];
    end
    h_total_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Fair-hop (no agg)'; l{3}='Fair-hop (agg)';
    legend(h_total_node,l);
    % title('RX energy per node')
    xlabel('r')
    ylabel('e_{rx} [mJ]')
    
    % Total energy per node plot
    ax3 = subplot(1,3,3);
    y = [(single_results(1,1)+single_results(1,6)) (fair_results_no_agg(1,1)+fair_results_no_agg(1,6)) (fair_results(1,1)+fair_results(1,6))];
    for i = 2:num_rings
        y = [y; [(single_results(i,1)+single_results(i,6)) (fair_results_no_agg(i,1)+fair_results_no_agg(i,6)) (fair_results(i,1)+fair_results(i,6))]];
    end
    h_tx_node = bar(y);
    colormap(summer(3));
    grid on
    l = cell(1,3);
    l{1}='Single-hop'; l{2}='Fair-hop (no agg)'; l{3}='Fair-hop (agg)';
    legend(h_tx_node,l);
    % title('Total energy (TX + RX) per node')
    xlabel('r')
    ylabel('e [mJ]')
    
    % linkaxes([ax2,ax1],'xy')
end


if(plot_e_per_node + plot_network_tx_e + plot_network_total_e + plot_bottlenecks_e > 0)
    disp('Plots finished!')
end