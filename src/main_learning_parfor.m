
nWorkers = 12;
parpool('local', nWorkers)

load('configuration.mat')
% NEW LEARNING ---> To be placed in other file!

save_mat_file = true;           % Save results flag for generating a .mat file

set_of_ring_hops_combinations = delta_combinations;
aggregation_on = true;
learning_approach = 0;

%% Learning configuration

save_results = true;           % Save results flag for generating a .mat file
num_trials = 1000;             % Number of trials for averaging
num_iterations = 8000;         % Number of learning iterations
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
disp(['   * Num. of possible actions (i.e. paths) of the DRESG topology: ' num2str(num_possible_actions)]);
disp([' - Optimal hops combination (obtained by main analysis): ' num2str(optimal_action)]);
disp(set_of_ring_hops_combinations(optimal_action,:))

disp('Learning configuration: ')
disp([' - Save results? ' num2str(save_results)]);
disp([' - Num. of experiment repitions (i.e. trials): ' num2str(num_trials)]);
disp([' - Num. of learning iterations: ' num2str(num_iterations)]);
disp([' - Num. of algorithms to test: ' num2str(num_epsilons)]);

%% Compute learning algorithms

tic

disp(' ')
disp('Computing learning algorithms: ')

all_action_history_constant = cell(num_trials, num_epsilons);
all_action_history_decreasing = cell(num_trials, num_epsilons);

reward_per_action_constant = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing = zeros(num_trials, num_epsilons, num_possible_actions);

statistics_aux.iteration_optimal = 0;
statistics_aux.iteration_explored = 0;
statistics_constant(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing(1:num_trials, 1:num_epsilons) = statistics_aux;

nWorkers = 12;

parfor (trial_ix=1:num_trials, nWorkers)
    
    disp(['- trial index ' num2str(trial_ix) '/' num2str(num_trials)]);
    
    for epsilon_ix = 1:num_epsilons

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

%% Average results and statistics
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

mean_rings_e_constant = sum_rings_e_constant / num_trials;
mean_btle_e_constant = sum_btle_e_constant / num_trials;

mean_rings_e_decreasing = sum_rings_e_decreasing / num_trials;
mean_btle_e_decreasing = sum_btle_e_decreasing / num_trials;

cum_mean_rings_e_constant = cumsum(mean_rings_e_constant);
max_cum_mean_rings_e_constant = zeros(num_epsilons, num_iterations);

cum_mean_rings_e_decreasing = cumsum(mean_rings_e_decreasing);
max_cum_mean_rings_e_decreasing = zeros(num_epsilons, num_iterations);

num_unexplored_actions_constant = zeros(num_trials, num_epsilons);
num_unexplored_actions_decreasing = zeros(num_trials, num_epsilons);
times_all_explored_constant = zeros(num_epsilons, 1);
times_all_explored_decreasing = zeros(num_epsilons, 1);
times_optimal_explored_constant = zeros(num_epsilons, 1);
times_optimal_explored_decreasing = zeros(num_epsilons, 1);

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
    
        if statistics_constant(trial_ix, epsilon_ix).iteration_optimal ~= inf
            times_all_explored_constant(epsilon_ix) = times_all_explored_constant(epsilon_ix) + 1;
        end 
        
        if statistics_decreasing(trial_ix, epsilon_ix).iteration_optimal ~= inf
            times_all_explored_decreasing(epsilon_ix) = times_all_explored_decreasing(epsilon_ix) + 1;
        end
        
        if statistics_constant(trial_ix, epsilon_ix).iteration_explored ~= inf
            times_optimal_explored_constant(epsilon_ix) = times_optimal_explored_constant(epsilon_ix) + 1;
        end 
        
        if statistics_decreasing(trial_ix, epsilon_ix).iteration_explored ~= inf
            times_optimal_explored_decreasing(epsilon_ix) = times_optimal_explored_decreasing(epsilon_ix) + 1;
        end
        
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

if save_mat_file
    save(mat_filename, '-v7.3')
    disp(['Results saved in file ' filename_aux])
end

%% Finish
exec_time = toc;
disp(['Execution time: ' num2str(exec_time) ' s'])

delete(gcp('nocreate'))