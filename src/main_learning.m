close all
clear
clc

load('configuration.mat')
% NEW LEARNING ---> To be placed in other file!
max_num_iterations = 5000;
set_of_ring_hops_combinations = delta_combinations;
aggregation_on = false;
learning_approach = 0;

actions_history = learn_optimal_routing( max_num_iterations, set_of_ring_hops_combinations, aggregation_on, ...
    learning_approach, d_ring );

figure
plot((1:max_num_iterations)', (actions_history(:,2))');