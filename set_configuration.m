%%% "Distance-Ring Tree-Topology Network (DRTTN) Framework" project (Oct 2016)
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% File description: Set RNT configuration

% Close open figures and clear variables
clc
clear
close all

%% Main configuration parameters
num_rings = 5;                      % Num of rings
child_ratio = 3;                    % Num of children of STAs not belonging to the last ring
DFS = 65;                           % Minimum packet length (Data Frame Size) [Byte]
p_ratio = 4;                        % Max num of payloads in a DFS
spread_model = 0;                   % Equidistant, fibonacci or reverse fibonnaci (0, 1 or 2)
prop_model = 1;                     % Propagation model (0: Free space, 1: 802.11 Urban macro deployment, 2: 802.11 pico/hotzone)
fibo_stress = 1;                    % First fibonnaci number to consider (0 if usual)
transceiver_model = 1;              % Transceiver model (0: CC1100, 1: CC1200, 2: si4464 (SigFox))

plot_topology = 0;
plot_ring_spread = 1;

%%  Load configuration parameters

disp('Saving RNT configuration...')

% Packets
L_data = 15;        % Data payload length [Byte]
L_header = 2;       % Header length [Byte]
% 
% if (L_data + L_header) > DFS
%     error('Packet lenght greater than DFS! Check L_data, L_header and DFS parameters')
% end
% p_ratio = floor ((DFS - L_header) / L_data);    % Max num of payloads in a DFS

% Packet/Bit error rates
% PER=0.1;                        % Packet error rate
% BER=1-(1-PER)^(1/(DFS*8));      % Bit error rate

% PHY layer and propagation
if prop_model == 0
    prop_model_str = 'Free space';
elseif prop_model == 1
    prop_model_str = '802.11 Urban macro deployment';
elseif prop_model == 2
    prop_model_str = '802.11 Pico/hotzone deployment';
else
    error('Propagation model unknown!');
end
f = 868e6;                          % Propoagation frequency [Hz]
c = 3e8;                            % Speed of light [m/s]
lambda = c/f;                       % Propagation wavelength [m]
Gtx = 0;                            % Transmitter gain [dB]          
Grx = 30;                            % Receiver gain [dB]  
No = -200.93;                         % Noise power density

%% TRANSCEIVER HARDWARE 
if transceiver_model == 0
    transceiver_model_str = 'CC1100';
elseif transceiver_model == 1
    transceiver_model_str = 'CC1200';
elseif transceiver_model == 2
    transceiver_model_str = 'si4464 (SigFox)';
elseif transceiver_model == 3
    transceiver_model_str = 'SX1272/73 (LoRa)';
else
    error('Transceiver model unknown!');
end

V = 3;      % STAs nominal voltage [V]
% R_LVL=[300e3 600e3 900e3 1200e3 1800e3 2400e3 2700e3 3000e3 3600e3 4000e3];             % TX rates [bps] (802.11 ah)
if transceiver_model == 0   % CC1100
    P_LVL = [10 7 5 0 -5 -10 -15 -20 -30];  % STAs TX output power at 868 MHz [dBm]
    I_LVL = [31.1 25.8 20.0 16.9 14.1 14.5 13.0 12.4 11.9]; % STAs TX current [mA]
    I_rx = 14.4;    % STAs RX current [mA]
    R_LVL = [1.2e3 38.4e3 250e3 500e3]; % Rate levels [bps]
    S = [-110 -103 -93 -88];   % Sensitivity [dBm] for each rate level
elseif transceiver_model == 1   % CC1200
    P_LVL = [14.0 12.0 10.0 9.0 7.5 5.0 4.0 2.0 0.0 -1.5 -3.0 -5 -6.5 -8.0 -10.0 -11.5];    % STAs TX output power at 868 MHz [dBm]
    I_LVL = [45.0 42.0 34.0 33.5 31 29 27 26 25 24 23 22.5 22 21.7 21.5 21];    % STAs TX current [mA]
    I_rx = 19;  % STAs RX current [mA]
    R_LVL = [1.2e3 4.8e3 38.4e3 50e3 100e3 500e3 1000e3];   % Rate levels [bps]
    S = [-122 -113 -110 -109 -107 -97 -97];   % Sensitivity [dBm] for each rate level
