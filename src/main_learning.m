%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% - Learning extension
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%%
%%% File description: Main script for running routing-efficient learning algorithms

close all
clear
clc

%%  SETUP
% NOTE: run 'set_configuration.m' script to generate the configuration .mat file

load('configuration.mat')    % Load configuration into local workspace

set_of_ring_hops_combinations = delta_combinations;     % Delta combinations
aggregation_on = true;                                  % Payload aggregation
save_mat_file = false;                                  % Save results flag for generating a .mat file
display_results = true;                                 % Display results flag
num_trials = 100;                                        % Number of trials (i.e. simulations) for averaging purposes
num_iterations = 30;                                    % Number of learning iterations
epsilon_initial = [0.2 1];                              % Learning tunning parameters
num_epsilons = length(epsilon_initial);                 % Number of algorithms to run
optimal_action = 1;                                     % Known optimal action (by main_analysis.m)

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

similarity_matrix_file = strcat(pwd,'/data/similarity_matrix_r',num2str(num_rings),'.mat');
load(similarity_matrix_file,'similarity_matrix')

%% LEARNING ALGORITHMS

tic     % For measuring Matlab's execution time

disp(' ')
disp('Computing learning algorithms: ')

% Array of structures containning the action history and corresponding energy values for every epsilon
% - 2 epsilon-greedy updating functions: constant and quadratically decreasing
% - If similarity implemented, a new layer (epsilon_b) is applied
% - E.g. "xxx_decreasing_similarity_decreasing_050" refers to a variable xxx corresponding to epsilon (1st layer) 
%   with constant updating function, and similarity ON with quadratically decreasing function on the 2nd layer
%   and initial value 0.50
all_action_history_constant = cell(num_trials, num_epsilons);   
all_action_history_decreasing = cell(num_trials, num_epsilons);
all_action_history_constant_similarity = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity_decreasing = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity_decreasing_0 = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity_decreasing_025 = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity_decreasing_050 = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity_decreasing_075 = cell(num_trials, num_epsilons);
all_action_history_decreasing_similarity_decreasing_1 = cell(num_trials, num_epsilons);

% Deterministic reward obtained by each action (i.e., arm)
reward_per_action_constant = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_constant_similarity = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity_decreasing = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity_decreasing_0 = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity_decreasing_025 = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity_decreasing_050 = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity_decreasing_075 = zeros(num_trials, num_epsilons, num_possible_actions);
reward_per_action_decreasing_similarity_decreasing_1 = zeros(num_trials, num_epsilons, num_possible_actions);

