%% Load workspace if necessary

% clear 
% close all
% clc
% 
% mat_filename = 'r7_c3_i20000_t25.mat';
% % Load just the required variables (avoid loading variables with high memory size)
% load(mat_filename,'epsilon_initial','num_explored_actions_constant_mean','num_possible_actions',...
%     'num_unexplored_actions_constant_mean','mean_iteration_optimal_constant','mean_iteration_all_constant',...
%     'num_explored_actions_decreasing_mean', 'num_unexplored_actions_decreasing_mean',...
%     'mean_iteration_optimal_decreasing', 'mean_iteration_all_decreasing','num_epsilons',...
%     'max_cum_mean_rings_e_constant','max_cum_mean_rings_e_decreasing','num_rings','child_ratio',...
%     'mean_btle_e_constant', 'mean_btle_e_decreasing','num_iterations','statistics_constant','statistics_decreasing',...
%     'num_trials','times_all_explored_constant','times_all_explored_decreasing')

%% Display results and plots

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

%% PLOTS

for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
end

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


%% CDFs

figure
hold on
for epsilon_ix = 1:num_epsilons
    cdfplot(([statistics_constant(:, epsilon_ix).iteration_optimal]));
end
for epsilon_ix = 1:num_epsilons
    cdfplot(([statistics_decreasing(:, epsilon_ix).iteration_optimal]));
end
title('CDF of the iteration where the optimal action is found')
xlabel('time [iterations]')
ylabel('F(X)')
legend(legend_both_epsilons);

figure
hold on
for epsilon_ix = 1:num_epsilons
    cdfplot(([statistics_constant(:, epsilon_ix).iteration_explored]));
end
for epsilon_ix = 1:num_epsilons
    cdfplot(([statistics_decreasing(:, epsilon_ix).iteration_explored]));
end
title('CDF of the iteration where all the actions are explored')
xlabel('time [iterations]')
ylabel('F(X)')
legend(legend_both_epsilons);

% % Actions histogram
% actions_selected_constant = actions_history(:,1)';
% 
% figure
% histogram(actions_selected_constant, num_possible_actions)
% title('Histogram of actions selected')
% xlabel('Action index')
% ylabel('Number of times picked')