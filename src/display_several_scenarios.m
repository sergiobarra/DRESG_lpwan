close all

% Load saved figures

filename_aux = strcat(pwd, '/results/r3_c2_500iterations_1000trials/consumption.fig');
consumption_a=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r3_c2_500iterations_1000trials/bottleneck.fig');
bottleneck_a=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r3_c2_500iterations_1000trials/cdf_optimal.fig');
cdf_optimal_a=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r3_c2_500iterations_1000trials/cdf_allexplored.fig');
cdf_allexplored_a=hgload(filename_aux);

filename_aux = strcat(pwd, '/results/r4_c8_2000iterations_1000trials/consumption.fig');
consumption_b=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r4_c8_2000iterations_1000trials/bottleneck.fig');
bottleneck_b=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r4_c8_2000iterations_1000trials/cdf_optimal.fig');
cdf_optimal_b=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r4_c8_2000iterations_1000trials/cdf_allexplored.fig');
cdf_allexplored_b=hgload(filename_aux);

filename_aux = strcat(pwd, '/results/r7_c3_20000iterations_25trials/consumption.fig');
consumption_c=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r7_c3_20000iterations_25trials/bottleneck.fig');
bottleneck_c=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r7_c3_20000iterations_25trials/cdf_optimal.fig');
cdf_optimal_c=hgload(filename_aux);
filename_aux = strcat(pwd, '/results/r7_c3_20000iterations_25trials/cdf_allexplored.fig');
cdf_allexplored_c=hgload(filename_aux);


epsilon_initial = [0.2 0.5 1];  % Learning tunning parameters

for epsilon_ix = 1:length(epsilon_initial)
    legend_constant{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_decreasing{epsilon_ix} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix} = strcat('\epsilon_{cnt}: ', num2str(epsilon_initial(epsilon_ix)));
    legend_both_epsilons{epsilon_ix + length(epsilon_initial)} = strcat('\epsilon_{dec}: ', num2str(epsilon_initial(epsilon_ix)));
end

% Prepare subplots
figure
h(1)=subplot(3,4,1,'LineWidth', 1);
h(2)=subplot(3,4,2,'LineWidth', 1);
h(3)=subplot(3,4,3,'LineWidth', 1);
h(4)=subplot(3,4,4,'LineWidth', 1);
h(5)=subplot(3,4,5,'LineWidth', 1);
h(6)=subplot(3,4,6,'LineWidth', 1);
h(7)=subplot(3,4,7,'LineWidth', 1);
h(8)=subplot(3,4,8,'LineWidth', 1);
h(9)=subplot(3,4,9,'LineWidth', 1);
h(10)=subplot(3,4,10,'LineWidth', 1);
h(11)=subplot(3,4,11,'LineWidth', 1);
h(12)=subplot(3,4,12,'LineWidth', 1);
% Paste figures on the subplots
copyobj(allchild(get(consumption_a,'CurrentAxes')),h(1));
copyobj(allchild(get(bottleneck_a,'CurrentAxes')),h(2));
copyobj(allchild(get(cdf_optimal_a,'CurrentAxes')),h(3));
copyobj(allchild(get(cdf_allexplored_a,'CurrentAxes')),h(4));

copyobj(allchild(get(consumption_b,'CurrentAxes')),h(5));
copyobj(allchild(get(bottleneck_b,'CurrentAxes')),h(6));
copyobj(allchild(get(cdf_optimal_b,'CurrentAxes')),h(7));
copyobj(allchild(get(cdf_allexplored_b,'CurrentAxes')),h(8));

copyobj(allchild(get(consumption_c,'CurrentAxes')),h(9));
copyobj(allchild(get(bottleneck_c,'CurrentAxes')),h(10));
copyobj(allchild(get(cdf_optimal_c,'CurrentAxes')),h(11));
copyobj(allchild(get(cdf_allexplored_c,'CurrentAxes')),h(12));

% Add legends
l(1)=legend(h(1),legend_both_epsilons)