times_all_explored_constant = zeros(num_epsilons, 1);
times_all_explored_decreasing = zeros(num_epsilons, 1);
times_optimal_explored_constant = zeros(num_epsilons, 1);
times_optimal_explored_decreasing = zeros(num_epsilons, 1);

for trial_ix = 1:num_trials
    
    for epsilon_ix = 1:num_epsilons
        num_unexplored_actions_constant(trial_ix, epsilon_ix) = length(find(reward_per_action_constant(trial_ix, epsilon_ix, :) == -1));
        num_unexplored_actions_decreasing(trial_ix, epsilon_ix) = length(find(reward_per_action_decreasing(trial_ix ,epsilon_ix, :) == -1));

        % statistics
        sum_iteration_optimal_constant(1, epsilon_ix) = sum_iteration_optimal_constant(1, epsilon_ix) + statistics_constant(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_constant(1, epsilon_ix) = sum_iteration_all_constant(1, epsilon_ix) + statistics_constant(trial_ix, epsilon_ix).iteration_explored;

        sum_iteration_optimal_decreasing(1, epsilon_ix) = sum_iteration_optimal_decreasing(1, epsilon_ix) + statistics_decreasing(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_decreasing(1, epsilon_ix) = sum_iteration_all_decreasing(1, epsilon_ix) + statistics_decreasing(trial_ix, epsilon_ix).iteration_explored;

        if statistics_constant(trial_ix, epsilon_ix).iteration_optimal == 0
            statistics_constant(trial_ix, epsilon_ix).iteration_optimal = inf;
        end 

        if statistics_decreasing(trial_ix, epsilon_ix).iteration_optimal == 0
            statistics_decreasing(trial_ix, epsilon_ix).iteration_optimal  = inf;
        end

        if statistics_constant(trial_ix, epsilon_ix).iteration_explored == 0
            statistics_constant(trial_ix, epsilon_ix).iteration_explored = inf;
        end 

        if statistics_decreasing(trial_ix, epsilon_ix).iteration_explored == 0
            statistics_decreasing(trial_ix, epsilon_ix).iteration_explored = inf;
        end
        
        if statistics_constant(trial_ix, epsilon_ix).iteration_optimal == 0
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