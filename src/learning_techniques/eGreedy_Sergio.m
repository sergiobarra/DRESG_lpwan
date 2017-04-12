function [tpt_experienced_by_WLAN] = eGreedyMethod(wlan, MAX_CONVERGENCE_TIME, MAX_LEARNING_ITERATIONS, ...
                                                    initial_epsilon, actions_ch, actions_cca, actions_tpc, noise)


    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME            
  
    t = 1;

    while(t < MAX_CONVERGENCE_TIME+1) 

	    selected_arm = selectActionEGreedy(reward_per_configuration, epsilon);

	    bottleneck_energy = computeBottleneck(actions(selected_arm, :));

	    reward = 1/bottleneck_energy;    
	    reward_per_configuration(selected_arm) = reward;      

	    learning_iteration = learning_iteration + 1;

       
        power_matrix = PowerMatrix(wlan_aux);    
   
        epsilon = initial_epsilon / sqrt(t);    
        % Increase the number of 'learning iterations' of a WLAN
        t = t + 1; 
    
    end

    
    % Return the throughput experienced by each WLAN at each iteration
    % ...
    
end

