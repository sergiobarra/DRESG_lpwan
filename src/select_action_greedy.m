function [ selected_arm ] = selection_action_greedy (reward_per_arm, epsilon)
    %SELECT_ACTION_GREEDY Summary of this function goes here
    %   Detailed explanation goes here
    
    only_unknown = 1;
    
    [~, best_known_arm]= max(reward_per_arm);
    
    random_value = rand();
    
    % With probability epsilon select a new arm
    if random_value < epsilon
        selected_arm = pick_random_arm(reward_per_arm, only_unknown);
    else
        selected_arm = best_known_arm;
    end
    
end

