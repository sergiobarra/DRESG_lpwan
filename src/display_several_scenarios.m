%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%%
%%% File description: specific plots and subplots

% close all
% 
% % Load saved figures
% 
% filename_aux = strcat(pwd, '/results/r3_c2_i500_t1000/consumption.fig');
% consumption_a=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r3_c2_i500_t1000/bottleneck.fig');
% bottleneck_a=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r3_c2_i500_t1000/cdf_optimal.fig');
% cdf_optimal_a=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r3_c2_i500_t1000/cdf_allexplored.fig');
% cdf_allexplored_a=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r3_c2_i500_t1000/max_consumption.fig');
% max_consumption_a=hgload(filename_aux);
% 
% filename_aux = strcat(pwd, '/results/r4_c8_i2000_t1000/consumption.fig');
% consumption_b=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r4_c8_i2000_t1000/bottleneck.fig');
% bottleneck_b=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r4_c8_i2000_t1000/cdf_optimal.fig');
% cdf_optimal_b=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r4_c8_i2000_t1000/cdf_allexplored.fig');
% cdf_allexplored_b=hgload(filename_aux);
% 
% filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/consumption.fig');
% consumption_c=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/bottleneck.fig');
% bottleneck_c=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/cdf_optimal.fig');
% cdf_optimal_c=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/cdf_allexplored.fig');
% cdf_allexplored_c=hgload(filename_aux);
% 
% 
% epsilon_initial = [0.2 0.5 1];  % Learning tunning parameters
% 
% for epsilon_ix = 1:length(epsilon_initial)
%     legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
% end
% 
% % Prepare subplots
% figure
% h(1)=subplot(3,4,1,'LineWidth', 1);
% h(2)=subplot(3,4,2,'LineWidth', 1);
% h(3)=subplot(3,4,3,'LineWidth', 1);
% h(4)=subplot(3,4,4,'LineWidth', 1);
% h(5)=subplot(3,4,5,'LineWidth', 1);
% h(6)=subplot(3,4,6,'LineWidth', 1);
% h(7)=subplot(3,4,7,'LineWidth', 1);
% h(8)=subplot(3,4,8,'LineWidth', 1);
% h(9)=subplot(3,4,9,'LineWidth', 1);
% h(10)=subplot(3,4,10,'LineWidth', 1);
% h(11)=subplot(3,4,11,'LineWidth', 1);
% h(12)=subplot(3,4,12,'LineWidth', 1);
% 
% % Paste figures on the subplots
% copyobj(allchild(get(bottleneck_a,'CurrentAxes')),h(1));
% copyobj(allchild(get(consumption_a,'CurrentAxes')),h(2));
% copyobj(allchild(get(max_consumption_a,'CurrentAxes')),h(3));
% copyobj(allchild(get(cdf_optimal_a,'CurrentAxes')),h(4));
% 
% title(h(1),'bottleneck')
% title(h(2),'Mean cummulated consumption')
% title(h(3),'Max. cummulated consumption')
% title(h(4),'CDF optimal iteration')
% 
% ylabel(h(1), 'Scenario A')
% ylabel(h(5), 'Scenario B')
% ylabel(h(9), 'Scenario C')
% copyobj(allchild(get(bottleneck_b,'CurrentAxes')),h(5));
% copyobj(allchild(get(consumption_b,'CurrentAxes')),h(6));
% copyobj(allchild(get(consumption_b,'CurrentAxes')),h(7));
% copyobj(allchild(get(cdf_optimal_b,'CurrentAxes')),h(8));
% 
% copyobj(allchild(get(bottleneck_c,'CurrentAxes')),h(9));
% copyobj(allchild(get(consumption_c,'CurrentAxes')),h(10));
% copyobj(allchild(get(consumption_c,'CurrentAxes')),h(11));
% copyobj(allchild(get(cdf_optimal_c,'CurrentAxes')),h(12));
% 
% % Add legends
% l(1)=legend(h(1),legend_both_epsilons)

% ----------------------------------------------------------------------------------

