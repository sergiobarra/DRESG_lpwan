%%% "Distance-Ring Tree-Topology Network (DRTTN) Framework" project (Oct 2016)
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% File description: other plots plotting

% Close open figures and clear variables
clc
clear
close all

%% Energy consumed in each possible state of RE-mote node [mA] (CC1120)
e_lpm = 1;
e_cpu = 3;
e_sl = 0;
e_id = 22;
e_rx = 22;
e_tx = 45;

figure
e_state = [e_lpm; e_cpu; e_sl; e_id; e_rx; e_tx];

B = bar(e_state,'stacked');
colormap(summer(6));
set(gca, 'XTick',1:6, 'XTickLabel',{'LPM' 'CPU' 'SL' 'ID' 'RX' 'TX'})
% title('Energy consumption in each state')
xlabel('State')
ylabel('I [mA]')
grid on

%% Bottlenecks distance I
equi = [1.8281 0.5616 0.3806];  % Single, multi, fair for Equidistant spreading
fibo = [1.8281 0.5117 0.1903];  % Single, multi, fair for Fibo spreading
r_fibo = [1.8281 0.7613 0.7020];% Single, multi, fair for Fibo spreading
figure 
y = [equi; fibo; r_fibo];
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop ']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'Equdistant', 'Fibonacci', 'R-Fibonacci'})
ylabel('e [uJ]')

%% Bottlenecks distance II
equi = [58500 21342.36 19236.36];  % Single, multi, fair for Equidistant spreading
fibo = [58500 17281.68 1686.36];  % Single, multi, fair for Fibo spreading
r_fibo = [58500 273265.2 58500];% Single, multi, fair for Fibo spreading
figure
y = [equi; fibo; r_fibo];
h_btle = bar(y./1000);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop ']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'Equdistant', 'Fibonacci', 'R-Fibonacci'})
ylabel('e [mJ]')


%% Topology change I
figure 
subplot(1,2,1)
% Bottlenecks children for CC1200 (R = 5)
child1_cc1200 = [344.0367 1];  % Fair improvement vs single and multi
child2_cc1200 = [73.2422 1];	% Fair improvement vs single and multi
child3_cc1200 = [19.084 1];	% Fair improvement vs single and multi
child4_cc1200 = [6.7665 1];        % Fair improvement vs single and multi
child5_cc1200 = [2.994 1];        % Fair improvement vs single and multi
child6_cc1200 = [1.5051 1];        % Fair improvement vs single and multi
child7_cc1200 = [1 1.1959];        % Fair improvement vs single and multi
child8_cc1200 = [1 2.001];        % Fair improvement vs single and multi
child9_cc1200 = [1 3.15];        % Fair improvement vs single and multi
child10_cc1200 = [1 4.7421];  
y_ch_cc1200 = [child1_cc1200; child2_cc1200; child3_cc1200; child4_cc1200; child5_cc1200; child6_cc1200; child7_cc1200; child8_cc1200; child9_cc1200; child10_cc1200];

% y_ch = y_ch.*100;   % To put it in percentage format

% Bottlenecks ring for CC1200 (c = 3)
subplot(1,2,2)
ring1_cc1200 = [1 1];  % Fair improvement vs single and multi
ring2_cc1200 = [1.8182 1];	% Fair improvement vs single and multi
ring3_cc1200 = [16.6667 1];	% Fair improvement vs single and multi
ring4_cc1200 = [6.9703 1];        % Fair improvement vs single and multi
ring5_cc1200 = [19.084 1];        % Fair improvement vs single and multi
ring6_cc1200 = [7.7145 1];        % Fair improvement vs single and multi
ring7_cc1200 = [3.0411 1.1095];        % Fair improvement vs single and multi
ring8_cc1200 = [1.3144 1.4384];        % Fair improvement vs single and multi
ring9_cc1200 = [1 3.0183];        % Fair improvement vs single and multi
ring10_cc1200 = [1 8.8582];
y_r_cc1200 = [ring1_cc1200; ring2_cc1200; ring3_cc1200; ring4_cc1200; ring5_cc1200; ring6_cc1200; ring7_cc1200; ring8_cc1200; ring9_cc1200; ring10_cc1200];


