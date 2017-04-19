
for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
end

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_constant(epsilon_ix,:,2))');
end
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_decreasing(epsilon_ix,:,2))');
end
title('Consumption with \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_both_epsilons);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_constant(epsilon_ix,:,2))');
end
title('Consumption with CONSTANT \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_both_epsilons);

figure
hold on
for epsilon_ix = 1:length(epsilon_initial)
    plot((1:max_num_iterations)', cumsum(actions_history_decreasing(epsilon_ix,:,2))');
end
title('Consumption with DECREASING \epsilon - greedy')
xlabel('time [iterations]')
ylabel('Cummulative bottleneck energy [mJ]')
legend(legend_both_epsilons);