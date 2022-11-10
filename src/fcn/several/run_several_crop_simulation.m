clear 
load_system('crop_simulation')
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
%T = 365;
T = 365;
%T = 120;
recompile = true;
if recompile
    % Opcion de simulion para acelerar la simulacion 
    set_param('crop_simulation', 'MinimalZcImpactIntegration', 'on')
    set_param('crop_simulation','FastRestart','off')

    set_param('crop_simulation','SimulationMode','accelerator')
    % Selecionamos el control PID para la generacion de la demanda de calor 
    % (emulamos la simulacion de Izaro, pero esta vez con los modelos desarrollados en HortiMED Modelling Platform)
    set_param('crop_simulation/Control Systems/Heater','LabelModeActiveChoice','PID')
    set_param('crop_simulation','SimulationMode','accelerator')
    set_param('crop_simulation','FastRestart','on')

end
%% Create a span of parameters
nTref = 10;
nMAR  = 10;

Tref_span = linspace(8,25,nTref);
MAR_span = linspace(2e6,2e7,nMAR); % J/m^2

[Tref_ms,MaxHours_ms] = meshgrid(Tref_span,MAR_span);

Tref_list = Tref_ms(:);
MAR_list = MaxHours_ms(:);
%%
simulation = [];
max_nsim = (nTref*nMAR);
for iter = 1:max_nsim
    try 
        parameters.Tref = Tref_list(iter);
        parameters.MAR = MAR_list(iter);
        % 
        tic
        % Lanzamos la simulacion 
        rl = sim('crop_simulation','StopTime','T');

        %
        % En esta variable se encuentra todo los resultados de las simulacion
        simulation.result = parse_data_PID(rl);
        simulation.parameters = parameters;
        simulation.time = toc;

        %
        cpu_time_mean = mean(arrayfun(@(i) simulation.time,1:iter));

        falta_mins = cpu_time_mean*(max_nsim-iter)/60;
        acaba_fecha = string(datetime('now')+minutes(falta_mins));
        %
        fprintf("Simulation realizada: nº"+num2str(iter,'%02d')+"/"+max_nsim+ ...
                " | Faltan  "+falta_mins+" mins"+ ...
                " | Acaba a las: "+acaba_fecha+"\n")
        % 
        save("data/simulations/sim"+num2str(iter,"%04d"),'simulation')
    catch
       fprintf("Error \n") 
    end
end


