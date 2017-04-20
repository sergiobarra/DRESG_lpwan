close all
clear
clc

load('configuration.mat')
% NEW LEARNING ---> To be placed in other file!

set_of_ring_hops_combinations = delta_combinations;
aggregation_on = true;
learning_approach = 0;

%% Learning configuration

num_trials = 1000;             % Number of trials for averaging
num_iterations = 1000;         % Number of learning iterations
epsilon_initial = [0.2 0.5 1];  % Learning tunning parameters
num_epsilons = length(epsilon_initial);
optimal_action = 1;         % Known optimal action (by main_analysis.m)
battery_energy = 10000;

num_possible_actions = size(set_of_ring_hops_combinations, 1);  % Number of possible paths

mat_filename = strcat('r', num2str(num_rings), '_c', num2str(child_ratio), '_i', num2str(num_iterations),...
    '_t', num2str(num_trials), '.mat');
    
disp('DRESG topology: ')
disp([' - Children ratio: ' num2str(child_ratio)]);
disp([' - Num. of rings: ' num2str(num_rings)]);
disp(['   · Num. of possible actions (i.e. paths) of the DRESG topology: ' num2str(num_possible_actions)]);

disp('Learning configuration: ')
disp([' - Num. of experiment repitions (i.e. trials): ' num2str(num_trials)]);
disp([' - Num. of learning iterations: ' num2str(num_iterations)]);
disp([' - Num. of algorithms to test: ' num2str(num_epsilons)]);



%% Compute learning algorithms

disp(' ')
disp('Computing learning algorithms: ')

