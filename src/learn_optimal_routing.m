function [action_history, reward_per_arm, statistics ] = ... 
        learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations, d_ring, aggregation_on,...
        epsilon_initial, epsilon_tunning_mode, optimal_action )
    %LEARN_OPTIMAL_ROUTING applies learning for identfying an optimal (or
    %pseudo-optimal) ring hops combination
    %   Detailed explanation goes here
    % Output:
    %   - actions_history: array containing the action, the bottleneck
    %   energy when performing such action, and the bottleneck ring.
    %   - energy_history: array containing the action and the energy per
    %   ring.
    %   Elements: iteration x (action, e_bt, ring_bt)
    
    load('configuration.mat')

    num_possible_arms = size(set_of_ring_hops_combinations, 1);

    action_history = []; % Array of structures containning the action history and corresponding energy values
    reward_per_arm = ones(1,num_possible_arms) .* -1;
    % statistics = struct([]);
    iteration_optimal_action = 0;   % Iteration where optimal action was found
    iteration_all_actions_explored = 0;   % Iteration where optimal action was found
    
    %disp(['    - learning optimal routing for epsilon ' num2str(epsilon_initial) ' and mode ' num2str(epsilon_tunning_mode)])
    epsilon = epsilon_initial;
    iteration = 1;
    while(iteration <= max_num_iterations) 
        
        %disp(['- iteration ' num2str(iteration)])

        % Pick a ring hops combination (i.e., arm)
        selected_arm = select_action_greedy(reward_per_arm, epsilon);
        
        if selected_arm == optimal_action && iteration_optimal_action == 0
            iteration_optimal_action = iteration;
        end
        
        ring_hops_combination = set_of_ring_hops_combinations(selected_arm,:);
                
        [e, btle_e, btle_ix, ~, ~, ~] = general_optimal_tx_conf(ring_hops_combination, aggregation_on, d_ring);
        
        % disp(['  · selected_arm: ' num2str(selected_arm) ' (' num2str(btle_e) ' mJ)'])

        reward = 1/btle_e;
        reward_per_arm(selected_arm) = reward;
        
        unknown_actions = find(reward_per_arm == -1, 1);
        if isempty(unknown_actions) && iteration_all_actions_explored == 0
            iteration_all_actions_explored = iteration;
        end

        
        switch epsilon_tunning_mode
            case EPSILON_GREEDY_CONSTANT
                epsilon = epsilon_initial;
            case EPSILON_GREEDY_DECREASING
                epsilon = sqrt(epsilon_initial/iteration);  
            otherwise
                error('Unkown epsilon-greedy tunning mode!')
        end
          
        action_history(iteration).iteration = iteration;
        action_history(iteration).action = selected_arm;
        action_history(iteration).rings_e = e';
        action_history(iteration).btle_e = btle_e;
        action_history(iteration).btle_ix = btle_ix;
        
        statistics.iteration_optimal = iteration_optimal_action;
        statistics.iteration_explored = iteration_all_actions_explored;
                        
        if mod(iteration, max_num_iterations/10) == 0
            %disp(['      · progress: ' num2str(floor(iteration*100 / max_num_iterations)) '%'])
        end
        
        % Increase the number of 'learning iterations' of a WLAN
        iteration = iteration + 1; 
        
    end
    
end

