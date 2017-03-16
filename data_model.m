clc
clear
close all

t = 0:1:48;
t = t';
flies = [0 0 0 0 0 0 0 1 1 2 4 4 5 5 5 7 8 7 6 4 2 1 0 0 0 0 0 0 0 0 0 1 1 2 4 4 5 5 5 7 8 7 6 4 2 1 0 0 0]';
foo = fit(t,flies, 'sin6');
scatter(t,flies, 'filled');

hold on
% plot(foo)

x = 1:1:49;
flies_aprox = 5.554*sin(0.05985*x-0.02901) + 3.42*sin( 0.2649*x+-2.387) + 3.11*sin(0.08977*x+2.312) + 0.9751*sin(0.5218*x+-0.3499) + 0.6958*sin(0.784*x+0.5572) +  0.3884*sin(1.056*x+2.595);
plot(flies_aprox)
title('Data model');
legend('E[flies]', 'Predictor','Location','northwest');
xlabel('Daytime (h)')
ylabel('Num. of flies')
grid_on();

xlim([0 48]);
ylim([0 9]);




