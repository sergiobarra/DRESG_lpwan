close all
clear
clc

load('configuration.mat')
% NEW LEARNING ---> To be placed in other file!
max_num_iterations = 300;
set_of_ring_hops_combinations = delta_combinations;
aggregation_on = true;
learning_approach = 0;

% Known optimal action (by main_analysis.m)
optimal_action = 1;

num_possible_actions = size(set_of_ring_hops_combinations, 1);  % Number of possible paths
    
disp('DRESG topology: ')
disp([' - Children ratio: ' num2str(child_ratio)]);
disp([' - Num. of rings: ' num2str(num_rings)]);
disp(['   · Num. of possible actions (i.e. paths): ' num2str(num_possible_actions)]);

 % Learning tunning parameters
epsilon_initial = [0.1 0.5 0.9];

disp(' ')
disp('Computing learning algorithms: ')

for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon index ' num2str(epsilon_ix) '/' num2str(length(epsilon_initial))]);
    
    epsilon_tunning_mode = EPSILON_GREEDY_STRATEGY;
    [actions_history_constant(epsilon_ix,:,:,:), reward_per_action_constant(epsilon_ix,:), iteration_opt_constant(epsilon_ix)] = ...
        learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations,...
        d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action );

    epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
    [actions_history_decreasing(epsilon_ix,:,:,:), reward_per_action_decreasing(epsilon_ix,:), iteration_opt_decreasing(epsilon_ix)] = ...
        learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations,...
        d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action );
    
end


% GREEDY CONSTANT statistics


% Display some parameters per console
disp('Results GREEDY CONSTANT:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])
    
    % Statistics
    actions_selected_constant = actions_history_constant(epsilon_ix,:,1)';
    most_picked_ation_constant = mode(actions_selected_constant);
    num_unexplored_actions_constant = length(find(reward_per_action_constant(epsilon_ix,:) == -1));
    num_explored_actions_constant = num_possible_actions - num_unexplored_actions_constant;
    
    disp(['  · Num. of explored actions: ' num2str(num_explored_actions_constant) '/' num2str(num_possible_actions)])
    disp(['  · Num. of unexplored actions: ' num2str(num_unexplored_actions_constant) '/' num2str(num_possible_actions)])
    disp(['  · Iteration where optimal action was found: ' num2str(iteration_opt_constant(epsilon_ix))])
    disp(['  · Most picked action: ' num2str(most_picked_ation_constant)])
    disp(set_of_ring_hops_combinations(most_picked_ation_constant, :))
  
end

disp('Results GREEDY DECREASING:')
for epsilon_ix = 1:length(epsilon_initial)
    
    disp(['- epsilon = ' num2str(epsilon_initial(epsilon_ix))])
    
    % Statistics
    actions_selected_decreasing = actions_history_decreasing(epsilon_ix,:,1)';
    most_picked_ation_decreasing = mode(actions_selected_decreasing);
    num_unexplored_actions_decreasing = length(find(reward_per_action_decreasing(epsilon_ix,:) == -1));
    num_explored_actions_decreasing = num_possible_actions - num_unexplored_actions_decreasing;
    
    disp(['  · Num. of explored actions: ' num2str(num_explored_actions_decreasing) '/' num2str(num_possible_actions)])
    disp(['  · Num. of unexplored actions: ' num2str(num_unexplored_actions_decreasing) '/' num2str(num_possible_actions)])
    disp(['  · Iteration where optimal action was found: ' num2str(iteration_opt_decreasing(epsilon_ix))])
    disp(['  · Most picked action: ' num2str(most_picked_ation_decreasing)])
    disp(set_of_ring_hops_combinations(most_picked_ation_decreasing, :))
  
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
    plot((1:max_num_iterations)', (actions_history_constant(epsilon_ix,:,2))');
end
title('Learning with CONSTANT \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_constant);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', (actions_history_decreasing(epsilon_ix,:,2))');
end
title('Learning with DECREASING \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_decreasing);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', (actions_history_constant(epsilon_ix,:,2))');
end
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', (actions_history_decreasing(epsilon_ix,:,2))');
end
title('Learning with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_both_epsilons);


figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_constant(epsilon_ix,:,2))');
end
title('Consumption with CONSTANT \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_constant);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_decreasing(epsilon_ix,:,2))');
end
title('Consumption with DECREASING \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_decreasing);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_constant(epsilon_ix,:,2))');
end
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_decreasing(epsilon_ix,:,2))');
end
title('Consumption with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_both_epsilons);

% % Actions histogram
% actions_selected_constant = actions_history(:,1)';
% 
% figure
% histogram(actions_selected_constant, num_possible_actions)
% title('Histogram of actions selected')
% xlabel('Action index')
% ylabel('Number of times picked')

save('learning.mat')