% close all
% 
% % Load saved figures
% 
% filename_aux = strcat(pwd, '/results_similarity/A_cnt_0.fig');
% A_cnt_0=hgload(filename_aux);
% filename_aux = strcat(pwd,  '/results_similarity/A_dec_025.fig');
% A_dec_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/A_dec_1.fig');
% A_dec_1=hgload(filename_aux);
% 
% filename_aux = strcat(pwd, '/results_similarity/B_cnt_0.fig');
% B_cnt_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/B_dec_025.fig');
% B_dec_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/B_dec_1.fig');
% B_dec_1=hgload(filename_aux);
% 
% filename_aux = strcat(pwd, '/results_similarity/C_cnt_0.fig');
% C_cnt_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/C_dec_025.fig');
% C_dec_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/C_dec_1.fig');
% C_dec_1=hgload(filename_aux);
% 
% filename_aux = strcat(pwd, '/results_similarity/D_cnt_0.fig');
% D_cnt_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/D_dec_025.fig');
% D_dec_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/D_dec_1.fig');
% D_dec_1=hgload(filename_aux);
% 
% 
% epsilon_initial = [0.2 1];  % Learning tunning parameters
% 
% for epsilon_ix = 1:length(epsilon_initial)
%     legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     
%     legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     
%     legend_constant_similarity{epsilon_ix} = strcat('\epsilon_{cnt&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing_similarity{epsilon_ix} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix + 2*length(epsilon_initial)} = strcat('\epsilon_{cnt&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix + 3*+ length(epsilon_initial)} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     
%     legend_decreasing_with_similarity{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing_with_similarity{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     
% end
% 
% 
% % Prepare subplots
% figure
% h(1)=subplot(4,3,1,'LineWidth', 1);
% h(2)=subplot(4,3,2,'LineWidth', 1);
% h(3)=subplot(4,3,3,'LineWidth', 1);
% h(4)=subplot(4,3,4,'LineWidth', 1);
% h(5)=subplot(4,3,5,'LineWidth', 1);
% h(6)=subplot(4,3,6,'LineWidth', 1);
% h(7)=subplot(4,3,7,'LineWidth', 1);
% h(8)=subplot(4,3,8,'LineWidth', 1);
% h(9)=subplot(4,3,9,'LineWidth', 1);
% h(10)=subplot(4,3,10,'LineWidth', 1);
% h(11)=subplot(4,3,11,'LineWidth', 1);
% h(12)=subplot(4,3,12,'LineWidth', 1);
% 
% % Paste figures on the subplots
% copyobj(allchild(get(A_cnt_0,'CurrentAxes')),h(1));
% copyobj(allchild(get(A_dec_025,'CurrentAxes')),h(2));
% copyobj(allchild(get(A_dec_1,'CurrentAxes')),h(3));
% 
% title(h(1),'\epsilon_b = 0')
% title(h(2),'\epsilon_b = 0.25')
% title(h(3),'\epsilon_b = 1')
% 
% ylabel(h(1), 'Scenario A (R=3)')
% ylabel(h(4), 'Scenario B (R=4)')
% ylabel(h(7), 'Scenario D (R=6)')
% ylabel(h(10), 'Scenario C (R=7)')
% copyobj(allchild(get(B_cnt_0,'CurrentAxes')),h(4));
% copyobj(allchild(get(B_dec_025,'CurrentAxes')),h(5));
% copyobj(allchild(get(B_dec_1,'CurrentAxes')),h(6));
% 
% copyobj(allchild(get(D_cnt_0,'CurrentAxes')),h(7));
% copyobj(allchild(get(D_dec_025,'CurrentAxes')),h(8));
% copyobj(allchild(get(D_dec_1,'CurrentAxes')),h(9));
% 
% copyobj(allchild(get(C_cnt_0,'CurrentAxes')),h(10));
% copyobj(allchild(get(C_dec_025,'CurrentAxes')),h(11));
% copyobj(allchild(get(C_dec_1,'CurrentAxes')),h(12));
% 
% 
% % Add legends
% l(1)=legend(h(1),legend_decreasing_with_similarity)

% ----------------------------------------------------------------------------------

% close all
% 
% % Load saved figures
% 
% % A
% filename_aux = strcat(pwd, '/results_similarity/r3c2_0.fig');
% r3c2_0=hgload(filename_aux);
% filename_aux = strcat(pwd,  '/results_similarity/r3c2_025.fig');
% r3c2_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r3c2_1.fig');
% r3c2_1=hgload(filename_aux);
% 
% % B
% filename_aux = strcat(pwd, '/results_similarity/r3c4_0.fig');
% r3c4_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r3c4_025.fig');
% r3c4_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r3c4_1.fig');
% r3c4_1=hgload(filename_aux);
% 
% % C
% filename_aux = strcat(pwd, '/results_similarity/r3c8_0.fig');
% r3c8_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r3c8_025.fig');
% r3c8_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r3c8_1.fig');
% r3c8_1=hgload(filename_aux);
% 
% % D
% filename_aux = strcat(pwd, '/results_similarity/r4c4_0.fig');
% r4c4_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r4c4_025.fig');
% r4c4_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r4c4_1.fig');
% r4c4_1=hgload(filename_aux);
% 
% % E
% filename_aux = strcat(pwd, '/results_similarity/r4c8_0.fig');
% r4c8_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r4c8_025.fig');
% r4c8_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r4c8_1.fig');
% r4c8_1=hgload(filename_aux);
% 
% % F
% filename_aux = strcat(pwd, '/results_similarity/r5c4_0.fig');
% r5c4_0=hgload(filename_aux);
% filename_aux = strcat(pwd,  '/results_similarity/r5c4_025.fig');
% r5c4_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r5c4_1.fig');
% r5c4_1=hgload(filename_aux);
% 
% % G
% filename_aux = strcat(pwd, '/results_similarity/r5c8_0.fig');
% r5c8_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r5c8_025.fig');
% r5c8_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r5c8_1.fig');
% r5c8_1=hgload(filename_aux);
% 
% % H
% filename_aux = strcat(pwd, '/results_similarity/r6c2_0.fig');
% r6c2_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r6c2_025.fig');
% r6c2_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r6c2_1.fig');
% r6c2_1=hgload(filename_aux);
% 
% % I
% filename_aux = strcat(pwd, '/results_similarity/r6c4_0.fig');
% r6c4_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r6c4_025.fig');
% r6c4_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r6c4_1.fig');
% r6c4_1=hgload(filename_aux);
% 
% % J
% filename_aux = strcat(pwd, '/results_similarity/r7c2_0.fig');
% r7c2_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r7c2_025.fig');
% r7c2_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r7c2_1.fig');
% r7c2_1=hgload(filename_aux);
% 
% % K
% filename_aux = strcat(pwd, '/results_similarity/r7c3_0.fig');
% r7c3_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r7c3_025.fig');
% r7c3_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r7c3_1.fig');
% r7c3_1=hgload(filename_aux);
% 
% % L
% filename_aux = strcat(pwd, '/results_similarity/r7c4_0.fig');
% r7c4_0=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r7c4_025.fig');
% r7c4_025=hgload(filename_aux);
% filename_aux = strcat(pwd, '/results_similarity/r7c4_1.fig');
% r7c4_1=hgload(filename_aux);
% 
% 
% epsilon_initial = [0.2 1];  % Learning tunning parameters
% 
% for epsilon_ix = 1:length(epsilon_initial)
%     legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     
%     legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     
%     legend_constant_similarity{epsilon_ix} = strcat('\epsilon_{cnt&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing_similarity{epsilon_ix} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix + 2*length(epsilon_initial)} = strcat('\epsilon_{cnt&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_all{epsilon_ix + 3*+ length(epsilon_initial)} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     
%     legend_decreasing_with_similarity{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
%     legend_decreasing_with_similarity{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
%     
% end
% 
% % ------- Prepare 3 figures ----- 
% 
% % FIGURE 1
% figure
% h1(1)=subplot(4,3,1,'LineWidth', 1);
% h1(2)=subplot(4,3,2,'LineWidth', 1);
% h1(3)=subplot(4,3,3,'LineWidth', 1);
% h1(4)=subplot(4,3,4,'LineWidth', 1);
% h1(5)=subplot(4,3,5,'LineWidth', 1);
% h1(6)=subplot(4,3,6,'LineWidth', 1);
% h1(7)=subplot(4,3,7,'LineWidth', 1);
% h1(8)=subplot(4,3,8,'LineWidth', 1);
% h1(9)=subplot(4,3,9,'LineWidth', 1);
% h1(10)=subplot(4,3,10,'LineWidth', 1);
% h1(11)=subplot(4,3,11,'LineWidth', 1);
% h1(12)=subplot(4,3,12,'LineWidth', 1);
% 
% % Paste figures on the subplots
% copyobj(allchild(get(r3c2_0,'CurrentAxes')),h1(1));
% copyobj(allchild(get(r3c2_025,'CurrentAxes')),h1(2));
% copyobj(allchild(get(r3c2_1,'CurrentAxes')),h1(3));
% 
% title(h1(1),'\epsilon_b = 0')
% title(h1(2),'\epsilon_b = 0.25')
% title(h1(3),'\epsilon_b = 1')
% 
% ylabel(h1(1), 'Scenario A (R=3,c=2)')
% ylabel(h1(4), 'Scenario B (R=3,c=4)')
% ylabel(h1(7), 'Scenario C (R=3,c=8)')
% ylabel(h1(10), 'Scenario D (R=4,c=2)')
% copyobj(allchild(get(r3c4_0,'CurrentAxes')),h1(4));
% copyobj(allchild(get(r3c4_025,'CurrentAxes')),h1(5));
% copyobj(allchild(get(r3c4_1,'CurrentAxes')),h1(6));
% 
% copyobj(allchild(get(r3c8_0,'CurrentAxes')),h1(7));
% copyobj(allchild(get(r3c8_025,'CurrentAxes')),h1(8));
% copyobj(allchild(get(r3c8_1,'CurrentAxes')),h1(9));
% 
% copyobj(allchild(get(r4c4_0,'CurrentAxes')),h1(10));
% copyobj(allchild(get(r4c4_025,'CurrentAxes')),h1(11));
% copyobj(allchild(get(r4c4_1,'CurrentAxes')),h1(12));
% 
% % Add legends
% l(1) = legend(h1(1),legend_decreasing_with_similarity);
% 
% 
% % FIGURE 2
% figure
% h2(1)=subplot(4,3,1,'LineWidth', 1);
% h2(2)=subplot(4,3,2,'LineWidth', 1);
% h2(3)=subplot(4,3,3,'LineWidth', 1);
% h2(4)=subplot(4,3,4,'LineWidth', 1);
% h2(5)=subplot(4,3,5,'LineWidth', 1);
% h2(6)=subplot(4,3,6,'LineWidth', 1);
% h2(7)=subplot(4,3,7,'LineWidth', 1);
% h2(8)=subplot(4,3,8,'LineWidth', 1);
% h2(9)=subplot(4,3,9,'LineWidth', 1);
% h2(10)=subplot(4,3,10,'LineWidth', 1);
% h2(11)=subplot(4,3,11,'LineWidth', 1);
% h2(12)=subplot(4,3,12,'LineWidth', 1);
% 
% % Paste figures on the subplots
% copyobj(allchild(get(r4c8_0,'CurrentAxes')),h2(1));
% copyobj(allchild(get(r4c8_025,'CurrentAxes')),h2(2));
% copyobj(allchild(get(r4c8_1,'CurrentAxes')),h2(3));
% 
% title(h2(1),'\epsilon_b = 0')
% title(h2(2),'\epsilon_b = 0.25')
% title(h2(3),'\epsilon_b = 1')
% 
% ylabel(h2(1), 'Scenario E (R=4,c=8)')
% ylabel(h2(4), 'Scenario F (R=5,c=4)')
% ylabel(h2(7), 'Scenario G (R=5,c=8)')
% ylabel(h2(10), 'Scenario H (R=6,c=2)')
% copyobj(allchild(get(r5c4_0,'CurrentAxes')),h2(4));
% copyobj(allchild(get(r5c4_025,'CurrentAxes')),h2(5));
% copyobj(allchild(get(r5c4_1,'CurrentAxes')),h2(6));
% 
% copyobj(allchild(get(r5c8_0,'CurrentAxes')),h2(7));
% copyobj(allchild(get(r5c8_025,'CurrentAxes')),h2(8));
% copyobj(allchild(get(r5c8_1,'CurrentAxes')),h2(9));
% 
% copyobj(allchild(get(r6c2_0,'CurrentAxes')),h2(10));
% copyobj(allchild(get(r6c2_025,'CurrentAxes')),h2(11));
% copyobj(allchild(get(r6c2_1,'CurrentAxes')),h2(12));
% 
% % Add legends
% l(1)=legend(h2(1),legend_decreasing_with_similarity);
% 
% % FIGURE 3
% figure
% h3(1)=subplot(4,3,1,'LineWidth', 1);
% h3(2)=subplot(4,3,2,'LineWidth', 1);
% h3(3)=subplot(4,3,3,'LineWidth', 1);
% h3(4)=subplot(4,3,4,'LineWidth', 1);
% h3(5)=subplot(4,3,5,'LineWidth', 1);
% h3(6)=subplot(4,3,6,'LineWidth', 1);
% h3(7)=subplot(4,3,7,'LineWidth', 1);
% h3(8)=subplot(4,3,8,'LineWidth', 1);
% h3(9)=subplot(4,3,9,'LineWidth', 1);
% h3(10)=subplot(4,3,10,'LineWidth', 1);
% h3(11)=subplot(4,3,11,'LineWidth', 1);
% h3(12)=subplot(4,3,12,'LineWidth', 1);
% 
% % Paste figures on the subplots
% copyobj(allchild(get(r6c4_0,'CurrentAxes')),h3(1));
% copyobj(allchild(get(r6c4_025,'CurrentAxes')),h3(2));
% copyobj(allchild(get(r6c4_1,'CurrentAxes')),h3(3));
% 
% title(h3(1),'\epsilon_b = 0')
% title(h3(2),'\epsilon_b = 0.25')
% title(h3(3),'\epsilon_b = 1')
% 
% ylabel(h3(1), 'Scenario I (R=6,c=4)')
% ylabel(h3(4), 'Scenario J (R=7,c=2)')
% ylabel(h3(7), 'Scenario K (R=7,c=3)')
% ylabel(h3(10), 'Scenario L (R=7,c=4)')
% copyobj(allchild(get(r7c2_0,'CurrentAxes')),h3(4));
% copyobj(allchild(get(r7c2_025,'CurrentAxes')),h3(5));
% copyobj(allchild(get(r7c2_1,'CurrentAxes')),h3(6));
% 
% copyobj(allchild(get(r7c3_0,'CurrentAxes')),h3(7));
% copyobj(allchild(get(r7c3_025,'CurrentAxes')),h3(8));
% copyobj(allchild(get(r7c3_1,'CurrentAxes')),h3(9));
% 
% copyobj(allchild(get(r7c4_0,'CurrentAxes')),h3(10));
% copyobj(allchild(get(r7c4_025,'CurrentAxes')),h3(11));
% copyobj(allchild(get(r7c4_1,'CurrentAxes')),h3(12));
% 
% % Add legends
% l(1)=legend(h3(1),legend_decreasing_with_similarity);

% ----------------------------------------------
% close all 
% 
% ratio_eps_20 = [0.71614 0.80375 0.9259;...
%      0.82752 0.90326 0.97735;...
%      0.81546 0.95578 0.93468;...
%      0.81572 0.92997 1.0505;...
%      0.75026 0.80878 0.86461;...
%      0.89547 1.0467 1.1298;...
%      1.0503 1.0164 1.0097;...
%      0.80954 1.0002 1.0245;...
%      0.57843 1.1939 1.1383;...
%      0.54162 1.0911 1.2121;...
%      0.57987 1.4085 1.255;...
%      0.58852 0.98658 1.4427];
%  
% ratio_eps_100 = [0.89946 0.99298 0.99686;...
%     0.99243 0.9809 0.98875;...
%     0.99851 0.99626 0.96671;...
%     0.98941 1.0115 1.0098;...
%     0.96564 0.97284 0.98496;...
%     1.2082 1.2995 1.3089;...
%     1.1029 0.90324 0.87069;...
%     1.2973 1.6799 1.9258;...
%     1.9877 1.6688 1.5285;...
%     1.7804 1.9836 2.6939;...
%     1.88 2.6309 2.3108;...
%     2.0752 2.1901 2.1327];
% 
% figure
% hold on
% plot(ratio_eps_20(:,1))
% plot(ratio_eps_20(:,2))
% plot(ratio_eps_20(:,3))
% plot(ratio_eps_100(:,1))
% plot(ratio_eps_100(:,2))
% plot(ratio_eps_100(:,3))
% legend('\epsilon_a = 0.2 & \epsilon_b = 0', '\epsilon_a = 0.2 & \epsilon_b = 0.25', '\epsilon_a = 0.2 & \epsilon_b = 1.0',...
%     '\epsilon_a = 1.0 & \epsilon_b = 0', '\epsilon_a = 1.0 & \epsilon_b = 0.25', '\epsilon_a = 1.0 & \epsilon_b = 1.0')


% close all 
%  
%  ratio_eps_20 = [0.71614 0.80375 0.9259;...  % A: R=3,c=2
%      0.82752 0.90326 0.97735;...            % B: R=3,c=4
%      0.81546 0.95578 0.93468;...            % C: R=3,c=8
%      0.81572 0.92997 1.0505;...             % D: R=4,c=4
%      0.75026 0.80878 0.86461;...            % E: R=4,c=8
%      0.43525 0.51651 0.51958;...              % F: R=5,c=2
%      0.89547 1.0467 1.1298;...               % G: R=5,c=4 
%      1.0503 1.0164 1.0097;...              % H: R=5,c=8 
%      0.37633 0.51649 0.69776;...              % I: R=6,c=1 
%      0.80954 1.0002 1.0245;...            % J: R=6,c=2 
%      0.57843 1.1939 1.1383;...              % K: R=6,c=4 
%      0.24385 0.33728 0.62238;...               % L: R=7,c=1 
%      0.54162 1.0911 1.2121;...             % M: R=7,c=2
%      0.57987 1.4085 1.255;...              % N: R=7,c=3 
%      0.58852 0.98658 1.4427;...                                   % O: R=7,c=4
%      0.47803 0.6314 1.3170];                                     % P: R=7,c=5 
%  
% ratio_eps_100 = [0.89946 0.99298 0.99686;...    % A: R=3,c=
%     0.99243 0.9809 0.98875;...  % B: R=3,c=4
%     0.99851 0.99626 0.96671;... % C: R=3,c=8
%     0.98941 1.0115 1.0098;...   % D: R=4,c=4
%     0.96564 0.97284 0.98496;... % E: R=4,c=8
%     0.79042 1.3035 1.334591;... % F: R=5,c=2
%     1.2082 1.2995 1.3089;...    % G: R=5,c=4 
%     1.1029 0.90324 0.87069;...  % H: R=5,c=8 
%     0.5735 1.13395 1.2129;...   % I: R=6,c=1 
%     1.2973 1.6799 1.9258;...    % J: R=6,c=2 
%     1.9877 1.6688 1.5285;...    % K: R=6,c=4 
%     0.3083 0.7816 0.82041;...   % L: R=7,c=1
%     1.7804 1.9836 2.6939;...    % M: R=7,c=2
%     1.88 2.6309 2.3108;...  	% N: R=7,c=3
%     2.0752 2.1901 2.1327;...    % O: R=7,c=4
%     1.7765 1.9384 1.98305];     % P: R=7,c=5 
% 
% figure
% hold on
% plot(ratio_eps_20(:,1))
% plot(ratio_eps_20(:,2))
% plot(ratio_eps_20(:,3))
% plot(ratio_eps_100(:,1))
% plot(ratio_eps_100(:,2))
% plot(ratio_eps_100(:,3))
% plot(0:size(ratio_eps_20,1), ones(1, size(ratio_eps_20,1) + 1))
% legend('\epsilon_a = 0.2 & \epsilon_b = 0', '\epsilon_a = 0.2 & \epsilon_b = 0.25', '\epsilon_a = 0.2 & \epsilon_b = 1.0',...
%     '\epsilon_a = 1.0 & \epsilon_b = 0', '\epsilon_a = 1.0 & \epsilon_b = 0.25', '\epsilon_a = 1.0 & \epsilon_b = 1.0')
% xlabel('Scenario')
% ylabel('Similarity ratio improvement \rho_S')



%% eps_b vs. ratio 

% close all
% 
% r6_c2 = [0.80954 1.0002 1.12569 1.0466 1.0245;
%     1.2973 1.6799 1.87509 1.8937 1.9258];
% r6_c4 = [0.57843 1.1939 1.01657 1.07602 1.1383;
%      1.9877 1.6688 1.6866 1.7856 1.5285];
% r7_c2 = [0.54162 1.0911 0.7738 0.9693 1.2121;
%     1.7804 1.9836 2.2727 2.3984 2.6939];
% r7_c3 = [0.57987 1.4085 0.7526 1.12339 1.255;
%     1.88 2.6309 2.33414 2.43193 2.3108];
% 
% eps_b = 0:0.25:1;
% 
% figure
% hold on
% plot(eps_b,r6_c2(1,:))
% plot(eps_b,r6_c2(2,:))
% 
% plot(eps_b, r6_c4(1,:))
% plot(eps_b,r6_c4(2,:))
% 
% plot(eps_b,r7_c2(1,:))
% plot(eps_b,r7_c2(2,:))
% 
% plot(eps_b,r7_c3(1,:))
% plot(eps_b,r7_c3(2,:))
% 
% legend('J - \epsilon_a = 0.2', 'J - \epsilon_a = 1.0', 'K - \epsilon_a = 0.2', 'K - \epsilon_a = 1.0',...
%     'M - \epsilon_a = 0.2', 'M - \epsilon_a = 1.0', 'N - \epsilon_a = 0.2', 'N - \epsilon_a = 1.0')
% xlabel('\epsilon_b')
% ylabel('Similarity improvement ratio \rho_S')
% 
% figure
% subplot(1,2,1)
% hold on
% plot(eps_b,r6_c2(1,:))
% plot(eps_b, r6_c4(1,:))
% plot(eps_b,r7_c2(1,:))
% plot(eps_b,r7_c3(1,:))
% legend('J: R=6,c=2', 'K: R=6,c=4', 'L: R=7,c=2', 'M: R=7,c=3')
% plot(0:0.25:1, ones(1,5))
% xlabel('\epsilon_b')
% ylabel('Similarity improvement ratio \rho_S (\epsilon_a = 0.2)')
% subplot(1,2,2)
% hold on
% plot(eps_b,r6_c2(2,:))
% plot(eps_b, r6_c4(2,:))
% plot(eps_b,r7_c2(2,:))
% plot(eps_b,r7_c3(2,:))
% legend('J: R=6,c=2', 'K: R=6,c=4', 'L: R=7,c=2', 'M: R=7,c=3')
% hold on
% plot(0:0.25:1, ones(1,5))
% xlabel('\epsilon_b')
% ylabel('Similarity improvement ratio \rho_S (\epsilon_a = 1.0)')

%% Bottleneck, Mean cummulated consumption, Max cummulated consumption
close all

epsilon_initial = [0.2 0.5 1];  % Learning tunning parameters

for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
       
end

filename_aux = strcat(pwd, '/results/r4_c8_i500_t1000/mean_bottleneck_consumption.fig');
r4c8_btle=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r4_c8_i500_t1000/mean_cummulated_consumption.fig');
r4c8_cum=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r4_c8_i500_t1000/max_cummulated_consumption.fig');
r4c8_max=hgload(filename_aux);

filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/mean_bottleneck_consumption_v2.fig');
r7c3_btle=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/mean_cummulated_consumption_v2.fig');
r7c3_cum=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r7_c3_i12000_t1000/max_cummulated_consumption_v2.fig');
r7c3_max=hgload(filename_aux);

figure
h(1)=subplot(3,2,1,'LineWidth', 1);
h(2)=subplot(3,2,2,'LineWidth', 1);
h(3)=subplot(3,2,3,'LineWidth', 1);
h(4)=subplot(3,2,4,'LineWidth', 1);
h(5)=subplot(3,2,5,'LineWidth', 1);
h(6)=subplot(3,2,6,'LineWidth', 1);

copyobj(allchild(get(r4c8_btle,'CurrentAxes')),h(1));
copyobj(allchild(get(r4c8_cum,'CurrentAxes')),h(3));
copyobj(allchild(get(r4c8_max,'CurrentAxes')),h(5));

title(h(1),'Scenario A (R=4,c=8)')
title(h(2),'Scenario B (R=7,c=3)')

copyobj(allchild(get(r7c3_btle,'CurrentAxes')),h(2));
copyobj(allchild(get(r7c3_cum,'CurrentAxes')),h(4));
copyobj(allchild(get(r7c3_max,'CurrentAxes')),h(6));

ylabel(h(1),'e_{btle} [mJ]')
ylabel(h(3),'e^*_{btle}] [mJ]')
ylabel(h(5),'Max[e^*_{btle}] [mJ]')
xlabel(h(5),'Iteration')
xlabel(h(6),'Iteration')
legend(h(1), legend_both_epsilons)

set(h(1), 'XTickLabel', [],'XTick',[])
set(h(3), 'XTickLabel', [],'XTick',[])
set(h(2), 'XTickLabel', [],'XTick',[])
set(h(4), 'XTickLabel', [],'XTick',[])