for trial_ix = 1:num_trials
    
     disp(['- trial index ' num2str(trial_ix) '/' num2str(num_trials)]);
    
    for epsilon_ix = 1:length(epsilon_initial)

        %disp([' * epsilon index ' num2str(epsilon_ix) '/' num2str(length(epsilon_initial))]);

        % Epsilon-greedy constant
        epsilon_tunning_mode = EPSILON_GREEDY_CONSTANT;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action );
        
        all_action_history_constant{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_constant(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_constant(trial_ix, epsilon_ix) = statistics;
        
         % Epsilon-greedy constant
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action );
        
        all_action_history_decreasing{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing(trial_ix, epsilon_ix) = statistics;    
    
    end
    
end

%% Average results
% - Actions history
% - Statistics
% NOTE: reward per action is constant

sum_rings_e_constant = zeros(num_iterations, num_rings, num_epsilons);
sum_btle_e_constant = zeros(num_epsilons, num_iterations);

sum_rings_e_decreasing = zeros(num_iterations, num_rings, num_epsilons);
sum_btle_e_decreasing = zeros(num_epsilons, num_iterations);

sum_iteration_optimal_constant = zeros(1, num_epsilons);
sum_iteration_optimal_decreasing = zeros(1, num_epsilons);
sum_iteration_all_constant = zeros(1, num_epsilons);
sum_iteration_all_decreasing = zeros(1, num_epsilons);

% Get average
for epsilon_ix = 1:num_epsilons

    for iteration_ix = 1:num_iterations
            
        for trial_ix = 1:num_trials
        
            % energy per ring
            for ring_ix = 1:num_rings
            
                sum_rings_e_constant(iteration_ix, ring_ix, epsilon_ix) = sum_rings_e_constant(iteration_ix, ring_ix, epsilon_ix) + ... 
                    all_action_history_constant{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
            
                sum_rings_e_decreasing(iteration_ix, ring_ix, epsilon_ix) = sum_rings_e_decreasing(iteration_ix, ring_ix, epsilon_ix) + ... 
                    all_action_history_decreasing{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                
            end
            
            % botleneck energy
            sum_btle_e_constant(epsilon_ix, iteration_ix) = sum_btle_e_constant(epsilon_ix, iteration_ix) + ... 
                all_action_history_constant{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            
            sum_btle_e_decreasing(epsilon_ix, iteration_ix) = sum_btle_e_decreasing(epsilon_ix, iteration_ix) + ... 
                all_action_history_decreasing{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
                       
        end
        
    end

end

mean_rings_e_constant = sum_rings_e_constant / num_trials;    % IMPORTANT IS THIS
mean_btle_e_constant = sum_btle_e_constant / num_trials;

mean_rings_e_decreasing = sum_rings_e_decreasing / num_trials;    % IMPORTANT IS THIS
mean_btle_e_decreasing = sum_btle_e_decreasing / num_trials;

cum_mean_rings_e_constant = cumsum(mean_rings_e_constant);
max_cum_mean_rings_e_constant = zeros(num_epsilons, num_iterations);

cum_mean_rings_e_decreasing = cumsum(mean_rings_e_decreasing);
max_cum_mean_rings_e_decreasing = zeros(num_epsilons, num_iterations);

for epsilon_ix = 1:num_epsilons
    
    max_cum_mean_rings_e_constant(epsilon_ix, :) = max(cum_mean_rings_e_constant(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing(epsilon_ix, :) = max(cum_mean_rings_e_decreasing(:,:,epsilon_ix),[],2)';
    
end

for trial_ix = 1:num_trials
    
    for epsilon_ix = 1:num_epsilons
        num_unexplored_actions_constant(trial_ix, epsilon_ix) = length(find(reward_per_action_constant(trial_ix, epsilon_ix, :) == -1));
        num_unexplored_actions_decreasing(trial_ix, epsilon_ix) = length(find(reward_per_action_decreasing(trial_ix ,epsilon_ix, :) == -1));
        
        % statistics
        sum_iteration_optimal_constant(1, epsilon_ix) = sum_iteration_optimal_constant(1, epsilon_ix) + statistics_constant(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_constant(1, epsilon_ix) = sum_iteration_all_constant(1, epsilon_ix) + statistics_constant(trial_ix, epsilon_ix).iteration_explored;

        sum_iteration_optimal_decreasing(1, epsilon_ix) = sum_iteration_optimal_decreasing(1, epsilon_ix) + statistics_decreasing(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_decreasing(1, epsilon_ix) = sum_iteration_all_decreasing(1, epsilon_ix) + statistics_decreasing(trial_ix, epsilon_ix).iteration_explored;
    
    end        
    
end

mean_iteration_optimal_constant = sum_iteration_optimal_constant / num_trials;
mean_iteration_optimal_decreasing = sum_iteration_optimal_decreasing / num_trials;
mean_iteration_all_constant = sum_iteration_all_constant / num_trials;
mean_iteration_all_decreasing = sum_iteration_all_decreasing / num_trials;

num_unexplored_actions_constant_mean = mean(num_unexplored_actions_constant(:,epsilon_ix));
num_explored_actions_constant_mean = num_possible_actions - num_unexplored_actions_constant_mean;
num_unexplored_actions_decreasing_mean = mean(num_unexplored_actions_decreasing(:,epsilon_ix));
num_explored_actions_decreasing_mean = num_possible_actions - num_unexplored_actions_decreasing_mean;

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
title('Cummulated consumption of historic bottleneck with \epsilon - greedy')
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
title('Bottleneck energy with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Bottleneck energy [mJ]')
legend(legend_both_epsilons);

% figure
% hold on
% for epsilon_ix = 1:num_epsilons
%     
%     plot(max_cum_mean_rings_e(epsilon_ix,:))
%     
% end
% title('Lifetime historic bottleneck with \epsilon - greedy')
% xlabel('time [iterations]')
% ylabel(' [mJ]')
% legend(legend_constant);

% Call script for displaying results
%display_and_plot_learning


% % Actions histogram
% actions_selected_constant = actions_history(:,1)';
% 
% figure
% histogram(actions_selected_constant, num_possible_actions)
% title('Histogram of actions selected')
% xlabel('Action index')
% ylabel('Number of times picked')

save(mat_filename)