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
T = 50;
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
nTref = 5;
nMAR = 5;

Tref_span = linspace(8,20,nTref);
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
        simulation{iter}.result = parse_data_PID(rl);
        simulation{iter}.parameters = parameters;
        simulation{iter}.time = toc;

        %
        cpu_time_mean = mean(arrayfun(@(i) simulation{i}.time,1:iter));

        falta_mins = cpu_time_mean*(max_nsim-iter)/60;
        acaba_fecha = string(datetime('now')+minutes(falta_mins));
        %
        fprintf("Simulation: nº"+iter+"/nº"+max_nsim+ ...
                " | Faltan  "+falta_mins+" mins | Acaba a las: "+acaba_fecha+"\n")
    catch
       fprintf("Error \n") 
    end
end
%% 
figure(1)
clf
hold on
nsim = length(simulation);
colors = jet(nsim);
iter = 0;
for isim = simulation
    iter = iter + 1;
    %
    tspan_T = isim{:}.result.TOMATO.Time;
    TOMATO = isim{:}.result.TOMATO.Data;
    %
    plot(tspan_T,TOMATO,'Color',colors(iter,:))

end
legend(repmat("Sim ",nsim,1)+(1:nsim)')
%%
figure(2)
clf
hold on
for isim = simulation
    plot3(isim{:}.parameters.Tref,isim{:}.parameters.MAR,isim{:}.result.GH.TOTAL_TOMATO*isim{:}.parameters.crop.A_v,'Marker','.','MarkerSize',20)
end
view(45,45)
grid on
xlabel('Tref [ºC]')
ylabel('Minimun Acumulated Radiation [J/m2]')
zlabel('Tomato [kg]')
%

%%
figure(3)
clf
hold on
nsim = length(simulation);
colors = jet(nsim);
iter = 0;
for isim = simulation
    iter = iter + 1;
    %
    subplot(nsim,1,iter)
    %
    plot(isim{:}.result.AR.Time,isim{:}.result.AR.Data,'Color',colors(iter,:))
    legend(isim{:}.parameters.MAR/1e3+" kJ/m^2")
end
