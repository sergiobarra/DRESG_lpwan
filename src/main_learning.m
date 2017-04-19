close all
clear
clc

load('configuration.mat')
% NEW LEARNING ---> To be placed in other file!
max_num_iterations = 100;
set_of_ring_hops_combinations = delta_combinations;
aggregation_on = true;
learning_approach = 0;

num_possible_actions = size(set_of_ring_hops_combinations, 1);  % Number of possible paths
    
disp(['- num_possible_arms ' num2str(num_possible_actions)]);

 % Learning tunning parameters
epsilon_initial = 0.8;
epsilon_tunning_mode = EPSILON_GREEDY_STRATEGY;

[actions_history, reward_per_action] = learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations,...
    d_ring, aggregation_on, epsilon_initial, epsilon_tunning_mode );


% Plot evolution of consumption (should decrease with time)
figure
plot((1:max_num_iterations)', (actions_history(:,2))');
title('Learning with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')

% Actions histogram
actions_selected = actions_history(:,1)';

figure
histogram(actions_selected, num_possible_actions)
title('Histogram of actions selected')
xlabel('Action index')
ylabel('Number of times picked')

% Statistics
most_picked_ation = mode(actions_selected);
num_unexplored_actions = length(find(reward_per_action == -1));
num_explored_actions = num_possible_actions - num_unexplored_actions;

% Display some parameters per console
disp('Results:')
disp(['- Most picked action: ' num2str(most_picked_ation)])
disp(set_of_ring_hops_combinations(most_picked_ation, :))
disp(['- Num. of explored actions: ' num2str(num_explored_actions)])
disp(['- Num. of unexplored actions: ' num2str(num_unexplored_actions)])

save('learning.mat')