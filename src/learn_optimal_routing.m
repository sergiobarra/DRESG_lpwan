%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% - Learning extension
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%%
%%% File description: function for applying learning to identify
%%% energy-saving hops combinations. Modelled like an
%%% exploration/exploitation dilemma

function [action_history, reward_per_arm, statistics ] = ... 
        learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations, d_ring, aggregation_on,...
        epsilon_initial, epsilon_tunning_mode, optimal_action, similarity_on, epsilon_s_initial, epsilon_s_tunning_mode,...
        similarity_matrix)
    %LEARN_OPTIMAL_ROUTING applies learning for identfying an optimal (or
    %pseudo-optimal) ring hops combination
    % Input:
    %   - max_num_iterations: maximum number of iterations to observe
    %   - set_of_ring_hops_combinations: set of ring hops combinations (Delta)
    %   - d_ring: array representing the distance to the GW from each ring
    %   - aggregation_on: flag for determining if payload aggregation is activated
    %   - epsilon_initial: array of epsilon (1st layer) values
    %   - epsilon_tunning_mode: updating function type of 1st layer epsilon
    %   - optimal_action: known optimal action index (obtained through the brute-force algorithm in "main_analysis.m")
    %   - similarity_on: flag for determining if similarity (2nd layer epsilon_s is implemented)
    %   - epsilon_s_initial: initial value of epsilon_s
    %   - epsilon_s_tunning_mode: updating function type of 2nd layer epsilon
    %   - similarity_matrix: similarity matrix among possible hops combinations
    % Output:
    %   - actions_history: array of structures containning the action history and corresponding energy values for
    %     every epsilon. It contains the following parameters for each iteration:
    %       * iteration
    %       * action: or selected arm)
    %       * rings_e: energy consumed by the nodes in each ring
    %       * btle_e: bottleneck energy (energy consumed by the node consuming more energy)
    %       * btle_ix: ring containing the bottleneck
    %   - reward_per_arm: array containing the determinsitic reward obtained by each action (i.e., arm)
    %   - statistics: structure containing the mean optimal and all-explored iterations
    
    load('configuration.mat')    % Load configuration into local workspace

    num_possible_arms = size(set_of_ring_hops_combinations, 1); % Number of possible hops combinations
    action_history = [];
    reward_per_arm = ones(1,num_possible_arms) .* -1;

    iteration_optimal_action = 0;           % Iteration where optimal action was found
    iteration_all_actions_explored = 0;     % Iteration where all actions were explored
    
    %disp(['    - learning optimal routing for epsilon ' num2str(epsilon_initial) ' and mode ' num2str(epsilon_tunning_mode)])
    epsilon = epsilon_initial;
    epsilon_b = epsilon_s_initial;
    iteration = 1;
    
    while(iteration <= max_num_iterations) 
        
        %disp(['- iteration ' num2str(iteration)])

        % Pick a ring hops combination (i.e., arm)
        [selected_arm, epsilon_b] = select_action_greedy(reward_per_arm, epsilon, similarity_on, similarity_matrix,...
            epsilon_b, epsilon_s_tunning_mode, iteration);
        
        % If otpimal action found
        if selected_arm == optimal_action && iteration_optimal_action == 0
            iteration_optimal_action = iteration;
        end
        
        % Selected arm (hops combination)
        ring_hops_combination = set_of_ring_hops_combinations(selected_arm,:);
        [e, btle_e, btle_ix, ~, ~, ~] = general_optimal_tx_conf(ring_hops_combination, aggregation_on, d_ring);
        %disp(['      * selected_arm: ' num2str(selected_arm) ' (' num2str(btle_e) ' mJ)'])
        reward = 1/btle_e;  % reward of the selected action
        reward_per_arm(selected_arm) = reward;  % include reward of action in the array
        
        % If all actions were explored
        unknown_actions = find(reward_per_arm == -1, 1);
        if isempty(unknown_actions) && iteration_all_actions_explored == 0
            iteration_all_actions_explored = iteration;
        end
        
        % Update epsilon according to its updating function
        switch epsilon_tunning_mode
            case EPSILON_GREEDY_CONSTANT
                epsilon = epsilon_initial;
            case EPSILON_GREEDY_DECREASING
                epsilon = sqrt(epsilon_initial/iteration);  
            otherwise
                error('Unkown epsilon-greedy updating function!')
        end
          
        % Fill information about the current iteration in the action history
        action_history(iteration).iteration = iteration;
        action_history(iteration).action = selected_arm;
        action_history(iteration).rings_e = e';
        action_history(iteration).btle_e = btle_e;
        action_history(iteration).btle_ix = btle_ix;
        
        if iteration_optimal_action == 0
             statistics.iteration_optimal = inf;
        else
             statistics.iteration_optimal = iteration_optimal_action;
        end
        
        if iteration_all_actions_explored == 0
             statistics.iteration_explored = inf;
        else
             statistics.iteration_explored = iteration_all_actions_explored;
        end
     
        if mod(iteration, max_num_iterations/10) == 0
            %disp(['      ? progress: ' num2str(floor(iteration*100 / max_num_iterations)) '%'])
        end
        
        % Increase the number of 'learning iterations' of a WLAN
        iteration = iteration + 1; 
        
    end
    
end

