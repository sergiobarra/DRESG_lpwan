function [ actions_history, reward_per_arm, iteration_optimal_action ] = ... 
        learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations, d_ring, aggregation_on,...
        epsilon_initial, epsilon_tunning_mode, optimal_action)
    %LEARN_OPTIMAL_ROUTING applies learning for identfying an optimal (or
    %pseudo-optimal) ring hops combination
    %   Detailed explanation goes here
    % Output:
    %   - actions_history: array containing the action, the bottleneck
    %   energy when performing such action, and the bottleneck ring.
    %   Elements: iteration x (action, e_bt, ring_bt)
    
    load('configuration.mat')

   

    num_possible_arms = size(set_of_ring_hops_combinations, 1);

    reward_per_arm = ones(1,num_possible_arms) .* -1;
    
    actions_history = zeros(max_num_iterations, 3); 

    iteration = 1;

    epsilon = epsilon_initial;
    
    iteration_optimal_action = 0;   % Iteration where optimal action was found
    
    disp(['    - learning optimal routing for epsilon ' num2str(epsilon_initial) ' and mode ' num2str(epsilon_tunning_mode)])
    while(iteration <= max_num_iterations) 
        
        %disp(['- iteration ' num2str(iteration)])

        % Pick a ring hops combination (i.e., arm)
        selected_arm = select_action_greedy(reward_per_arm, epsilon);
        
        if selected_arm == optimal_action && iteration_optimal_action == 0
            iteration_optimal_action = iteration;
        end
        
        ring_hops_combination = set_of_ring_hops_combinations(selected_arm,:);
                
        [btle_e, btle_ix, ~, ~, ~] = general_optimal_tx_conf(ring_hops_combination, aggregation_on, d_ring);
        
        % disp(['  · selected_arm: ' num2str(selected_arm) ' (' num2str(btle_e) ' mJ)'])

        reward = 1/btle_e;
        reward_per_arm(selected_arm) = reward;      

        actions_history(iteration, :) = [selected_arm btle_e btle_ix];
        
        switch epsilon_tunning_mode
            case EPSILON_GREEDY_STRATEGY
                epsilon = epsilon_initial;
            case EPSILON_GREEDY_DECREASING
                epsilon = epsilon_initial / sqrt(iteration);  
            otherwise
                error('Unkown epsilon-greedy tunning mode!')
        end
          
        % epsilon = epsilon_initial;
                
        if mod(iteration, max_num_iterations/10) == 0
            disp(['      · progress: ' num2str(floor(iteration*100 / max_num_iterations)) '%'])
        end
        
        % Increase the number of 'learning iterations' of a WLAN
        iteration = iteration + 1; 
        
    end
    
end

