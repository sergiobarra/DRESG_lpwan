%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% - Learning extension
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%%
%%% File description: script for displaying and plotting results

close all

%% CONFIGURATION

save_figures = false;   % Flag for saving the generated figures
save_info = false;      % Flag for writting general info into a file
load_mat = false;        % Flag for loading a '.mat' file into the workspace


% output_root_filename = 'results/r5_c5_i8000_t1000/';

% Load workspace if necessary
% Load just the required variables (avoid loading variables with high memory size)
if load_mat
    
    mat_filename = 'r7_c3_i12000_t1000_linear_decreasing_epsilon.mat';
    
    load(mat_filename,'epsilon_initial','num_explored_actions_constant_mean','num_possible_actions',...
        'num_unexplored_actions_constant_mean','mean_iteration_optimal_constant','mean_iteration_all_constant',...
        'num_explored_actions_decreasing_mean', 'num_unexplored_actions_decreasing_mean',...
        'mean_iteration_optimal_decreasing', 'mean_iteration_all_decreasing','num_epsilons',...
        'max_cum_mean_rings_e_constant','max_cum_mean_rings_e_decreasing','num_rings','child_ratio',...
        'mean_btle_e_constant', 'mean_btle_e_decreasing','num_iterations','statistics_constant','statistics_decreasing',...
        'num_trials','times_all_explored_constant','times_all_explored_decreasing','times_optimal_explored_decreasing',...
        'times_optimal_explored_constant', 'max_cum_max_ring_e_constant', 'max_cum_max_ring_e_decreasing',...
        'max_cum_mean_rings_e_constant_similarity', 'max_cum_mean_rings_e_decreasing_similarity',...
        'mean_btle_e_constant_similarity', 'mean_btle_e_decreasing_similarity', 'sqz_std_matrix_rings_e_constant',...
        'sqz_std_matrix_rings_e_decreasing')
    
    % load(mat_filename)
end

%% DIPLAY GENERAL INFO

