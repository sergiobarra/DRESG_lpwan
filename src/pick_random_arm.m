function [ picked_arm ] = pick_random_arm( reward_per_arm, only_unknown )
    %PICK_RANDOM_ARM Summary of this function goes here
    %   Detailed explanation goes here
    
    [reward, picked_arm] = datasample(reward_per_arm, 1);
    
    % OPTIMIZATION NEEDED FOR LARGER COMBINATIONS!
    if only_unknown
        unkown_elements = find(reward_per_arm == -1);
        if ~isempty(unkown_elements)
            picked_arm = datasample(unkown_elements, 1);
        end
    end
    
end

