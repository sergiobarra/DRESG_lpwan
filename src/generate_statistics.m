
mat_filename = 'results/r3_c2_i500_t1000/output.mat';
% Load just the required variables (avoid loading variables with high memory size)
load(mat_filename,'epsilon_initial','num_explored_actions_constant_mean','num_possible_actions',...
    'all_action_history_constant','reward_per_action_constant','statistics_constant',...
    'all_action_history_decreasing', 'reward_per_action_decreasing','statistics_decreasing', 'save_mat_file')

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

max_ring_e_constant = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing = zeros(num_iterations, num_rings, num_epsilons);

% Get average
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
                
                % Pick maximum
                if max_ring_e_constant(iteration_ix, ring_ix, epsilon_ix) < e_aux_constant
                    max_ring_e_constant(iteration_ix, ring_ix, epsilon_ix) = e_aux_constant;
                end

                % Pick maximum
                if max_ring_e_decreasing(iteration_ix, ring_ix, epsilon_ix) < e_aux_decreasing
                    max_ring_e_decreasing(iteration_ix, ring_ix, epsilon_ix) = e_aux_decreasing;
                end
                
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

cum_max_ring_e_constant = cumsum(max_ring_e_constant);
max_cum_max_ring_e_constant = zeros(num_epsilons, num_iterations);

cum_mean_rings_e_decreasing = cumsum(mean_rings_e_decreasing);
max_cum_mean_rings_e_decreasing = zeros(num_epsilons, num_iterations);

cum_max_ring_e_decreasing = cumsum(max_ring_e_constant);
max_cum_max_ring_e_decreasing = zeros(num_epsilons, num_iterations);

num_unexplored_actions_constant = zeros(num_trials, num_epsilons);
num_unexplored_actions_decreasing = zeros(num_trials, num_epsilons);
times_all_explored_constant = zeros(num_epsilons, 1);
times_all_explored_decreasing = zeros(num_epsilons, 1);
times_optimal_explored_constant = zeros(num_epsilons, 1);
times_optimal_explored_decreasing = zeros(num_epsilons, 1);

for epsilon_ix = 1:num_epsilons
    
    max_cum_mean_rings_e_constant(epsilon_ix, :) = max(cum_mean_rings_e_constant(:,:,epsilon_ix),[],2)';
    
    max_cum_max_ring_e_constant(epsilon_ix, :) = max(cum_max_ring_e_constant(:,:,epsilon_ix),[],2)';
    
    max_cum_mean_rings_e_decreasing(epsilon_ix, :) = max(cum_mean_rings_e_decreasing(:,:,epsilon_ix),[],2)';
    
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

mean_iteration_optimal_constant = sum_iteration_optimal_constant / num_trials;
mean_iteration_optimal_decreasing = sum_iteration_optimal_decreasing / num_trials;
mean_iteration_all_constant = sum_iteration_all_constant / num_trials;
mean_iteration_all_decreasing = sum_iteration_all_decreasing / num_trials;

num_unexplored_actions_constant_mean = mean(num_unexplored_actions_constant(:,epsilon_ix));
num_explored_actions_constant_mean = num_possible_actions - num_unexplored_actions_constant_mean;
num_unexplored_actions_decreasing_mean = mean(num_unexplored_actions_decreasing(:,epsilon_ix));
num_explored_actions_decreasing_mean = num_possible_actions - num_unexplored_actions_decreasing_mean;

if save_mat_file
    mkdir(output_root_filename);
    filename_aux = strcat(output_root_filename, 'output.mat');
    save(filename_aux, '-v7.3')
    disp(['Results saved in file ' filename_aux])
end