clear
%
load('rl365_2.mat')
%
% En esta variable se encuentra todo los resultados de las simulacion
result = parse_data(rl);
%% 
parameters = LoadParameters();
% Utilizar esta funcion para ver alguna senales
plot_crop_sims;