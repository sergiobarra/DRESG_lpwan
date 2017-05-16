function [ selected_arm, epsilon_b ] = select_action_greedy (reward_per_arm, epsilon_a, similarity_on, similarity_matrix,...
        epsilon_b, epsilon_b_tunning_mode, iteration)
    %SELECT_ACTION_GREEDY Summary of this function goes here
    %   Detailed explanation goes here
       
    only_unknown = 1;
    
    [max_reward, ~]= max(reward_per_arm);
    
    %disp('   - reward_per_arm: ')
    %disp(reward_per_arm)
    
    random_value_a = rand();
    random_value_b = rand();
    
    % With probability epsilon select a new arm (or pick new arm if none is known)
    if random_value_a < epsilon_a || max_reward == -1
        
        % If first iteration (i.e., no action explored yet)
        if max_reward == -1
        
            %disp('   - Exploring first action')
            selected_arm = pick_random_arm(reward_per_arm, only_unknown);
        
        else
            %disp(['   - First epsilon layer: picking unexplored arm (' num2str(random_value_a) ' < ' num2str(epsilon_a) ')'])
            
            if ~similarity_on
            
                selected_arm = pick_random_arm(reward_per_arm, only_unknown);

            else

                % Pick random arm for the pool of unkown
                if random_value_b < epsilon_b

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
        
    switch epsilon_b_tunning_mode
        % case EPSILON_GREEDY_CONSTANT
        case 0
            % Do not change it
        %case EPSILON_GREEDY_DECREASING
        case 1
            epsilon_b = sqrt(epsilon_b/iteration);  
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