figure
subplot(1,2,1)
plot(y_ch_cc1200(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_cc1200(:,2), '-o', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('c')
xlim([1 10])
legend('\rho_{SH}', '\rho_{MH}');
grid on

subplot(1,2,2)
plot(y_r_cc1200(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_cc1200(:,2), '-o', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('R')
legend('\rho_{SH}', '\rho_{MH}');
xlim([1 10])
grid on


% Prueba con otros trans
child1_sx1272 = [120.2879 1];  % Fair improvement vs single and multi
child2_sx1272 = [25.9713 1];	% Fair improvement vs single and multi
child3_sx1272 = [6.7617 1];	% Fair improvement vs single and multi
child4_sx1272 = [2.4007 1];        % Fair improvement vs single and multi
child5_sx1272 = [1.2648 1.1915];        % Fair improvement vs single and multi
child6_sx1272 = [1 1.8736];        % Fair improvement vs single and multi
child7_sx1272 = [1 3.3726];        % Fair improvement vs single and multi
child8_sx1272 = [1 5.6426];        % Fair improvement vs single and multi
child9_sx1272 = [1 8.8835];        % Fair improvement vs single and multi
child10_sx1272 = [1 13.3732];
y_ch_sx1272 = [child1_sx1272; child2_sx1272; child3_sx1272; child4_sx1272; child5_sx1272; child6_sx1272; child7_sx1272; child8_sx1272; child9_sx1272; child10_sx1272];

ring1_sx1272 = [1 1];  % Fair improvement vs single and multi
ring2_sx1272 = [4.2017 1];	% Fair improvement vs single and multi
ring3_sx1272 = [7.5291 1];	% Fair improvement vs single and multi
ring4_sx1272 = [9.8564 1];        % Fair improvement vs single and multi
ring5_sx1272 = [6.7617 1];        % Fair improvement vs single and multi
ring6_sx1272 = [2.7808 1.2252];        % Fair improvement vs single and multi
ring7_sx1272 = [1.4715 1.4346];        % Fair improvement vs single and multi
ring8_sx1272 = [1 2.9242];        % Fair improvement vs single and multi
ring9_sx1272 = [1 5.783];        % Fair improvement vs single and multi
ring10_sx1272 = [1 17.3474]; 
y_r_sx1272 = [ring1_sx1272; ring2_sx1272; ring3_sx1272; ring4_sx1272; ring5_sx1272; ring6_sx1272; ring7_sx1272; ring8_sx1272; ring9_sx1272; ring10_sx1272];


figure
subplot(1,2,1)
plot(y_ch_sx1272(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_sx1272(:,2), '-o', 'LineWidth', 2, 'MarkerSize', 8)
p=patch([1 4 4 0],[0 0 1000 1000],'r');
set(p,'FaceAlpha',0.4,'EdgeColor','None');
p=patch([4 4 6 6],[0 1000 1000 0],'g');
set(p,'FaceAlpha',0.4,'EdgeColor','None');
p=patch([6 6 10 10],[0 1000 1000 0],'y');
set(p,'FaceAlpha',0.4,'EdgeColor','None');
xlabel('c')
xlim([1 10])
ylim([0 1000])
legend('\rho_{SH}', '\rho_{MH}');
grid on

subplot(1,2,2)
plot(y_r_sx1272(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_sx1272(:,2), '-o', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('R')
legend('\rho_{SH}', '\rho_{MH}');
p=patch([1 6 6 0],[0 0 20 20],'r');
set(p,'FaceAlpha',0.4,'EdgeColor','None');
p=patch([6 6 8 8],[0 20 20 0],'g');
set(p,'FaceAlpha',0.4,'EdgeColor','None');
p=patch([8 8 10 10],[0 20 20 0],'y');
set(p,'FaceAlpha',0.4,'EdgeColor','None');
xlim([1 10])
ylim([0 20])
grid on


%% Topology change II (transceivers)

% Bottlenecks children
child1_cc1100 = [8.9 1.0593];  % Fair improvement vs single and multi
child2_cc1100 = [2.225 1.3758];	% Fair improvement vs single and multi
child3_cc1100 = [1.0702 2.5262];	% Fair improvement vs single and multi
child4_cc1100 = [1 6.7184];        % Fair improvement vs single and multi
child5_cc1100 = [1 15.114];        % Fair improvement vs single and multi
child6_cc1100 = [1 30.1029];        % Fair improvement vs single and multi
child7_cc1100 = [1 54.1475];        % Fair improvement vs single and multi
child8_cc1100 = [1 90.6889];        % Fair improvement vs single and multi
y_ch_cc1100 = [child1_cc1100; child2_cc1100; child3_cc1100; child4_cc1100; child5_cc1100; child6_cc1100; child7_cc1100; child8_cc1100];

child1_cc1200 = [19.2111 1.1639];  % Fair improvement vs single and multi
child2_cc1200 = [4.8028 1.4754];	% Fair improvement vs single and multi
child3_cc1200 = [2.3114 2.714];	% Fair improvement vs single and multi
child4_cc1200 = [1.0316 3.4401];        % Fair improvement vs single and multi
child5_cc1200 = [1 7.5102];        % Fair improvement vs single and multi
child6_cc1200 = [1 14.9538];        % Fair improvement vs single and multi
child7_cc1200 = [1 26.9022];        % Fair improvement vs single and multi
child8_cc1200 = [1 45.0475];        % Fair improvement vs single and multi
y_ch_cc1200 = [child1_cc1200; child2_cc1200; child3_cc1200; child4_cc1200; child5_cc1200; child6_cc1200; child7_cc1200; child8_cc1200];

child1_si4464 = [164.042 1];  % Fair improvement vs single and multi
child2_si4464 = [38.8682 1];	% Fair improvement vs single and multi
child3_si4464 = [10.0644 1];	% Fair improvement vs single and multi
child4_si4464 = [3.7824 1.0487];        % Fair improvement vs single and multi
child5_si4464 = [1.6443 1.0359];        % Fair improvement vs single and multi
child6_si4464 = [1 1.2514];        % Fair improvement vs single and multi
child7_si4464 = [1 2.2541];        % Fair improvement vs single and multi
child8_si4464 = [1 3.7676];        % Fair improvement vs single and multi
y_ch_si4464 = [child1_si4464; child2_si4464; child3_si4464; child4_si4464; child5_si4464; child6_si4464; child7_si4464; child8_si4464];

% Bottlenecks ring
ring1_cc1100 = [1 1];  % Fair improvement vs single and multi
ring2_cc1100 = [3.3802 1];	% Fair improvement vs single and multi
ring3_cc1100 = [4.45 1];	% Fair improvement vs single and multi
ring4_cc1100 = [2.9429 1];        % Fair improvement vs single and multi
ring5_cc1100 = [2.225 1.3758];        % Fair improvement vs single and multi
ring6_cc1100 = [1.7343 2.1448];        % Fair improvement vs single and multi
ring7_cc1100 = [1.0862 2.4464];        % Fair improvement vs single and multi
ring8_cc1100 = [1 4.5043];        % Fair improvement vs single and multi
y_r_cc1100 = [ring1_cc1100; ring2_cc1100; ring3_cc1100; ring4_cc1100; ring5_cc1100; ring6_cc1100; ring7_cc1100; ring8_cc1100];

ring1_cc1200 = [1 1];  % Fair improvement vs single and multi
ring2_cc1200 = [1.6984 1];	% Fair improvement vs single and multi
ring3_cc1200 = [11.1607 1];	% Fair improvement vs single and multi
ring4_cc1200 = [6.1035 1];        % Fair improvement vs single and multi
ring5_cc1200 = [4.8028 1.4754];        % Fair improvement vs single and multi
ring6_cc1200 = [3.3198 1.949];        % Fair improvement vs single and multi
ring7_cc1200 = [3.1758 3.6423];        % Fair improvement vs single and multi
ring8_cc1200 = [1.881 4.2119];        % Fair improvement vs single and multi
y_r_cc1200 = [ring1_cc1200; ring2_cc1200; ring3_cc1200; ring4_cc1200; ring5_cc1200; ring6_cc1200; ring7_cc1200; ring8_cc1200];

ring1_si4464 = [1 1];  % Fair improvement vs single and multi
ring2_si4464 = [2.551 1];	% Fair improvement vs single and multi
ring3_si4464 = [36.9004 1];	% Fair improvement vs single and multi
ring4_si4464 = [57.6568 1];        % Fair improvement vs single and multi
ring5_si4464 = [38.8682 1];        % Fair improvement vs single and multi
ring6_si4464 = [57.6568 1];        % Fair improvement vs single and multi
ring7_si4464 = [29.976 1.0398];        % Fair improvement vs single and multi
ring8_si4464 = [21.7865 1.121];        % Fair improvement vs single and multi
y_r_si4464 = [ring1_si4464; ring2_si4464; ring3_si4464; ring4_si4464; ring5_si4464; ring6_si4464; ring7_si4464; ring8_si4464];

figure
subplot(1,2,1)
plot(y_ch_cc1100(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_cc1200(:,1), '-o', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_si4464(:,1), '-o', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('c')
xlim([1 8])
legend('\rho_{SH}^{cc1100}', '\rho_{SH}^{cc1200}', '\rho_{SH}^{Si4464}');
grid on

subplot(1,2,2)
plot(y_r_cc1100(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_cc1200(:,1), '-o', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_si4464(:,1), '-o', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('R')
xlim([1 8])
legend('\rho_{SH}^{cc1100}', '\rho_{SH}^{cc1200}', '\rho_{SH}^{Si4464}');
grid on

%% Topology change III (transceivers)

% Bottlenecks children (num rings set to 5)
child1_cc1100 = [196.3384 1];  % Fair improvement vs single and multi
child2_cc1100 = [40.2933 1];	% Fair improvement vs single and multi
child3_cc1100 = [10.5198 1];	% Fair improvement vs single and multi
child4_cc1100 = [5.0919 1.3698];        % Fair improvement vs single and multi
child5_cc1100 = [3.8298 2.3244];        % Fair improvement vs single and multi
child6_cc1100 = [2.8005 3.3826];        % Fair improvement vs single and multi
child7_cc1100 = [2.0648 4.488];        % Fair improvement vs single and multi
child8_cc1100 = [1.6118 5.8642];        % Fair improvement vs single and multi
child9_cc1100 = [1.3356 7.6469];        % Fair improvement vs single and multi
child10_cc1100 = [1.1009 9.4902];        % Fair improvement vs single and multi
y_ch_cc1100 = [child1_cc1100; child2_cc1100; child3_cc1100; child4_cc1100; child5_cc1100; child6_cc1100; child7_cc1100; child8_cc1100; child9_cc1100; child10_cc1100];

child1_cc1200 = [344.0367 1];  % Fair improvement vs single and multi
child2_cc1200 = [73.2422 1];	% Fair improvement vs single and multi
child3_cc1200 = [19.084 1];	% Fair improvement vs single and multi
child4_cc1200 = [6.7665 1];        % Fair improvement vs single and multi
child5_cc1200 = [2.994 1];        % Fair improvement vs single and multi
child6_cc1200 = [1.5051 1];        % Fair improvement vs single and multi
child7_cc1200 = [1 1.1959];        % Fair improvement vs single and multi
child8_cc1200 = [1 2.001];        % Fair improvement vs single and multi
child9_cc1200 = [1 3.15];        % Fair improvement vs single and multi
child10_cc1200 = [1 4.7421];  
y_ch_cc1200 = [child1_cc1200; child2_cc1200; child3_cc1200; child4_cc1200; child5_cc1200; child6_cc1200; child7_cc1200; child8_cc1200; child9_cc1200; child10_cc1200];

child1_si4464 = [219.7518 1];  % Fair improvement vs single and multi
child2_si4464 = [49.4646 1];	% Fair improvement vs single and multi
child3_si4464 = [12.8476 1];	% Fair improvement vs single and multi
child4_si4464 = [4.5801 1];        % Fair improvement vs single and multi
child5_si4464 = [2.021 1];        % Fair improvement vs single and multi
child6_si4464 = [1.0167 1];        % Fair improvement vs single and multi
child7_si4464 = [1 1.771];        % Fair improvement vs single and multi
child8_si4464 = [1 2.9617];        % Fair improvement vs single and multi
child9_si4464 = [1 4.6644];        % Fair improvement vs single and multi
child10_si4464 = [1 7.0212];
y_ch_si4464 = [child1_si4464; child2_si4464; child3_si4464; child4_si4464; child5_si4464; child6_si4464; child7_si4464; child8_si4464; child9_si4464; child10_si4464];

child1_sx1272 = [120.2879 1];  % Fair improvement vs single and multi
child2_sx1272 = [25.9713 1];	% Fair improvement vs single and multi
child3_sx1272 = [6.7617 1];	% Fair improvement vs single and multi
child4_sx1272 = [2.4007 1];        % Fair improvement vs single and multi
child5_sx1272 = [1.2648 1.1915];        % Fair improvement vs single and multi
child6_sx1272 = [1 1.8736];        % Fair improvement vs single and multi
child7_sx1272 = [1 3.3726];        % Fair improvement vs single and multi
child8_sx1272 = [1 5.6426];        % Fair improvement vs single and multi
child9_sx1272 = [1 8.8835];        % Fair improvement vs single and multi
child10_sx1272 = [1 13.3732];
y_ch_sx1272 = [child1_sx1272; child2_sx1272; child3_sx1272; child4_sx1272; child5_sx1272; child6_sx1272; child7_sx1272; child8_sx1272; child9_sx1272; child10_sx1272];


% Bottlenecks ring (child ratio set to 3)
ring1_cc1100 = [1 1];  % Fair improvement vs single and multi
ring2_cc1100 = [14.4232 1];	% Fair improvement vs single and multi
ring3_cc1100 = [38.6585 1];	% Fair improvement vs single and multi
ring4_cc1100 = [26.7845 1];        % Fair improvement vs single and multi
ring5_cc1100 = [10.5198 1];        % Fair improvement vs single and multi
ring6_cc1100 = [5.8683 1.4307];        % Fair improvement vs single and multi
ring7_cc1100 = [3.069 2.2289];        % Fair improvement vs single and multi
ring8_cc1100 = [3.1008 6.1484];        % Fair improvement vs single and multi
ring9_cc1100 = [1.4068 8.361];        % Fair improvement vs single and multi
ring10_cc1100 = [1.3356 21.6836];
y_r_cc1100 = [ring1_cc1100; ring2_cc1100; ring3_cc1100; ring4_cc1100; ring5_cc1100; ring6_cc1100; ring7_cc1100; ring8_cc1100; ring9_cc1100; ring10_cc1100];

ring1_cc1200 = [1 1];  % Fair improvement vs single and multi
ring2_cc1200 = [1.8182 1];	% Fair improvement vs single and multi
ring3_cc1200 = [16.6667 1];	% Fair improvement vs single and multi
ring4_cc1200 = [6.9703 1];        % Fair improvement vs single and multi
ring5_cc1200 = [19.084 1];        % Fair improvement vs single and multi
ring6_cc1200 = [7.7145 1];        % Fair improvement vs single and multi
ring7_cc1200 = [3.0411 1.1095];        % Fair improvement vs single and multi
ring8_cc1200 = [1.3144 1.4384];        % Fair improvement vs single and multi
ring9_cc1200 = [1 3.0183];        % Fair improvement vs single and multi
ring10_cc1200 = [1 8.8582];
y_r_cc1200 = [ring1_cc1200; ring2_cc1200; ring3_cc1200; ring4_cc1200; ring5_cc1200; ring6_cc1200; ring7_cc1200; ring8_cc1200; ring9_cc1200; ring10_cc1200];

ring1_si4464 = [1 1];  % Fair improvement vs single and multi
ring2_si4464 = [1.6966 1];	% Fair improvement vs single and multi
ring3_si4464 = [18.2747 1];	% Fair improvement vs single and multi
ring4_si4464 = [21.7191 1];        % Fair improvement vs single and multi
ring5_si4464 = [12.8476 1];        % Fair improvement vs single and multi
ring6_si4464 = [9.7364 1];        % Fair improvement vs single and multi
ring7_si4464 = [3.2902 1.0146];        % Fair improvement vs single and multi
ring8_si4464 = [2.5704 1.3322];        % Fair improvement vs single and multi
ring9_si4464 = [1.0453 1.4435];        % Fair improvement vs single and multi
ring10_si4464 = [1 3.4476];
y_r_si4464 = [ring1_si4464; ring2_si4464; ring3_si4464; ring4_si4464; ring5_si4464; ring6_si4464; ring7_si4464; ring8_si4464; ring9_si4464; ring10_si4464];

ring1_sx1272 = [1 1];  % Fair improvement vs single and multi
ring2_sx1272 = [4.2017 1];	% Fair improvement vs single and multi
ring3_sx1272 = [7.5291 1];	% Fair improvement vs single and multi
ring4_sx1272 = [9.8564 1];        % Fair improvement vs single and multi
ring5_sx1272 = [6.7617 1];        % Fair improvement vs single and multi
ring6_sx1272 = [2.7808 1.2252];        % Fair improvement vs single and multi
ring7_sx1272 = [1.4715 1.4346];        % Fair improvement vs single and multi
ring8_sx1272 = [1 2.9242];        % Fair improvement vs single and multi
ring9_sx1272 = [1 5.783];        % Fair improvement vs single and multi
ring10_sx1272 = [1 17.3474]; 
y_r_sx1272 = [ring1_sx1272; ring2_sx1272; ring3_sx1272; ring4_sx1272; ring5_sx1272; ring6_sx1272; ring7_sx1272; ring8_sx1272; ring9_sx1272; ring10_sx1272];

figure
subplot(1,2,1)
plot(y_ch_cc1100(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_cc1200(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_si4464(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_sx1272(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('c')
xlim([1 10])
legend('\rho_{SH}^{cc1100}', '\rho_{SH}^{cc1200}', '\rho_{SH}^{Si4464}', '\rho_{SH}^{sx1272}');
grid on

subplot(1,2,2)
plot(y_r_cc1100(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_cc1200(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_si4464(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_sx1272(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('R')
xlim([1 10])
legend('\rho_{SH}^{cc1100}', '\rho_{SH}^{cc1200}', '\rho_{SH}^{Si4464}', '\rho_{SH}^{sx1272}');
grid on

figure
subplot(1,2,1)
plot(y_ch_cc1100(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_ch_cc1100(:,2), '-*', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('c')
xlim([1 10])
subplot(1,2,2)
plot(y_r_cc1100(:,1), '-*', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(y_r_cc1100(:,2), '-*', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('R')
xlim([1 10])
legend('\rho_{SH}', '\rho_{NRH}');
grid on

%% Bottlenecks transceiver
tx_cc1100 = [1263.4375 781.248 567.84]; % Single, multi, fair for Equidistant spreading
tx_cc1200 = [1828.125 561.6 380.64];% Single, multi, fair for Fibo spreading
tx_si4464 = [4875 711.36 711.36];% Single, multi, fair for Fibo spreading
figure 
y = [tx_cc1100(1) tx_cc1200(1) tx_si4464(1); tx_cc1100(2) tx_cc1200(2) tx_si4464(2); tx_cc1100(3) tx_cc1200(3) tx_si4464(3)];
y = y./1000;
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['CC1100 (298 m)']); l{2}=['CC1200 (584 m)']; l{3}=['Si4464 (844 m)'];
legend(h_btle,l);
set(gca,'XTickLabel',{'Single-hop', 'Multi-hop', 'Fair-hop'})
ylabel('e [mJ]')

% Bottlenecks transceiver 2
tx_cc1100 = [1263.4375 781.248 567.84]; % Single, multi, fair for Equidistant spreading
tx_cc1200 = [1828.125 561.6 380.64];% Single, multi, fair for Fibo spreading
tx_si4464 = [4875 711.36 711.36];% Single, multi, fair for Fibo spreading
tx_si4464 = [390000 10033.92 10033.92];% Single, multi, fair for Fibo spreading
figure 
y = [tx_cc1100; tx_cc1200; tx_si4464];
y = y./1000;
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'CC1100 (298 m)', 'CC1200 (584 m)', 'Si4464 (2,2484 m)'})
ylabel('e [mJ]')

% Bottlenecks transceiver 3
tx_cc1100 = [1263.4375 781.248 567.84]; % Single, multi, fair for Equidistant spreading
tx_cc1200 = [1828.125 561.6 380.64];% Single, multi, fair for Fibo spreading
tx_si4464 = [4875 711.36 711.36];% Single, multi, fair for Fibo spreading
tx_si4464 = [265200 5361.408 5361.408];% Single, multi, fair for Fibo spreading
tx_sx1272 = [665529.01 25625.6 25625.6];% Single, multi, fair for Fibo spreading
figure 
y = [tx_cc1100; tx_cc1200; tx_si4464; tx_sx1272];
y = y./1000;
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'CC1100 (298 m)', 'CC1200 (584 m)', 'Si4464 (2,2484 m)', 'sx1272 (4,4098 m)'})
ylabel('e [mJ]')

%% Bottlenecks transceiver II  A:(c = 2, R = 5) and B:(c = 3, R = 7)
figure
% conf A
tx_cc1100_A = [40430 1003.392 1003.392]; % Single, multi, fair for Equidistant spreading
tx_cc1200_A = [58500 798.72 798.72];% Single, multi, fair for Fibo spreading
tx_si4464_A = [265200 5361.408 5361.408];% Single, multi, fair for Fibo spreading
tx_sx1272_A = [665529.0102 25625.6 25625.6];% Single, multi, fair for Fibo spreading
y_A = [tx_cc1100_A; tx_cc1200_A; tx_si4464_A; tx_sx1272_A];
y_A = y_A./1000;
subplot(1,2,1); 
h_btle = bar(y_A);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'CC1100 (457 m)', 'CC1200 (1,2187 m)', 'Si4464 (2,2484 m)', 'SX1272 (4,4098 m)'})
ylabel('e [mJ]')

% conf B
tx_cc1100_B = [40430 29362.944 13173.511]; % Single, multi, fair for Equidistant spreading
tx_cc1200_B = [58500 21342.36 19236.36];% Single, multi, fair for Fibo spreading
tx_si4464_B = [265200 81778.632 80603.64];% Single, multi, fair for Fibo spreading
tx_sx1272_B = [665529.0102 648835.2 452275.2];% Single, multi, fair for Fibo spreading
y = [tx_cc1100_B; tx_cc1200_B; tx_si4464_B; tx_sx1272_B];
y = y./1000;
subplot(1,2,2);
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'CC1100 (457 m)', 'CC1200 (1,2187 m)', 'Si4464 (2,2484 m)', 'SX1272 (4,4098 m)'})
ylabel('e [mJ]')


% 4 subplots
figure
y = [tx_cc1100_A; tx_cc1100_B];
y = y./1000;
subplot(2,2,1);
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
% set(gca,'XTickLabel',{'net_{A}', 'net_{B}'})
ylabel('e [J]')

y = [tx_cc1200_A; tx_cc1200_B];
y = y./1000;
subplot(2,2,2);
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
% set(gca,'XTickLabel',{'net_{A}', 'net_{B}'})
% ylabel('e [J]')

y = [tx_si4464_A; tx_si4464_B];
y = y./1000;
subplot(2,2,3);
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'net_{A}', 'net_{B}'})
ylabel('e [J]')

y = [tx_sx1272_A; tx_sx1272_B];
y = y./1000;
subplot(2,2,4);
h_btle = bar(y);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}=(['Single-hop']); l{2}=['Multi-hop']; l{3}=['Fair-hop'];
legend(h_btle,l);
set(gca,'XTickLabel',{'net_{A}', 'net_{B}'})
% ylabel('e [J]')


%% Total energy plots

legend_str = [];
for i=1:7
    aux_str = strcat('r = ', num2str(i));
    legend_str{end+1} = aux_str;
end

% Network total energy (R = 5)
figure
subplot(1,2,1)
y_c3 = [0.0483600000000000 1.56780000000000 12.6360000000000 394.875000000000 3527.55000000000 13267.8000000000 42646.5000000000;
    21.3423600000000 21.4718400000000 21.4952400000000 22.6605600000000 22.8711600000000 33.3590400000000 35.2544400000000;
    19.2363600000000 19.3658400000000 156.237120000000 397.275840000000 3.91716000000000 362.779560000000 35.2544400000000];
y_c3 = y_c3 ./ 1000;
B = bar(y_c3,'stacked');
set(gca, 'XTick',1:3, 'XTickLabel',{'Single-hop' 'Multi-hop' 'Fair-hop'})
% title('Network total energy comparison')
ylabel('e_{t} [J]')
grid on

subplot(1,2,2)


y_c5 = [0.0483600000000000 2.61300000000000 35.1000000000000 1828.12500000000 27218.7500000000 170625 914062.500000000;
    380.933280000000 381.474600000000 381.459000000000 383.955000000000 427.050000000000 765.375000000000 755.625000000000;
    15.2583600000000 15.3582000000000 17.0820000000000 30.6150000000000 30.2250000000000 170625 914062.500000000];
y_c5 = y_c5 ./ 1000;

y_c2 = [0.0483600000000000 1.04520000000000 5.61600000000000 117 696.800000000000 1747.20000000000 3744;2.49600000000000 2.49600000000000 2.49600000000000 2.49600000000000 2.49600000000000 3.44448000000000 3.09504000000000;2.49600000000000 2.49600000000000 2.49600000000000 2.49600000000000 2.49600000000000 3.44448000000000 3.09504000000000];
y_c2 = y_c2 ./ 1000;

B = bar(y_c2,'stacked');
set(gca, 'XTick',1:3, 'XTickLabel',{'Single-hop' 'Multi-hop' 'Fair-hop'})
% title('Network total energy comparison')
ylabel('e_{t} [J]')
grid on
legend(B, legend_str);

legend_str

%% Aggregation modified

agg_r7_c2 = [0.0483600000000000 9.87636000000000 2.49600000000000;
    0.522600000000000 4.88436000000000 1.24800000000000;
    1.40400000000000 2.38836000000000 0.624000000000000;
    14.6250000000000 1.14036000000000 0.312000000000000;
    43.5500000000000 0.516360000000000 0.156000000000000;
    54.6000000000000 0.204360000000000 0.107640000000000;
    58.5000000000000 0.0483600000000000 0.0483600000000000];

agg_r7_c3 = [0.0483600000000000 28.3623600000000 19.2363600000000;
    0.522600000000000 9.40836000000000 6.45528000000000;
    1.40400000000000 3.09036000000000 17.3596800000000;
    14.6250000000000 0.984360000000000 14.7139200000000;
    43.5500000000000 0.282360000000000 0.0483600000000000;
    54.6000000000000 0.0483600000000000 1.49292000000000;
    58.5000000000000 58.5000000000000 0.0483600000000000];

figure
ax1 = subplot(1,2,1);
h_total_node = bar(agg_r7_c2);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}='Single-hop'; l{2}='Fair-hop (no agg)'; l{3}='Fair-hop (agg)';
legend(h_total_node,l);
% title('TX energy per node')
xlabel('r')
ylabel('e [mJ]')

ax2 = subplot(1,2,2);
h_total_node = bar(agg_r7_c3);
colormap(summer(3));
grid on
l = cell(1,3);
l{1}='Single-hop'; l{2}='Fair-hop (no agg)'; l{3}='Fair-hop (agg)';
legend(h_total_node,l);
% title('RX energy per node')
xlabel('r')
ylabel('e [mJ]')