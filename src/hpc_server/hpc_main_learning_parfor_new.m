% HPC file for parallelizing computation

nWorkers = 12;
parpool('local', nWorkers)

load('configuration.mat')

set_of_ring_hops_combinations = delta_combinations;     % Delta combinations
aggregation_on = true;                                  % Payload aggregation

%% Learning configuration

save_mat_file = true;                      % Save results flag for generating a .mat file
display_results = false;                     % Display results flag
num_trials = 1000;                            % Number of trials (i.e. simulations) for averaging purposes
num_iterations = 12000;                       % Number of learning iterations
epsilon_initial = [0.2 0.5 1];              % Learning tunning parameters
num_epsilons = length(epsilon_initial);     % Number of algorithms to run
optimal_action = 1;                         % Known optimal action (by main_analysis.m)

if ~save_mat_file
    warning('ATENTION: RESULTS WILL NOT BE SAVED IN A .MAT FILE!')
end

num_possible_actions = size(set_of_ring_hops_combinations, 1);  % Number of possible paths (i.e., arms or actions)

output_root_filename = strcat(pwd,'/results/r', num2str(num_rings), '_c', num2str(child_ratio), '_i', num2str(num_iterations),...
    '_t', num2str(num_trials), '/');

disp('DRESG topology: ')
disp([' - Children ratio: ' num2str(child_ratio)]);
disp([' - Num. of rings: ' num2str(num_rings)]);
disp(['   * Num. of possible actions (i.e. paths) of the DRESG topology: ' num2str(num_possible_actions)]);
disp([' - Num. of nodes: ' num2str(n_total)]);
disp([' - Optimal hops combination (obtained by main analysis): ' num2str(optimal_action)]);
disp(set_of_ring_hops_combinations(optimal_action,:))

disp('Learning configuration: ')
disp([' - Save .mat file? ' num2str(save_mat_file)]);
disp([' - Num. of experiment repitions (i.e. trials): ' num2str(num_trials)]);
disp([' - Num. of learning iterations: ' num2str(num_iterations)]);
disp([' - Num. of algorithms to test: ' num2str(num_epsilons)]);


%% Compute learning algorithms

tic     % For measuring Matlab's execution time

disp(' ')
disp('Computing learning algorithms: ')

% Array of structures containning the action history and corresponding energy values
% - 2 epsilon-greedy approaches: constant and decreasing
all_action_history_constant = cell(num_trials, num_epsilons);
all_action_history_decreasing = cell(num_trials, num_epsilons);

% Deterministic reward obtain by each action (i.e., arm)
reward_per_action_constant = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing = zeros(num_trials, num_epsilons, num_possible_actions);

% Statistics is a structure containing the mean optimal and all-explored iterations
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


%% Process experiments output and generate statistics

% Call file generate_statistics.m if prefered

% Sum of the energy consumed by each ring, in each iteration and each epsilon (for averaging purposes)
sum_rings_e_constant = zeros(num_iterations, num_rings, num_epsilons);
sum_rings_e_decreasing = zeros(num_iterations, num_rings, num_epsilons);

% Sum of the energy consumed by the bottleneck, in each iteration and each epsilon (for averaging purposes)
sum_btle_e_constant = zeros(num_epsilons, num_iterations);
sum_btle_e_decreasing = zeros(num_epsilons, num_iterations);

% Sum of the optimal iteration in each epsilon (for averaging purposes)
sum_iteration_optimal_constant = zeros(1, num_epsilons);
sum_iteration_optimal_decreasing = zeros(1, num_epsilons);

% Sum of the all-explored iteration in each epsilon (for averaging purposes)
sum_iteration_all_constant = zeros(1, num_epsilons);
sum_iteration_all_decreasing = zeros(1, num_epsilons);

% Max energy consumed by each ring in each iteration and epsilon (get max from all the trials)
max_ring_e_constant = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing = zeros(num_iterations, num_rings, num_epsilons);

matrix_rings_e_constant = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing = zeros(num_trials, num_iterations, num_rings, num_epsilons);

