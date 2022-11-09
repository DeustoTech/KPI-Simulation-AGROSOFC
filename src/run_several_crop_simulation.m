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
T = 365;
T = 120;

recompile = false;
if recompile
    % Opcion de simulion para acelerar la simulacion 
    set_param('crop_simulation', 'MinimalZcImpactIntegration', 'on')
    set_param('crop_simulation','SimulationMode','normal')
    % Selecionamos el control PID para la generacion de la demanda de calor 
    % (emulamos la simulacion de Izaro, pero esta vez con los modelos desarrollados en HortiMED Modelling Platform)
    set_param('crop_simulation/Control Systems/Heater','LabelModeActiveChoice','PID')
end
%% Create a span of parameters
nTref = 3;
nMaxhours = 3;

Tref_span = linspace(8,20,nTref);
MaxHours_span = linspace(0.5,6,nMaxhours);

[Tref_ms,MaxHours_ms]=meshgrid(Tref_span,MaxHours_span);

Tref_list = Tref_ms(:);
MaxHours_list = MaxHours_ms(:);
%%
simulation = [];
max_nsim = (nTref*nMaxhours);
for iter = 1:max_nsim
    try 
        parameters.Tref = Tref_list(iter);
        parameters.MaxHour = MaxHours_list(iter);
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
       fprint("Error \n") 
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
    dTOM = gradient(TOMATO,tspan_T);
    dTOM(dTOM<0) = 0;
    %
    simulation{iter}.result.TOTAL_TOMATO = trapz(tspan_T,dTOM)*parameters.crop.A_v; % kg
    %
    plot(tspan_T,TOMATO,'Color',colors(iter,:))

end
legend(repmat("Sim ",nsim,1)+(1:nsim)')
%%
figure(2)
clf
hold on
for isim = simulation
    plot3(isim{:}.parameters.Tref,isim{:}.parameters.MaxHour,isim{:}.result.TOTAL_TOMATO,'Marker','.','MarkerSize',20)
end
view(0,0)
grid on
xlabel('Tref [ºC]')
ylabel('MaxHour [h]')
zlabel('Tomato [kg]')
%