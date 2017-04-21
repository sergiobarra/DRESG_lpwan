%% Load workspace if necessary
mat_filename = 'r3_c2_i1000_t1000.mat';
% Load just the required variables (avoid loading variables with high memory size)
load(mat_filename,'epsilon_initial','num_explored_actions_constant_mean','num_possible_actions',...
    'num_unexplored_actions_constant_mean','mean_iteration_optimal_constant','mean_iteration_all_constant',...
    'num_explored_actions_decreasing_mean', 'num_unexplored_actions_decreasing_mean',...
    'mean_iteration_optimal_decreasing', 'mean_iteration_all_decreasing','num_epsilons',...
    'max_cum_mean_rings_e_constant','max_cum_mean_rings_e_decreasing','num_rings','child_ratio',...
    'mean_btle_e_constant', 'mean_btle_e_decreasing','num_iterations')

%% Display results and plots

disp(' ')
% Display some parameters per console
disp('Results GREEDY CONSTANT:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])    
    disp(['  · Num. of explored actions: ' num2str(num_explored_actions_constant_mean) '/' num2str(num_possible_actions)])
    disp(['  · Num. of unexplored actions: ' num2str(num_unexplored_actions_constant_mean) '/' num2str(num_possible_actions)])
    disp(['  · Iteration where optimal action was found: ' num2str(mean_iteration_optimal_constant(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['  · Iteration where all actions were tried: ' num2str(mean_iteration_all_constant(epsilon_ix)) '/' num2str(num_iterations)])
    
end

disp(' ')
disp('Results GREEDY DECREASING:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])
    disp(['  · Num. of explored actions: ' num2str(num_explored_actions_decreasing_mean) '/' num2str(num_possible_actions)])
    disp(['  · Num. of unexplored actions: ' num2str(num_unexplored_actions_decreasing_mean) '/' num2str(num_possible_actions)])
    disp(['  · Iteration where optimal action was found: ' num2str(mean_iteration_optimal_decreasing(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['  · Iteration where all actions were tried: ' num2str(mean_iteration_all_decreasing(epsilon_ix)) '/' num2str(num_iterations)])
  
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

% % Actions histogram
% actions_selected_constant = actions_history(:,1)';
% 
% figure
% histogram(actions_selected_constant, num_possible_actions)
% title('Histogram of actions selected')
% xlabel('Action index')
% ylabel('Number of times picked')