disp(' ')
% Display some parameters per console
disp('Results GREEDY CONSTANT:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])    
    disp(['  * Explored actions: ' num2str(num_explored_actions_constant_mean) '/' num2str(num_possible_actions)])
    disp(['  * Iteration where ALL actions were explored: ' num2str(mean_iteration_all_constant(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['     + Num. trials where all actions were explored: ' num2str(times_optimal_explored_constant(epsilon_ix))...
        '/' num2str(num_trials) ' (' num2str(times_optimal_explored_constant(epsilon_ix)*100/num_trials) ' %)'])
    disp(['  * Iteration where OPTIMAL action was picked: ' num2str(mean_iteration_optimal_constant(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['     + Num. trials where optimal actions was picked: ' num2str(times_all_explored_constant(epsilon_ix))...
        '/' num2str(num_trials) ' (' num2str(times_all_explored_constant(epsilon_ix)*100/num_trials) ' %)'])
    disp('--------------------------------------------------------------------')
    
end

disp(' ')
disp('Results GREEDY DECREASING:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])    
    disp(['  * Explored actions: ' num2str(num_explored_actions_decreasing_mean) '/' num2str(num_possible_actions)])
    disp(['  * Iteration where ALL actions were explored: ' num2str(mean_iteration_all_decreasing(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['     + Num. trials where all actions were explored: ' num2str(times_optimal_explored_decreasing(epsilon_ix))...
        '/' num2str(num_trials) ' (' num2str(times_optimal_explored_decreasing(epsilon_ix)*100/num_trials) ' %)'])
    disp(['  * Iteration where OPTIMAL action was picked: ' num2str(mean_iteration_optimal_decreasing(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['     + Num. trials where optimal actions was picked: ' num2str(times_all_explored_decreasing(epsilon_ix))...
        '/' num2str(num_trials) ' (' num2str(times_all_explored_decreasing(epsilon_ix)*100/num_trials) ' %)'])
    disp('--------------------------------------------------------------------')
end

% Write logs
if save_info
    
    filename_aux = strcat(output_root_filename, 'results.txt');
    fileID = fopen(filename_aux,'w');
    
    fprintf(fileID,'*** Results GREEDY CONSTANT ***\n');
    
    for epsilon_ix = 1:length(epsilon_initial)

        fprintf(fileID,'- epsilon = %.2f\n', epsilon_initial(epsilon_ix));
        fprintf(fileID,'  * Explored actions: %.2f/%d\n', num_explored_actions_constant_mean, num_possible_actions);
        fprintf(fileID,'  * Iteration where ALL actions were explored: %.2f/%d\n', mean_iteration_all_constant(epsilon_ix), num_iterations);
        fprintf(fileID,'     + Num. trials where all actions were explored: %d/%d (%.2f %%)\n', times_optimal_explored_constant(epsilon_ix),...
            num_trials, times_optimal_explored_constant(epsilon_ix)*100/num_trials);
        fprintf(fileID,'  * Iteration where OPTIMAL action was picked: %.2f\n', mean_iteration_optimal_constant(epsilon_ix),...
            num_iterations);
        fprintf(fileID,'     + Num. trials where optimal actions was picked: %.2f/%d (%.2f %%)\n', times_all_explored_constant(epsilon_ix), ...
            num_trials, times_all_explored_constant(epsilon_ix)*100/num_trials);
        fprintf(fileID,'--------------------------------------------------------------------\n');

    end

    fprintf(fileID,'\n*** Results GREEDY DECREASING ***\n');
    
    for epsilon_ix = 1:length(epsilon_initial)

        fprintf(fileID,'- epsilon = %.2f\n', epsilon_initial(epsilon_ix));
        fprintf(fileID,'  * Explored actions: %.2f/%d\n', num_explored_actions_decreasing_mean, num_possible_actions);
        fprintf(fileID,'  * Iteration where ALL actions were explored: %.2f/%d\n', mean_iteration_all_decreasing(epsilon_ix), num_iterations);
        fprintf(fileID,'     + Num. trials where all actions were explored: %d/%d (%.2f %%)\n', times_optimal_explored_decreasing(epsilon_ix),...
            num_trials, times_optimal_explored_decreasing(epsilon_ix)*100/num_trials);
        fprintf(fileID,'  * Iteration where OPTIMAL action was picked: %.2f\n', mean_iteration_optimal_decreasing(epsilon_ix),...
            num_iterations);
        fprintf(fileID,'     + Num. trials where optimal actions was picked: %.2f/%d (%.2f %%)\n', times_all_explored_decreasing(epsilon_ix), ...
            num_trials, times_all_explored_decreasing(epsilon_ix)*100/num_trials);
        fprintf(fileID,'--------------------------------------------------------------------\n');

    end
end

%% GENERATE PLOTS

for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    
    legend_constant_similarity{epsilon_ix} = strcat('\epsilon_{cnt&S}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing_similarity{epsilon_ix} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_all{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_all{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_all{epsilon_ix + 2*length(epsilon_initial)} = strcat('\epsilon_{cnt&S}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_all{epsilon_ix + 3*+ length(epsilon_initial)} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
    
    legend_decreasing_with_similarity{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing_with_similarity{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec&S}: ', num2str(epsilon_initial(epsilon_ix)));
    
end

% Mean cummulated consumption of the historic bottleneck
figure
hold on
for epsilon_ix = 1:num_epsilons
    plot(max_cum_mean_rings_e_constant(epsilon_ix,:))
end
for epsilon_ix = 1:num_epsilons
    plot(max_cum_mean_rings_e_decreasing(epsilon_ix,:))
end
title_string = strcat('Cummulated consumption of historic bottleneck with \epsilon - greedy (DRESG: R= ',...
    num2str(num_rings), ', c= ', num2str(child_ratio), ')');
title(title_string)
xlabel('time [iterations]')
ylabel('Cummulated consumption [mJ]')
legend(legend_both_epsilons);
% 
% if save_figures
%     filename_aux = strcat(output_root_filename, 'consumption.fig');
%     savefig(filename_aux)
% end

% CONSUMPTION WITH SIMILARITY

% EPSILON_B = 0
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing(epsilon_ix,:))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing_similarity_decreasing_0(epsilon_ix,:))
% end
% title_string = strcat('Cummulated consumption of historic bottleneck with \epsilon_b = 0 (DRESG: R= ',...
%     num2str(num_rings), ', c= ', num2str(child_ratio), ')');
% title(title_string)
% xlabel('time [iterations]')
% ylabel('Cummulated consumption [mJ]')
% legend(legend_decreasing_with_similarity);
% filename_aux = strcat('r',num2str(num_rings),'c',num2str(child_ratio),'_0.fig');
% savefig(filename_aux)

% EPSILON_B = 0.25
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing(epsilon_ix,:))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing_similarity_decreasing_025(epsilon_ix,:))
% end
% title_string = strcat('Cummulated consumption of historic bottleneck with \epsilon_b = 0.25 (DRESG: R= ',...
%     num2str(num_rings), ', c= ', num2str(child_ratio), ')');
% title(title_string)
% xlabel('time [iterations]')
% ylabel('Cummulated consumption [mJ]')
% legend(legend_decreasing_with_similarity);
% filename_aux = strcat('r',num2str(num_rings),'c',num2str(child_ratio),'_025.fig');
% savefig(filename_aux)

% % EPSILON_B = 0.50
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing(epsilon_ix,:))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing_similarity_decreasing_050(epsilon_ix,:))
% end
% title_string = strcat('Cummulated consumption of historic bottleneck with \epsilon_b = 0.50 (DRESG: R= ',...
%     num2str(num_rings), ', c= ', num2str(child_ratio), ')');
% title(title_string)
% xlabel('time [iterations]')
% ylabel('Cummulated consumption [mJ]')
% legend(legend_decreasing_with_similarity);
% filename_aux = strcat('r',num2str(num_rings),'c',num2str(child_ratio),'_050.fig');
% savefig(filename_aux)
% 
% % EPSILON_B = 0.75
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing(epsilon_ix,:))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing_similarity_decreasing_075(epsilon_ix,:))
% end
% title_string = strcat('Cummulated consumption of historic bottleneck with \epsilon_b = 0.75 (DRESG: R= ',...
%     num2str(num_rings), ', c= ', num2str(child_ratio), ')');
% title(title_string)
% xlabel('time [iterations]')
% ylabel('Cummulated consumption [mJ]')
% legend(legend_decreasing_with_similarity);
% filename_aux = strcat('r',num2str(num_rings),'c',num2str(child_ratio),'_075.fig');
% savefig(filename_aux)

% EPSILON_B = 1
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing(epsilon_ix,:))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_mean_rings_e_decreasing_similarity_decreasing_1(epsilon_ix,:))
% end
% title_string = strcat('Cummulated consumption of historic bottleneck with \epsilon_b = 1 (DRESG: R= ',...
%     num2str(num_rings), ', c= ', num2str(child_ratio), ')');
% title(title_string)
% xlabel('time [iterations]')
% ylabel('Cummulated consumption [mJ]')
% legend(legend_decreasing_with_similarity);
% filename_aux = strcat('r',num2str(num_rings),'c',num2str(child_ratio),'_1.fig');
% savefig(filename_aux)

% Mean bottleneck consumption
figure
hold on
for epsilon_ix = 1:num_epsilons
    plot(mean_btle_e_constant(epsilon_ix,:))
end
for epsilon_ix = 1:num_epsilons
    plot(mean_btle_e_decreasing(epsilon_ix,:))
end
title_string = strcat('Bottleneck energy with \epsilon - greedy (DRESG: R= ',...
    num2str(num_rings), ', c= ', num2str(child_ratio), ')');
title(title_string)
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_both_epsilons);

% if save_figures
%    filename_aux = strcat(output_root_filename, 'bottleneck.fig');
%     savefig(filename_aux)
% end

% % BOTTLENECK WITH SIMILARITY
% figure
% hold on
% % for epsilon_ix = 1:num_epsilons
% %     plot(mean_btle_e_constant(epsilon_ix,:))
% % end
% for epsilon_ix = 1:num_epsilons
%     plot(mean_btle_e_decreasing(epsilon_ix,:))
% end
% % for epsilon_ix = 1:num_epsilons
% %     plot(mean_btle_e_constant_similarity(epsilon_ix,:))
% % end
% % for epsilon_ix = 1:num_epsilons
% %     plot(mean_btle_e_decreasing_similarity(epsilon_ix,:))
% % end
% for epsilon_ix = 1:num_epsilons
%     plot(mean_btle_e_decreasing_similarity_decreasing(epsilon_ix,:))
% end
% title_string = strcat('SIMILARITY Bottleneck consumption of historic bottleneck with \epsilon - greedy (DRESG: R= ',...
%     num2str(num_rings), ', c= ', num2str(child_ratio), ')');
% title(title_string)
% xlabel('time [iterations]')
% ylabel('Cummulated consumption [mJ]')
% legend(legend_decreasing_with_similarity);

% 
% % CDF optimal iteration
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     cdfplot(([statistics_constant(:, epsilon_ix).iteration_optimal]));
% end
% for epsilon_ix = 1:num_epsilons
%     cdfplot(([statistics_decreasing(:, epsilon_ix).iteration_optimal]));
% end
% title('CDF of the iteration where the optimal action is found')
% xlabel('time [iterations]')
% ylabel('F(X)')
% legend(legend_both_epsilons);
% 
% if save_figures
%     filename_aux = strcat(output_root_filename, 'cdf_optimal.fig');
%     savefig(filename_aux)
% end
% 
% % CDF all-explored iteration
% 
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     cdfplot(([statistics_constant(:, epsilon_ix).iteration_explored]));
% end
% for epsilon_ix = 1:num_epsilons
%     cdfplot(([statistics_decreasing(:, epsilon_ix).iteration_explored]));
% end
% title('CDF of the iteration where all the actions are explored')
% xlabel('time [iterations]')
% ylabel('F(X)')
% legend(legend_both_epsilons);
% 
% if save_figures
%     filename_aux = strcat(output_root_filename, 'cdf_allexplored.fig');
%     savefig(filename_aux)
% end
% 
% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_max_ring_e_constant(epsilon_ix,:))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(max_cum_max_ring_e_decreasing(epsilon_ix,:))
% end
% title('Max cummulated energy per ring')
% xlabel('time [iterations]')
% ylabel('e [mJ]')
% legend(legend_both_epsilons);

% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     plot(sqz_std_matrix_rings_e_constant(:,epsilon_ix))
% end
% for epsilon_ix = 1:num_epsilons
%     plot(sqz_std_matrix_rings_e_decreasing(:,epsilon_ix))
% end
% title('Standard deviation of cummulated energy')
% xlabel('time [iterations]')
% ylabel('e [mJ]')
% legend(legend_both_epsilons);


% -----------------

% Variance + CDF figure
figure
subplot(1,2,1)
hold on
for epsilon_ix = 1:num_epsilons
    plot(sqz_std_matrix_rings_e_constant(:,epsilon_ix)./1000)   % J
end
for epsilon_ix = 1:num_epsilons
    plot(sqz_std_matrix_rings_e_decreasing(:,epsilon_ix)./1000) % J
end
xlabel('time [iterations]')
ylabel('\sigma [J]')
legend(legend_both_epsilons);
grid on

subplot(1,2,2)
hold on
for epsilon_ix = 1:num_epsilons
    cdfplot(([statistics_constant(:, epsilon_ix).iteration_optimal]));
end
for epsilon_ix = 1:num_epsilons
    cdfplot(([statistics_decreasing(:, epsilon_ix).iteration_optimal]));
end
xlabel('time [iterations]')
ylabel('CDF(i_{opt})')
legend(legend_both_epsilons);
grid on