% Get average and maximum
for epsilon_ix = 1:num_epsilons

    for iteration_ix = 1:num_iterations

        for trial_ix = 1:num_trials

            % energy per ring
            for ring_ix = 1:num_rings

                e_aux_constant = all_action_history_constant{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing = all_action_history_decreasing{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                
                sum_rings_e_constant(iteration_ix, ring_ix, epsilon_ix) = sum_rings_e_constant(iteration_ix, ring_ix, epsilon_ix) + ...
                    e_aux_constant;
                sum_rings_e_decreasing(iteration_ix, ring_ix, epsilon_ix) = sum_rings_e_decreasing(iteration_ix, ring_ix, epsilon_ix) + ...
                    e_aux_decreasing;
                
                matrix_rings_e_constant(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_constant;
                matrix_rings_e_decreasing(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                    e_aux_decreasing;

                % Pick maximum
                if max_ring_e_constant(iteration_ix, ring_ix, epsilon_ix) < e_aux_constant
                    max_ring_e_constant(iteration_ix, ring_ix, epsilon_ix) = e_aux_constant;
                end
                if max_ring_e_decreasing(iteration_ix, ring_ix, epsilon_ix) < e_aux_decreasing
                    max_ring_e_decreasing(iteration_ix, ring_ix, epsilon_ix) = e_aux_decreasing;
                end

            end

            % botleneck energy
            e_btle_aux_constant = all_action_history_constant{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            e_btle_aux_decreasing = all_action_history_decreasing{trial_ix}{epsilon_ix}(iteration_ix).btle_e;

            sum_btle_e_constant(epsilon_ix, iteration_ix) = sum_btle_e_constant(epsilon_ix, iteration_ix) + ...
               e_btle_aux_constant;
            sum_btle_e_decreasing(epsilon_ix, iteration_ix) = sum_btle_e_decreasing(epsilon_ix, iteration_ix) + ...
                e_btle_aux_decreasing;

        end

    end

end

% Average energy consumed by each ring, in each iteration and each epsilon
mean_rings_e_constant = sum_rings_e_constant / num_trials;
mean_rings_e_decreasing = sum_rings_e_decreasing / num_trials;

% Cummulative sum of the average energy consumed by each ring, in each iteration and each epsilon
cum_mean_rings_e_constant = cumsum(mean_rings_e_constant);
cum_mean_rings_e_decreasing = cumsum(mean_rings_e_decreasing);

% Average energy consumed by the bottleneck, in each iteration and each epsilon
mean_btle_e_constant = sum_btle_e_constant / num_trials;
mean_btle_e_decreasing = sum_btle_e_decreasing / num_trials;

% Maximum cummulative consumption of the average energy consumed by each ring, in each iteration and each epsilon
max_cum_mean_rings_e_constant = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing = zeros(num_epsilons, num_iterations);

% Cummulative sum of the max energy consumed by each ring in each iteration and epsilon
cum_max_ring_e_constant = cumsum(max_ring_e_constant);
cum_max_ring_e_decreasing = cumsum(max_ring_e_decreasing);

% Maximum cummulative consumption of the max energy consumed by each ring in each iteration and epsilon
max_cum_max_ring_e_constant = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing = zeros(num_epsilons, num_iterations);

% Number of unexplored actions
num_unexplored_actions_constant = zeros(num_trials, num_epsilons);
num_unexplored_actions_decreasing = zeros(num_trials, num_epsilons);

% Number of trials where all-explored iteration reached
times_all_explored_constant = zeros(num_epsilons, 1);
times_all_explored_decreasing = zeros(num_epsilons, 1);

% Number of trials where optimal iteraiton reached
times_optimal_explored_constant = zeros(num_epsilons, 1);
times_optimal_explored_decreasing = zeros(num_epsilons, 1);

for epsilon_ix = 1:num_epsilons

    max_cum_mean_rings_e_constant(epsilon_ix, :) = max(cum_mean_rings_e_constant(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing(epsilon_ix, :) = max(cum_mean_rings_e_decreasing(:,:,epsilon_ix),[],2)';

    max_cum_max_ring_e_constant(epsilon_ix, :) = max(cum_max_ring_e_constant(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing(epsilon_ix, :) = max(cum_max_ring_e_decreasing(:,:,epsilon_ix),[],2)';

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

% Average iteration where optimal was found
mean_iteration_optimal_constant = sum_iteration_optimal_constant / num_trials;
mean_iteration_optimal_decreasing = sum_iteration_optimal_decreasing / num_trials;

% Average iteration where all actions were explored
mean_iteration_all_constant = sum_iteration_all_constant / num_trials;
mean_iteration_all_decreasing = sum_iteration_all_decreasing / num_trials;

% Average number of unexplored actions
num_unexplored_actions_constant_mean = mean(num_unexplored_actions_constant(:,epsilon_ix));
num_unexplored_actions_decreasing_mean = mean(num_unexplored_actions_decreasing(:,epsilon_ix));

% Average number of explored actions
num_explored_actions_constant_mean = num_possible_actions - num_unexplored_actions_constant_mean;
num_explored_actions_decreasing_mean = num_possible_actions - num_unexplored_actions_decreasing_mean;


% Standard deviation of the cummulative energy
cum_matrix_rings_e_constant = cumsum(matrix_rings_e_constant, 2);
cum_matrix_rings_e_decreasing = cumsum(matrix_rings_e_decreasing, 2);

max_cum_matrix_rings_e_constant = max(cum_matrix_rings_e_constant,[], 3);           % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing = max(cum_matrix_rings_e_decreasing,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)

sqz_max_cum_matrix_rings_e_constant = squeeze(max_cum_matrix_rings_e_constant); % Remove singleton dimensions ---> trial x iteration x epsilon
sqz_max_cum_matrix_rings_e_decreasing = squeeze(max_cum_matrix_rings_e_decreasing);

std_matrix_rings_e_constant = std(max_cum_matrix_rings_e_constant,0,1);
std_matrix_rings_e_decreasing = std(max_cum_matrix_rings_e_decreasing,0,1);

sqz_std_matrix_rings_e_constant = squeeze(std_matrix_rings_e_constant); % Remove singlenton dimension ---> iteration x epsilon
sqz_std_matrix_rings_e_decreasing = squeeze(std_matrix_rings_e_decreasing);


% Save workspace in a .mat file if required
if save_mat_file
%     mkdir(output_root_filename);
%     filename_aux = strcat(output_root_filename, 'output.mat');
    filename_aux = strcat('r', num2str(num_rings), '_c', num2str(child_ratio), '_i', num2str(num_iterations),...
    '_t', num2str(num_trials));
    save(filename_aux)
    disp(['Results saved in file ' filename_aux])
end

%% Display statistics and plot

% Call script for displaying results
% if display_results
%     disp('Displaying statistics and plotting results...')
%     display_and_plot_learning
% end

%% Finish
exec_time = toc;
disp(['Execution time: ' num2str(exec_time) ' s'])