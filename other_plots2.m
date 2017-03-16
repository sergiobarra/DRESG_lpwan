% Close open figures and clear variables
clc
clear
close all

x = 0:4;
y = x * 1000;
figure; hold on;
plot(x,y)
p=patch([0 4 4 0],[0 0 1000 1000],'r');
set(p,'FaceAlpha',0.4);
p=patch([4 4 6 6],[0 1000 1000 0],'g');
set(p,'FaceAlpha',0.4);
p=patch([6 6 10 10],[0 1000 1000 0],'y');
set(p,'FaceAlpha',0.4);