elseif transceiver_model == 2   % SigFox
    P_LVL = [20 16 14 13 10];   % STAs TX output power at 868 MHz [dBm]
    I_LVL = [85 43 37 29 18]; % STAs TX current [mA]
    I_rx = 10.7;    % STAs RX current [mA]
    R_LVL = [500 40e3 100e3 125e3 500e3 1000e3];    % Rate levels [bps]
    S = [-126 -110 -106 -105 -97 -88];   % Sensitivity [dBm] for each rate level
elseif transceiver_model == 3   % LoRa
    P_LVL = [20 17 13 7];   % STAs TX output power at 868 MHz [dBm]
    I_LVL = [125 90 28 18]; % STAs TX current [mA]
    I_rx = 10.5;    % STAs RX current [mA]
    R_LVL = [293 586 1172 9380 18750 3750 38.4e3 250e3];    % Rate levels [bps]
    S = [-137 -134 -131 -122 -119 -116 -110 -97];   % Sensitivity [dBm] for each rate level
else
    error('ERROR. transceiver_model unkown!')
end

GW_Ptx = P_LVL(1);  % Gateway TX output power [dBm]
Grx = 3;            % Receiver gain [dBi]
Gtx = 0;            % Transmitter gaint [dBi]


% Topology (generate topology fixing number of rings, child ratio and max distance)
d_max = max_distance(prop_model, GW_Ptx, Grx, Gtx, S(1), f) % GW max distance (with max TX power and min TX rate)
br = 1;                             % Num of branches
n = child_ratio.^((1:num_rings)-1); % Num of nodes in each ring in each branch
n_total = sum(n) * br;              % Total num of nodes in the network
n
n_total

% Plot topology
if plot_topology == 1
figure
A = zeros(n_total,n_total); % Adjacency matrix
ring_aux = 0;
ring_offset = 0;
ring_old= 0;
for i = 1:n_total
    % Get ring
    for k = 1:num_rings
        if i <= sum(n(1:k))
            ring_aux = k;
            if ring_aux ~= ring_old
                ring_offset  = 0;
                ring_old = ring_aux;
            end
            break
        end
    end
    if(ring_aux<num_rings)
        for j = 1:child_ratio
            A(i,i+(j-1)+child_ratio^(ring_aux-1)+ring_offset) = 1;
            A(i+(j-1)+child_ratio^(ring_aux-1)+ring_offset,i) = 1;
        end
        ring_offset = ring_offset + (child_ratio-1);
    else
        break
    end
end
G = graph(A);
plot(G, 'black')
title('Branch topology')
axis off
dim = [.8 .55 .3 .3];
str = ['# of rings: ' num2str(num_rings)];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [.8 .45 .3 .3];
str = ['child ratio: ' num2str(child_ratio)];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

figure
plot(G, 'black')
end

if spread_model == 0
    spread_model_str = 'Equidistant';
elseif spread_model == 1
    spread_model_str = 'Fibonacci';
elseif spread_model == 2
    spread_model_str = 'Inverse Fibonacci';
else
    error('Spread model unknown!');
end
d_ring = spread_rings(spread_model, fibo_stress, num_rings, d_max);   % Distance between each ring and the GW

% Plot ring spreading per each model
if plot_ring_spread == 1
    figure
    d_ring_plot = spread_rings(0, fibo_stress, num_rings, d_max);   % Distance between each ring and the GW
    plot([0 d_ring_plot], '-*')
    hold on
    d_ring_plot = spread_rings(1, fibo_stress, num_rings, d_max);
    plot([0 d_ring_plot], '-*')
    hold on
    d_ring_plot = spread_rings(2, fibo_stress, num_rings, d_max);
    plot([0 d_ring_plot], '-*')
    hold on
    xlabel('r')
    ylabel('d [m]')
    ylim([0 d_max])
    grid on
    legend('Equidistant', 'Fibonacci', 'R-Fibonacci')
end

d_max
[num_delta_combinations, delta_combinations] = get_all_ring_hops(num_rings);  % Number and set of every possible combination of ring hops

% Save configuration parameters as global variables to be used by other
% scripts (NOTE: mind the name repetition of variables!)
save('configuration.mat')
disp('Configuration saved!')