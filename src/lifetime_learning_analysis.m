
close all

mat_filename = 'C:\Users\UPF\Dropbox\Academia\PhD\Workspace\dresg_lpwan\src/results/r4_c8_i2000_t1000/output.mat';
% output_root_filename = 'results/r4_c8_i2000_t1000/';
% Load just the required variables (avoid loading variables with high memory size)
load(mat_filename,'epsilon_initial','num_explored_actions_constant_mean','num_possible_actions',...
    'num_unexplored_actions_constant_mean','mean_iteration_optimal_constant','mean_iteration_all_constant',...
    'num_explored_actions_decreasing_mean', 'num_unexplored_actions_decreasing_mean',...
    'mean_iteration_optimal_decreasing', 'mean_iteration_all_decreasing','num_epsilons',...
    'max_cum_mean_rings_e_constant','max_cum_mean_rings_e_decreasing','num_rings','child_ratio',...
    'mean_btle_e_constant', 'mean_btle_e_decreasing','num_iterations','statistics_constant','statistics_decreasing',...
    'num_trials','times_all_explored_constant','times_all_explored_decreasing','times_optimal_explored_decreasing',...
    'times_optimal_explored_constant')

energy_AAA = 5071;  % energy of AAA battery [J]
energy_AA = 9630;   % energy of AA battery [J]
energy_battery = 1 * energy_AA;

for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
end

% Consumption
figure
hold on
for epsilon_ix = 1:num_epsilons
    plot(energy_battery * 1000 - max_cum_mean_rings_e_constant(epsilon_ix,:))
end
for epsilon_ix = 1:num_epsilons
    plot(energy_battery * 1000 - max_cum_mean_rings_e_decreasing(epsilon_ix,:))
end
title_string = strcat('Lifetime with \epsilon - greedy (DRESG: R= ',...
    num2str(num_rings), ', c= ', num2str(child_ratio), ')');
title(title_string)
xlabel('time [iterations]')
ylabel('Lifetime [steps]')
legend(legend_both_epsilons);