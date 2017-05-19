%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% - Learning extension
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%%
%%% File description: function for picking arms in an epsilon-greedy
%%% approach

function [ selected_arm, epsilon_s ] = select_action_greedy (reward_per_arm, epsilon, similarity_on, similarity_matrix,...
        epsilon_s, epsilon_s_tunning_mode, iteration)
    % SELECT_ACTION_GREEDY selects an arm following an epsilon-greedy
    % approach. If similarity is enabled, a 2nd epsilon layer is applied
    % for determining whether to pick a similar path to the best kwown one,
    % or to pick a random one.
    %   Input:
    %   - reward_per_arm: array containing the determinsitic reward obtained by each action (i.e., arm)
    %   - epsilon: 1st layer epsilon
    %   - similarity_on: flag for determining if similarity is applied
    %   - similarity_matrix: similarity matrix among possible hops combinations
    %   - epsilon_s: 2nd layer epsilon
    %   - epsilon_s_tunning_mode: 2nd layer epslion updating function type
    %   - iteration: current iteration of the experiment
    %   Output:
    %   - selected_arm: index of the picked action
    %   - epsilon_s: value of the 2nd layer epsilon after the last iteration
       
    only_unknown = 1;   % Pick only non-explored arms when exploring
    
    [max_reward, ~]= max(reward_per_arm);   % Maximum known reward
    
    %disp('   - reward_per_arm: ')
    %disp(reward_per_arm)
    
    random_value = rand();    % Random value for the 1st layer epsilon
    random_value_s = rand();    % Random value for the 2nd layer epsilon
    
    % With probability epsilon select a new arm (or pick new arm if none is known)
    if random_value < epsilon || max_reward == -1
        
        % If first iteration (i.e., no action explored yet - coded with "-1")
        if max_reward == -1 
        
            %disp('   - Exploring first action')
            selected_arm = pick_random_arm(reward_per_arm, only_unknown);
        
        else
            %disp(['   - First epsilon layer: picking unexplored arm (' num2str(random_value_a) ' < ' num2str(epsilon_a) ')'])
            
            if ~similarity_on
            
                selected_arm = pick_random_arm(reward_per_arm, only_unknown);

            else

                % Pick random arm for the pool of unkown
                if random_value_s < epsilon_s

                    %disp(['      * Second epsilon layer: pick RANDOM arm from the pool of unkown (' num2str(random_value_b) ' < ' num2str(epsilon_b) ')'])

                    selected_arm = pick_random_arm(reward_per_arm, only_unknown);

                % Pick arm similar to the best kwown one
                else
                    %disp(['      * Second epsilon layer: pick arm SIMILAR to the best kwown one (' num2str(random_value_b) ' >= ' num2str(epsilon_b) ')'])
                    % If there is more than one best known arm
                    %disp('      - array_best_known_arms: ')
                    array_best_known_arms = find(reward_per_arm == max_reward);
                    %disp(array_best_known_arms)
                    random_best_arm_ix = ceil(rand(1)*length(array_best_known_arms));
                    best_known_arm = array_best_known_arms(random_best_arm_ix);
                    %disp(['          * picked best known arm: ' num2str(best_known_arm)])

                    % Identify unkwnown arms that are most similar to the best known arm
                    %unkwnown_similar_arms
                    [~, ixs_unknown_elements] = find(reward_per_arm == -1);
                    
                    %disp('          * ixs_unkown_elements')
                    %disp(ixs_unknown_elements)
                    
                    if ~isempty(ixs_unknown_elements)
                        min_distance_to_unkown_arm = min((similarity_matrix(best_known_arm,ixs_unknown_elements)));
                        %disp(['          * min_distance_to_unkown_arm: ' num2str(min_distance_to_unkown_arm)])
                        unkwnown_similar_arms_ixs = similarity_matrix(best_known_arm, ixs_unknown_elements) == min_distance_to_unkown_arm;
                        %disp('          * unkwnown_similar_arms_ixs')
                        %disp(unkwnown_similar_arms_ixs)
                        unkwnown_similar_arms = ixs_unknown_elements(unkwnown_similar_arms_ixs);
                        %disp('          * unkwnown_similar_arms')
                        %disp(unkwnown_similar_arms)
                        
                        random_next_arm_ix = ceil(rand(1)*length(unkwnown_similar_arms));
                        %disp(['          * random_next_arm_ix: ' num2str(random_next_arm_ix) '/' num2str(length(unkwnown_similar_arms_ixs))])
                        similar_arm = unkwnown_similar_arms(random_next_arm_ix);
                        %disp(['          * similar_arm: ' num2str(similar_arm)])
                        selected_arm = similar_arm;
                    else
                        selected_arm = best_known_arm;
                    end
                    
                end

            end
        end
        
    switch epsilon_s_tunning_mode
        % case EPSILON_GREEDY_CONSTANT
        case 0
            % Do not change it
        %case EPSILON_GREEDY_DECREASING
        case 1
            epsilon_s = sqrt(epsilon_s/iteration);  
        otherwise
            error('Unkown epsilon-greedy tunning mode!')
    end
        
    
    % With probability 1 - epsilon pick the best known arm
    else
        %disp(['   - First epsilon layer: picking BEST KNOWN arm (' num2str(random_value_a) ' >= ' num2str(epsilon_a) ')'])
        % If there is more than one best known arm
        %disp('   - array_best_known_arms: ')
        array_best_known_arms = find(reward_per_arm == max_reward);
        %disp(array_best_known_arms)
        random_best_arm_ix = ceil(rand(1)*length(array_best_known_arms));
        %disp(['   - random_best_arm_ix: ' num2str(random_best_arm_ix) '/' num2str(length(array_best_known_arms))])
        best_known_arm = array_best_known_arms(random_best_arm_ix);
        selected_arm = best_known_arm;        
    end
    
    %disp(['   - selected_arm: ' num2str(selected_arm)])
    
end

