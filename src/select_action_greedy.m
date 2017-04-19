function [ selected_arm ] = select_action_greedy (reward_per_arm, epsilon)
    %SELECT_ACTION_GREEDY Summary of this function goes here
    %   Detailed explanation goes here
    
    only_unknown = 1;
    
    [max_reward, ~]= max(reward_per_arm);
    
    %disp('   · reward_per_arm: ')
    %disp(reward_per_arm)
    %disp(['   · max_reward: ' num2str(max_reward)])
    
    random_value = rand();
    
    % With probability epsilon select a new arm
    if random_value < epsilon
        selected_arm = pick_random_arm(reward_per_arm, only_unknown);
    else
        % If there is more than one best known arm
        %disp('   · array_best_known_arms: ')
        array_best_known_arms = find(reward_per_arm == max_reward);
        %disp(array_best_known_arms)
        random_best_arm_ix = ceil(rand(1)*length(array_best_known_arms));
        %disp(['   · random_best_arm_ix: ' num2str(random_best_arm_ix) '/' num2str(length(array_best_known_arms))])
        selected_arm = array_best_known_arms(random_best_arm_ix);        
    end
    
    %disp(['   · selected_arm: ' num2str(selected_arm)])
    
end