% Statistics is a structure containing the mean optimal and all-explored iterations
statistics_aux.iteration_optimal = 0;
statistics_aux.iteration_explored = 0;
statistics_constant(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_constant_similarity(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity_decreasing(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity_decreasing_0(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity_decreasing_025(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity_decreasing_050(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity_decreasing_075(1:num_trials, 1:num_epsilons) = statistics_aux;
statistics_decreasing_similarity_decreasing_1(1:num_trials, 1:num_epsilons) = statistics_aux;

% Perform num_trials observations
for trial_ix = 1:num_trials
    
     disp(['- trial index ' num2str(trial_ix) '/' num2str(num_trials)]);
    
    % Simulate for every 1st layer epsilon
    for epsilon_ix = 1:num_epsilons

        %disp([' * epsilon index ' num2str(epsilon_ix) '/' num2str(length(epsilon_initial))]);

        % ----------------- Epsilon-greedy CONSTANT with NO SIMILARITY -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_CONSTANT;     % Updating function of 1st layer epsilon
        similarity_on = false;                              % Similarity flag
        epsilon_s_initial = 0;                              % Intiail value of 2nd layer epsilon (similarity)
        epsilon_s_tunning_mode = EPSILON_GREEDY_CONSTANT;   % Updating function of 2nd layer epsilon (similarity)
        
        % Call learning function
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action, similarity_on,...
            epsilon_s_initial, epsilon_s_tunning_mode, similarity_matrix);
        
        % Array of structures containning the action history and corresponding energy values for every epsilon
        all_action_history_constant{trial_ix}{epsilon_ix} = action_history;
        % Deterministic reward obtained by each action (i.e., arm)
        reward_per_action_constant(trial_ix, epsilon_ix, :) = reward_per_arm;
        % Statistics is a structure containing the mean optimal and all-explored iterations
        statistics_constant(trial_ix, epsilon_ix) = statistics;
        
         % ----------------- Epsilon-greedy DECREASING with NO SIMILARITY -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = false;
        epsilon_s_initial = 0;
        epsilon_s_tunning_mode = EPSILON_GREEDY_CONSTANT;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action, similarity_on,...
            epsilon_s_initial, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing(trial_ix, epsilon_ix) = statistics;
        
        % ----------------- Epsilon-greedy CONSTANT with SIMILARITY CONSTANT -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_CONSTANT;
        similarity_on = true;
        epsilon_s_initial = 0;
        epsilon_s_tunning_mode = EPSILON_GREEDY_CONSTANT;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action, similarity_on,...
            epsilon_s_initial, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_constant_similarity{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_constant_similarity(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_constant_similarity(trial_ix, epsilon_ix) = statistics;
         
         % ----------------- Epsilon-greedy DECREASING with SIMILARITY CONSTANT -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_s_initial = 0.25;
        epsilon_s_tunning_mode = EPSILON_GREEDY_CONSTANT;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action, similarity_on,...
            epsilon_s_initial, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity(trial_ix, epsilon_ix) = statistics;

        % ----------------- Epsilon-greedy DECREASING with SIMILARITY DECREASING -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_b = 1;
        epsilon_s_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action,...
            similarity_on, epsilon_b, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity_decreasing{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity_decreasing(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity_decreasing(trial_ix, epsilon_ix) = statistics;
        
        % ----------------- Epsilon-greedy DECREASING with SIMILARITY DECREASING EPSILON_B = 0 -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_b = 0;
        epsilon_s_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action,...
            similarity_on, epsilon_b, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity_decreasing_0{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity_decreasing_0(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity_decreasing_0(trial_ix, epsilon_ix) = statistics;
        
        % ----------------- Epsilon-greedy DECREASING with SIMILARITY DECREASING EPSILON_B = 0.25 -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_b = 0.25;
        epsilon_s_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action,...
            similarity_on, epsilon_b, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity_decreasing_025{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity_decreasing_025(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity_decreasing_025(trial_ix, epsilon_ix) = statistics;
        
        % ----------------- Epsilon-greedy DECREASING with SIMILARITY DECREASING EPSILON_B = 0.50 -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_b = 0.5;
        epsilon_s_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action,...
            similarity_on, epsilon_b, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity_decreasing_050{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity_decreasing_050(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity_decreasing_050(trial_ix, epsilon_ix) = statistics;
        
        % ----------------- Epsilon-greedy DECREASING with SIMILARITY DECREASING EPSILON_B = 0.75 -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_b = 0.75;
        epsilon_s_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action,...
            similarity_on, epsilon_b, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity_decreasing_075{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity_decreasing_075(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity_decreasing_075(trial_ix, epsilon_ix) = statistics;
        
        % ----------------- Epsilon-greedy DECREASING with SIMILARITY DECREASING EPSILON_B = 1 -----------------
        epsilon_tunning_mode = EPSILON_GREEDY_DECREASING;
        similarity_on = true;
        epsilon_b = 1;
        epsilon_s_tunning_mode = EPSILON_GREEDY_DECREASING;
        
        [action_history, reward_per_arm, statistics ] = ... 
            learn_optimal_routing( num_iterations, set_of_ring_hops_combinations,...
            d_ring, aggregation_on, epsilon_initial(epsilon_ix), epsilon_tunning_mode, optimal_action,...
            similarity_on, epsilon_b, epsilon_s_tunning_mode, similarity_matrix);
        
        all_action_history_decreasing_similarity_decreasing_1{trial_ix}{epsilon_ix} = action_history;
        reward_per_action_decreasing_similarity_decreasing_1(trial_ix, epsilon_ix, :) = reward_per_arm;
        statistics_decreasing_similarity_decreasing_1(trial_ix, epsilon_ix) = statistics;
    
    end
    
end


%% PROCESS EXPERIMENTS' RESULTS

% Matrix representing the energy consumed in every trial, every iteration, every ring and every epsilon.
matrix_rings_e_constant = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_constant_similarity = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity_decreasing = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity_decreasing_0 = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity_decreasing_025 = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity_decreasing_050 = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity_decreasing_075 = zeros(num_trials, num_iterations, num_rings, num_epsilons);
matrix_rings_e_decreasing_similarity_decreasing_1 = zeros(num_trials, num_iterations, num_rings, num_epsilons);

% Matrix representing the energy consumed by the bottleneck ring in every trial, every iteration, and every epsilon.
matrix_btle_e_constant = zeros(num_trials, num_iterations, num_epsilons);
matrix_btle_e_decreasing = zeros(num_trials, num_iterations, num_epsilons);
matrix_btle_e_constant_similarity = zeros(num_trials, num_iterations, num_epsilons);
matrix_btle_e_decreasing_similarity = zeros(num_trials, num_iterations, num_epsilons);
matrix_btle_e_decreasing_similarity_decreasing = zeros(num_trials, num_iterations, num_epsilons);

% Max energy consumed by each ring in each iteration and epsilon (get max from all the trials)
max_ring_e_constant = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_constant_similarity  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity_decreasing  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity_decreasing_0  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity_decreasing_025  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity_decreasing_050  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity_decreasing_075  = zeros(num_iterations, num_rings, num_epsilons);
max_ring_e_decreasing_similarity_decreasing_1  = zeros(num_iterations, num_rings, num_epsilons);

% Convert cells to matrix for handling operations
for epsilon_ix = 1:num_epsilons

    for iteration_ix = 1:num_iterations
            
        for trial_ix = 1:num_trials

            % energy per ring
            for ring_ix = 1:num_rings
            
                e_aux_constant = all_action_history_constant{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing = all_action_history_decreasing{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_constant_similarity = all_action_history_constant_similarity{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity = all_action_history_decreasing_similarity{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity_decreasing = all_action_history_decreasing_similarity_decreasing{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity_decreasing_0 = all_action_history_decreasing_similarity_decreasing_0{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity_decreasing_025 = all_action_history_decreasing_similarity_decreasing_025{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity_decreasing_050 = all_action_history_decreasing_similarity_decreasing_050{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity_decreasing_075 = all_action_history_decreasing_similarity_decreasing_075{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);
                e_aux_decreasing_similarity_decreasing_1 = all_action_history_decreasing_similarity_decreasing_1{trial_ix}{epsilon_ix}(iteration_ix).rings_e(ring_ix);

                matrix_rings_e_constant(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_constant;
                matrix_rings_e_decreasing(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                    e_aux_decreasing;
                matrix_rings_e_constant_similarity(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_constant_similarity;
                matrix_rings_e_decreasing_similarity(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_decreasing_similarity;
                matrix_rings_e_decreasing_similarity_decreasing(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_decreasing_similarity_decreasing;
                matrix_rings_e_decreasing_similarity_decreasing_0(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_decreasing_similarity_decreasing_0;
                matrix_rings_e_decreasing_similarity_decreasing_025(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_decreasing_similarity_decreasing_025;
                matrix_rings_e_decreasing_similarity_decreasing_050(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                    e_aux_decreasing_similarity_decreasing_050;
                matrix_rings_e_decreasing_similarity_decreasing_075(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                    e_aux_decreasing_similarity_decreasing_075;
                matrix_rings_e_decreasing_similarity_decreasing_1(trial_ix, iteration_ix, ring_ix, epsilon_ix) = ...
                   e_aux_decreasing_similarity_decreasing_1;
               
%                 Pick maximum (TODO: it is not correct to pick the maximum
%                 mixing different trials!)
%                 if max_ring_e_constant(iteration_ix, ring_ix, epsilon_ix) < e_aux_constant
%                     max_ring_e_constant(iteration_ix, ring_ix, epsilon_ix) = e_aux_constant;
%                 end
%                 if max_ring_e_decreasing(iteration_ix, ring_ix, epsilon_ix) < e_aux_decreasing
%                     max_ring_e_decreasing(iteration_ix, ring_ix, epsilon_ix) = e_aux_decreasing;
%                 end
                
            end
            
            % botleneck energy
            e_btle_aux_constant = all_action_history_constant{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            e_btle_aux_decreasing = all_action_history_decreasing{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            e_btle_aux_constant_similarity = all_action_history_constant_similarity{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            e_btle_aux_decreasing_similarity = all_action_history_decreasing_similarity{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            e_btle_aux_decreasing_similarity_decreasing = all_action_history_decreasing_similarity_decreasing{trial_ix}{epsilon_ix}(iteration_ix).btle_e;
            
            matrix_btle_e_constant(trial_ix, iteration_ix, epsilon_ix) = e_btle_aux_constant;
            matrix_btle_e_decreasing(trial_ix, iteration_ix, epsilon_ix) = e_btle_aux_decreasing;
            matrix_btle_e_constant_similarity(trial_ix, iteration_ix, epsilon_ix) = e_btle_aux_constant_similarity;
            matrix_btle_e_decreasing_similarity(trial_ix, iteration_ix, epsilon_ix) = e_btle_aux_decreasing_similarity;
            matrix_btle_e_decreasing_similarity_decreasing(trial_ix, iteration_ix, epsilon_ix) = e_btle_aux_decreasing_similarity_decreasing;
                       
        end
        
    end

end

% Average energy consumed by each ring, in each iteration and each epsilon
mean_rings_e_constant = squeeze(mean(matrix_rings_e_constant,1));   % Perform average in dimension 1 (trials)
mean_rings_e_decreasing = squeeze(mean(matrix_rings_e_decreasing,1));
mean_rings_e_constant_similarity = squeeze(mean(matrix_rings_e_constant_similarity,1));   % Perform average in dimension 1 (trials)
mean_rings_e_decreasing_similarity = squeeze(mean(matrix_rings_e_decreasing_similarity,1));
mean_rings_e_decreasing_similarity_decreasing = squeeze(mean(matrix_rings_e_decreasing_similarity_decreasing,1));
mean_rings_e_decreasing_similarity_decreasing_0 = squeeze(mean(matrix_rings_e_decreasing_similarity_decreasing_0,1));
mean_rings_e_decreasing_similarity_decreasing_025 = squeeze(mean(matrix_rings_e_decreasing_similarity_decreasing_025,1));
mean_rings_e_decreasing_similarity_decreasing_050 = squeeze(mean(matrix_rings_e_decreasing_similarity_decreasing_050,1));
mean_rings_e_decreasing_similarity_decreasing_075 = squeeze(mean(matrix_rings_e_decreasing_similarity_decreasing_075,1));
mean_rings_e_decreasing_similarity_decreasing_1 = squeeze(mean(matrix_rings_e_decreasing_similarity_decreasing_1,1));

% Cummulative sum of the average energy consumed by each ring, in each iteration and each epsilon
cum_mean_rings_e_constant = cumsum(mean_rings_e_constant);
cum_mean_rings_e_decreasing = cumsum(mean_rings_e_decreasing);
cum_mean_rings_e_constant_similarity = cumsum(mean_rings_e_constant_similarity);
cum_mean_rings_e_decreasing_similarity = cumsum(mean_rings_e_decreasing_similarity);
cum_mean_rings_e_decreasing_similarity_decreasing = cumsum(mean_rings_e_decreasing_similarity_decreasing);
cum_mean_rings_e_decreasing_similarity_decreasing_0 = cumsum(mean_rings_e_decreasing_similarity_decreasing_0);
cum_mean_rings_e_decreasing_similarity_decreasing_025 = cumsum(mean_rings_e_decreasing_similarity_decreasing_025);
cum_mean_rings_e_decreasing_similarity_decreasing_050 = cumsum(mean_rings_e_decreasing_similarity_decreasing_050);
cum_mean_rings_e_decreasing_similarity_decreasing_075 = cumsum(mean_rings_e_decreasing_similarity_decreasing_075);
cum_mean_rings_e_decreasing_similarity_decreasing_1 = cumsum(mean_rings_e_decreasing_similarity_decreasing_1);

% Standard deviation of the cummulative energy
cum_matrix_rings_e_constant = cumsum(matrix_rings_e_constant, 2);
cum_matrix_rings_e_decreasing = cumsum(matrix_rings_e_decreasing, 2);
cum_matrix_rings_e_constant_similarity = cumsum(matrix_rings_e_constant_similarity, 2);
cum_matrix_rings_e_decreasing_similarity = cumsum(matrix_rings_e_decreasing_similarity, 2);
cum_matrix_rings_e_decreasing_similarity_decreasing = cumsum(matrix_rings_e_decreasing_similarity_decreasing, 2);
cum_matrix_rings_e_decreasing_similarity_decreasing_0 = cumsum(matrix_rings_e_decreasing_similarity_decreasing_0, 2);
cum_matrix_rings_e_decreasing_similarity_decreasing_025 = cumsum(matrix_rings_e_decreasing_similarity_decreasing_025, 2);
cum_matrix_rings_e_decreasing_similarity_decreasing_050 = cumsum(matrix_rings_e_decreasing_similarity_decreasing_050, 2);
cum_matrix_rings_e_decreasing_similarity_decreasing_075 = cumsum(matrix_rings_e_decreasing_similarity_decreasing_075, 2);
cum_matrix_rings_e_decreasing_similarity_decreasing_1 = cumsum(matrix_rings_e_decreasing_similarity_decreasing_1, 2);

max_cum_matrix_rings_e_constant = max(cum_matrix_rings_e_constant,[], 3);           % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing = max(cum_matrix_rings_e_decreasing,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_constant_similarity = max(cum_matrix_rings_e_constant_similarity,[], 3);           % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity = max(cum_matrix_rings_e_decreasing_similarity,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity_decreasing = max(cum_matrix_rings_e_decreasing_similarity_decreasing,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity_decreasing_0 = max(cum_matrix_rings_e_decreasing_similarity_decreasing_0,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity_decreasing_025 = max(cum_matrix_rings_e_decreasing_similarity_decreasing_025,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity_decreasing_050 = max(cum_matrix_rings_e_decreasing_similarity_decreasing_050,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity_decreasing_075 = max(cum_matrix_rings_e_decreasing_similarity_decreasing_075,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)
max_cum_matrix_rings_e_decreasing_similarity_decreasing_1 = max(cum_matrix_rings_e_decreasing_similarity_decreasing_1,[], 3);       % Pick bottleneck (max of ring, i.e., dimension 3)

sqz_max_cum_matrix_rings_e_constant = squeeze(max_cum_matrix_rings_e_constant); % Remove singleton dimensions ---> trial x iteration x epsilon
sqz_max_cum_matrix_rings_e_decreasing = squeeze(max_cum_matrix_rings_e_decreasing);
sqz_max_cum_matrix_rings_e_constant_similarity = squeeze(max_cum_matrix_rings_e_constant_similarity); % Remove singleton dimensions ---> trial x iteration x epsilon
sqz_max_cum_matrix_rings_e_decreasing_similarity = squeeze(max_cum_matrix_rings_e_decreasing_similarity);
sqz_max_cum_matrix_rings_e_decreasing_similarity_decreasing = squeeze(max_cum_matrix_rings_e_decreasing_similarity_decreasing);
sqz_max_cum_matrix_rings_e_decreasing_similarity_decreasing_0 = squeeze(max_cum_matrix_rings_e_decreasing_similarity_decreasing_0);
sqz_max_cum_matrix_rings_e_decreasing_similarity_decreasing_025 = squeeze(max_cum_matrix_rings_e_decreasing_similarity_decreasing_025);
sqz_max_cum_matrix_rings_e_decreasing_similarity_decreasing_050 = squeeze(max_cum_matrix_rings_e_decreasing_similarity_decreasing_050);
sqz_max_cum_matrix_rings_e_decreasing_similarity_decreasing_075 = squeeze(max_cum_matrix_rings_e_decreasing_similarity_decreasing_075);
sqz_max_cum_matrix_rings_e_decreasing_similarity_decreasing_1 = squeeze(max_cum_matrix_rings_e_decreasing_similarity_decreasing_1);

std_matrix_rings_e_constant = std(max_cum_matrix_rings_e_constant,0,1);
std_matrix_rings_e_decreasing = std(max_cum_matrix_rings_e_decreasing,0,1);
std_matrix_rings_e_constant_similarity = std(max_cum_matrix_rings_e_constant_similarity,0,1);
std_matrix_rings_e_decreasing_similarity = std(max_cum_matrix_rings_e_decreasing_similarity,0,1);
std_matrix_rings_e_decreasing_similarity_decreasing = std(max_cum_matrix_rings_e_decreasing_similarity_decreasing,0,1);

sqz_std_matrix_rings_e_constant = squeeze(std_matrix_rings_e_constant); % Remove singlenton dimension ---> iteration x epsilon
sqz_std_matrix_rings_e_decreasing = squeeze(std_matrix_rings_e_decreasing);
sqz_std_matrix_rings_e_constant_similarity = squeeze(std_matrix_rings_e_constant_similarity); % Remove singlenton dimension ---> iteration x epsilon
sqz_std_matrix_rings_e_decreasing_similarity = squeeze(std_matrix_rings_e_decreasing_similarity);
sqz_std_matrix_rings_e_decreasing_similarity_decreasing = squeeze(std_matrix_rings_e_decreasing_similarity_decreasing);

% Average energy consumed by the bottleneck, in each iteration and each epsilon
mean_btle_e_constant = squeeze(mean(matrix_btle_e_constant,1))';
mean_btle_e_decreasing = squeeze(mean(matrix_btle_e_decreasing,1))';
mean_btle_e_constant_similarity = squeeze(mean(matrix_btle_e_constant_similarity,1))';
mean_btle_e_decreasing_similarity = squeeze(mean(matrix_btle_e_decreasing_similarity,1))';
mean_btle_e_decreasing_similarity_decreasing = squeeze(mean(matrix_btle_e_decreasing_similarity_decreasing,1))';

% Cummulative sum of the max energy consumed by each ring in each iteration and epsilon
max_cum_mean_rings_e_constant = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_constant_similarity = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity_decreasing = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity_decreasing_0 = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity_decreasing_025 = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity_decreasing_050 = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity_decreasing_075 = zeros(num_epsilons, num_iterations);
max_cum_mean_rings_e_decreasing_similarity_decreasing_1 = zeros(num_epsilons, num_iterations);

cum_max_ring_e_constant = cumsum(max_ring_e_constant);
cum_max_ring_e_decreasing = cumsum(max_ring_e_decreasing);
cum_max_ring_e_constant_similarity = cumsum(max_ring_e_constant_similarity);
cum_max_ring_e_decreasing_similarity = cumsum(max_ring_e_decreasing_similarity);
cum_max_ring_e_decreasing_similarity_decreasing = cumsum(max_ring_e_decreasing_similarity_decreasing);
cum_max_ring_e_decreasing_similarity_decreasing_0 = cumsum(max_ring_e_decreasing_similarity_decreasing_0);
cum_max_ring_e_decreasing_similarity_decreasing_025 = cumsum(max_ring_e_decreasing_similarity_decreasing_025);
cum_max_ring_e_decreasing_similarity_decreasing_050 = cumsum(max_ring_e_decreasing_similarity_decreasing_050);
cum_max_ring_e_decreasing_similarity_decreasing_075 = cumsum(max_ring_e_decreasing_similarity_decreasing_075);
cum_max_ring_e_decreasing_similarity_decreasing_1 = cumsum(max_ring_e_decreasing_similarity_decreasing_1);

% Maximum cummulative consumption of the max energy consumed by each ring in each iteration and epsilon
max_cum_max_ring_e_constant = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_constant_similarity = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity_decreasing = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity_decreasing_0 = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity_decreasing_025 = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity_decreasing_050 = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity_decreasing_075 = zeros(num_epsilons, num_iterations);
max_cum_max_ring_e_decreasing_similarity_decreasing_1 = zeros(num_epsilons, num_iterations);

% Number of unexplored actions
num_unexplored_actions_constant = zeros(num_trials, num_epsilons);
num_unexplored_actions_decreasing = zeros(num_trials, num_epsilons);
num_unexplored_actions_constant_similarity = zeros(num_trials, num_epsilons);
num_unexplored_actions_decreasing_similarity = zeros(num_trials, num_epsilons);
num_unexplored_actions_decreasing_similarity_decreasing = zeros(num_trials, num_epsilons);

% Number of trials where all-explored iteration reached
times_all_explored_constant = zeros(num_epsilons, 1);
times_all_explored_decreasing = zeros(num_epsilons, 1);
times_all_explored_constant_similarity = zeros(num_epsilons, 1);
times_all_explored_decreasing_similarity = zeros(num_epsilons, 1);
times_all_explored_decreasing_similarity_decreasing = zeros(num_epsilons, 1);

% Number of trials where optimal iteraiton reached
times_optimal_explored_constant = zeros(num_epsilons, 1);
times_optimal_explored_decreasing = zeros(num_epsilons, 1);
times_optimal_explored_constant_similarity = zeros(num_epsilons, 1);
times_optimal_explored_decreasing_similarity = zeros(num_epsilons, 1);
times_optimal_explored_decreasing_similarity_decreasing = zeros(num_epsilons, 1);

for epsilon_ix = 1:num_epsilons
    
    max_cum_mean_rings_e_constant(epsilon_ix, :) = max(cum_mean_rings_e_constant(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing(epsilon_ix, :) = max(cum_mean_rings_e_decreasing(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_constant_similarity(epsilon_ix, :) = max(cum_mean_rings_e_constant_similarity(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity_decreasing(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity_decreasing(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity_decreasing_0(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity_decreasing_0(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity_decreasing_025(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity_decreasing_025(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity_decreasing_050(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity_decreasing_050(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity_decreasing_075(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity_decreasing_075(:,:,epsilon_ix),[],2)';
    max_cum_mean_rings_e_decreasing_similarity_decreasing_1(epsilon_ix, :) = max(cum_mean_rings_e_decreasing_similarity_decreasing_1(:,:,epsilon_ix),[],2)';

    max_cum_max_ring_e_constant(epsilon_ix, :) = max(cum_max_ring_e_constant(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing(epsilon_ix, :) = max(cum_max_ring_e_decreasing(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_constant_similarity(epsilon_ix, :) = max(cum_max_ring_e_constant_similarity(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity_decreasing(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity_decreasing(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity_decreasing_0(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity_decreasing_0(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity_decreasing_025(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity_decreasing_025(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity_decreasing_050(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity_decreasing_050(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity_decreasing_075(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity_decreasing_075(:,:,epsilon_ix),[],2)';
    max_cum_max_ring_e_decreasing_similarity_decreasing_1(epsilon_ix, :) = max(cum_max_ring_e_decreasing_similarity_decreasing_1(:,:,epsilon_ix),[],2)';

end

% Sum of the optimal iteration in each epsilon (for averaging purposes)
sum_iteration_optimal_constant = zeros(1, num_epsilons);
sum_iteration_optimal_decreasing = zeros(1, num_epsilons);
sum_iteration_optimal_constant_similarity = zeros(1, num_epsilons);
sum_iteration_optimal_decreasing_similarity = zeros(1, num_epsilons);
sum_iteration_optimal_decreasing_similarity_decreasing = zeros(1, num_epsilons);

% Sum of the all-explored iteration in each epsilon (for averaging purposes)
sum_iteration_all_constant = zeros(1, num_epsilons);
sum_iteration_all_decreasing = zeros(1, num_epsilons);
sum_iteration_all_constant_similarity = zeros(1, num_epsilons);
sum_iteration_all_decreasing_similarity = zeros(1, num_epsilons);
sum_iteration_all_decreasing_similarity_decreasing = zeros(1, num_epsilons);

for trial_ix = 1:num_trials
    
    for epsilon_ix = 1:num_epsilons
        
        num_unexplored_actions_constant(trial_ix, epsilon_ix) = length(find(reward_per_action_constant(trial_ix, epsilon_ix, :) == -1));
        num_unexplored_actions_decreasing(trial_ix, epsilon_ix) = length(find(reward_per_action_decreasing(trial_ix ,epsilon_ix, :) == -1));
        num_unexplored_actions_constant_similarity(trial_ix, epsilon_ix) = length(find(reward_per_action_constant_similarity(trial_ix, epsilon_ix, :) == -1));
        num_unexplored_actions_decreasing_similarity(trial_ix, epsilon_ix) = length(find(reward_per_action_decreasing_similarity(trial_ix ,epsilon_ix, :) == -1));
        num_unexplored_actions_decreasing_similarity_decreasing(trial_ix, epsilon_ix) = length(find(reward_per_action_decreasing_similarity_decreasing(trial_ix ,epsilon_ix, :) == -1));

        % statistics
        sum_iteration_optimal_constant(1, epsilon_ix) = sum_iteration_optimal_constant(1, epsilon_ix) + statistics_constant(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_constant(1, epsilon_ix) = sum_iteration_all_constant(1, epsilon_ix) + statistics_constant(trial_ix, epsilon_ix).iteration_explored;
        sum_iteration_optimal_constant_similarity(1, epsilon_ix) = sum_iteration_optimal_constant_similarity(1, epsilon_ix) + statistics_constant_similarity(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_constant_similarity(1, epsilon_ix) = sum_iteration_all_constant_similarity(1, epsilon_ix) + statistics_constant_similarity(trial_ix, epsilon_ix).iteration_explored;

        sum_iteration_optimal_decreasing(1, epsilon_ix) = sum_iteration_optimal_decreasing(1, epsilon_ix) + statistics_decreasing(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_decreasing(1, epsilon_ix) = sum_iteration_all_decreasing(1, epsilon_ix) + statistics_decreasing(trial_ix, epsilon_ix).iteration_explored;
        sum_iteration_optimal_decreasing_similarity(1, epsilon_ix) = sum_iteration_optimal_decreasing_similarity(1, epsilon_ix) + statistics_decreasing_similarity(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_decreasing_similarity(1, epsilon_ix) = sum_iteration_all_decreasing_similarity(1, epsilon_ix) + statistics_decreasing_similarity(trial_ix, epsilon_ix).iteration_explored;
        
        sum_iteration_optimal_decreasing_similarity_decreasing(1, epsilon_ix) = sum_iteration_optimal_decreasing_similarity_decreasing(1, epsilon_ix) + statistics_decreasing_similarity_decreasing(trial_ix, epsilon_ix).iteration_optimal;
        sum_iteration_all_decreasing_similarity_decreasing(1, epsilon_ix) = sum_iteration_all_decreasing_similarity_decreasing(1, epsilon_ix) + statistics_decreasing_similarity_decreasing(trial_ix, epsilon_ix).iteration_explored;

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
mean_iteration_optimal_constant_similarity = sum_iteration_optimal_constant_similarity / num_trials;
mean_iteration_optimal_decreasing_similarity = sum_iteration_optimal_decreasing_similarity / num_trials;
mean_iteration_optimal_decreasing_similarity_decreasing = sum_iteration_optimal_decreasing_similarity_decreasing / num_trials;

% Average iteration where all actions were explored
mean_iteration_all_constant = sum_iteration_all_constant / num_trials;
mean_iteration_all_decreasing = sum_iteration_all_decreasing / num_trials;
mean_iteration_all_constant_similarity = sum_iteration_all_constant_similarity / num_trials;
mean_iteration_all_decreasing_similarity = sum_iteration_all_decreasing_similarity / num_trials;
mean_iteration_all_decreasing_similarity_decreasing = sum_iteration_all_decreasing_similarity_decreasing / num_trials;

% Average number of unexplored actions
num_unexplored_actions_constant_mean = mean(num_unexplored_actions_constant(:,epsilon_ix));
num_unexplored_actions_decreasing_mean = mean(num_unexplored_actions_decreasing(:,epsilon_ix));
num_unexplored_actions_constant_mean_similarity = mean(num_unexplored_actions_constant_similarity(:,epsilon_ix));
num_unexplored_actions_decreasing_mean_similarity = mean(num_unexplored_actions_decreasing_similarity(:,epsilon_ix));
num_unexplored_actions_decreasing_mean_similarity_decreasing = mean(num_unexplored_actions_decreasing_similarity_decreasing(:,epsilon_ix));

% Average number of explored actions
num_explored_actions_constant_mean = num_possible_actions - num_unexplored_actions_constant_mean;
num_explored_actions_decreasing_mean = num_possible_actions - num_unexplored_actions_decreasing_mean;
num_explored_actions_constant_mean_similarity = num_possible_actions - num_unexplored_actions_constant_mean_similarity;
num_explored_actions_decreasing_mean_similarity = num_possible_actions - num_unexplored_actions_decreasing_mean_similarity;
num_explored_actions_decreasing_mean_similarity_decreasing = num_possible_actions - num_unexplored_actions_decreasing_mean_similarity_decreasing;

% Save workspace in a .mat file if required
if save_mat_file
    mkdir(output_root_filename);
    filename_aux = strcat(output_root_filename, 'output.mat');
    save(filename_aux)
    disp(['Results saved in file ' filename_aux])
end

%% Display statistics and plot

% Call script for displaying results
if display_results
    disp('Displaying statistics and plotting results...')
    display_and_plot_learning
end

%% Finish
exec_time = toc;
disp(['Execution time: ' num2str(exec_time) ' s'])