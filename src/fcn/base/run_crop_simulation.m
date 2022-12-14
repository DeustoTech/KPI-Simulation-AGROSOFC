clear 
open_system('crop_simulation')
%%
recompile = false;
if recompile
    % Opcion de simulion para acelerar la simulacion 
    set_param('crop_simulation', 'MinimalZcImpactIntegration', 'on')
    set_param('crop_simulation','SimulationMode','normal')
    % Selecionamos el control PID para la generacion de la demanda de calor 
    % (emulamos la simulacion de Izaro, pero esta vez con los modelos desarrollados en HortiMED Modelling Platform)
    set_param('crop_simulation/Control Systems/Heater','LabelModeActiveChoice','PID')
end
%%
% Cargamos las senales exteriores, 
% Hours: Senal que nos da la hora del dia
% Si: Radiacion Exterior 
% vv: Velocidad del Viento
% HR: Humedad relativa exterior
% ChangeDay: Senal que me indica los cambios de dia. Con un valor de 1
%           siempre, mientras que si son las 24h tiene un valor de cero. 
%           Para ver una representacion grafica se puede ejecutar: 
% 
%                  plot(ChangeDay.time(1:400),ChangeDay.signals.values(1:400));xlabel('dias')

[Hours,tt,Si,vv,HR,ChangeDay] = LoadExternalClimate;
%%
% 
% Cargamos los parametros con la function set_pre_variables
% Para ver el contenido de la funcion LoadParameters escribe en la consola:
% 
%       >> open LoadParameters.m 
%
parameters = LoadParameters();

%
% Creamos un fichero que contiene los parameteros selecionados 
% text = printstruct(parameters,'printcontents', 1);
% writecell(text,'Parametros')
%
%% Simulation
% Numero de dias de simulacion
T = 365;

% Opcion de simulion para acelerar la simulacion 
set_param('crop_simulation','FastRestart','off')
set_param('crop_simulation', 'MinimalZcImpactIntegration', 'on')
set_param('crop_simulation','SimulationMode','accelerator')
%set_param('crop_simulation','FastRestart','on')

%% 
% Lanzamos la simulacion 
rl = sim('crop_simulation','StopTime','T');
%% 
% En esta variable se encuentra todo los resultados de las simulacion
result = parse_data_PID(rl);
%% 
% Utilizar esta funcion para ver alguna senales
simu.result = result;
simu.parameters = parameters;
plot_crop_sims_PID(simu);

%%
%load('rl')
%%
name_file = 'simulation_data.txt';
path_file = which(name_file);
path_file = replace(path_file,name_file,'');
%
base_simulation = simu;
save(fullfile(path_file,'..','base_simulation.mat'),'base_simulation')
