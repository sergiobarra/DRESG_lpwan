% Display some parameters per console
disp('Results GREEDY CONSTANT:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])
    
    % Statistics
    actions_selected_constant_mean = actions_history_constant_mean(epsilon_ix,:,1)';
    most_picked_action_constant_mean = mode(actions_selected_constant_mean);
    
    num_unexplored_actions_constant_mean = mean(num_unexplored_actions_constant(:,epsilon_ix));
    num_explored_actions_constant_mean = num_possible_actions - num_unexplored_actions_constant_mean;
    
    disp(['  · Num. of explored actions: ' num2str(num_explored_actions_constant_mean) '/' num2str(num_possible_actions)])
    disp(['  · Num. of unexplored actions: ' num2str(num_unexplored_actions_constant_mean) '/' num2str(num_possible_actions)])
    disp(['  · Iteration where optimal action was found: ' num2str(iteration_opt_constant_mean(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['  · Iteration where all actions were tried: ' num2str(iteration_all_actions_explored_constant_mean(epsilon_ix)) '/' num2str(num_iterations)])
    
end

disp('Results GREEDY DECREASING:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])
    
    % Statistics
    actions_selected_decreasing_mean = actions_history_decreasing_mean(epsilon_ix,:,1)';
    most_picked_ation_decreasing_mean = mode(actions_selected_decreasing_mean);
    
    num_unexplored_actions_decreasing_mean = mean(num_unexplored_actions_decreasing(:,epsilon_ix));
    num_explored_actions_decreasing_mean = num_possible_actions - num_unexplored_actions_decreasing_mean;
    
    disp(['  · Num. of explored actions: ' num2str(num_explored_actions_decreasing_mean) '/' num2str(num_possible_actions)])
    disp(['  · Num. of unexplored actions: ' num2str(num_unexplored_actions_decreasing_mean) '/' num2str(num_possible_actions)])
    disp(['  · Iteration where optimal action was found: ' num2str(iteration_opt_decreasing_mean(epsilon_ix)) '/' num2str(num_iterations)])
    disp(['  · Iteration where all actions were tried: ' num2str(iteration_all_actions_explored_decreasing_mean(epsilon_ix)) '/' num2str(num_iterations)])
  
end

% Plot evolution of consumption (should decrease with time)


for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
end

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', (actions_history_constant_mean(epsilon_ix,:,2))');
end
title('Learning with CONSTANT \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_constant);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', (actions_history_decreasing_mean(epsilon_ix,:,2))');
end
title('Learning with DECREASING \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_decreasing);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', (actions_history_constant_mean(epsilon_ix,:,2))');
end
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', (actions_history_decreasing_mean(epsilon_ix,:,2))');
end
title('Learning with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_both_epsilons);


figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', cumsum(actions_history_constant_mean(epsilon_ix,:,2))');
end
title('Consumption with CONSTANT \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_constant);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', cumsum(actions_history_decreasing_mean(epsilon_ix,:,2))');
end
title('Consumption with DECREASING \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_decreasing);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', cumsum(actions_history_constant_mean(epsilon_ix,:,2))');
end
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:num_iterations)', cumsum(actions_history_decreasing_mean(epsilon_ix,:,2))');
end
title('Consumption with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_both_epsilons);