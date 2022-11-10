% 
clear 
name_file = 'simulation_data.txt';
path_file = which(name_file);
path_file = replace(path_file,name_file,'');
files = what(path_file);
%%
%files.mat(11) = [];
%files.mat{100} = 'sim100.mat';

%%
iter = 0;
for ifile = files.mat'
   iter = iter + 1;
   load(ifile{:})
   simulations{iter} = simulation;
   fprintf("load simulation nº"+num2str(iter,'%02d')+"\n")
end
%%
simulations = simulations(arrayfun(@(i) ~isempty(simulations{i}),1:length(simulations)));
%% 
figure(1)
clf
hold on
nsim = length(simulations);
colors = jet(nsim);
iter = 0;
for isim = simulations
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
for isim = simulations
    plot3(isim{:}.parameters.Tref,isim{:}.parameters.MAR,isim{:}.result.GH.TOTAL_TOMATO*isim{:}.parameters.crop.A_v,'Marker','.','MarkerSize',20)
end
view(45,45)
grid on
xlabel('Tref [ºC]')
ylabel('Minimun Acumulated Radiation [J/m2]')
zlabel('Tomato [kg]')
%

%%
fig = figure(3);
fig.Color = 'w'
clf
hold on
nsim = length(simulations);
colors = jet(nsim);
iter = 0;
for isim = simulations(1:5)

    iter = iter + 1;
    %
    subplot(5,1,iter)
    %
    plot(isim{:}.result.AR.Time,isim{:}.result.AR.Data/1e3,'Color',colors(iter,:))
    legend(isim{:}.parameters.MAR/1e3+" kJ/m^2")
    if iter == 1
        title('Activation of Artifitial Lighting')
    end
end
xlabel('Days')

%%

fig = figure(3);
fig.Color = 'w'
clf
hold on
nsim = length(simulations);

select_sims = simulations(1:(2*10):(2*10*5));
colors = jet(length(select_sims));
iter = 0;
for isim = select_sims

    iter = iter + 1;
    %
    subplot(5,1,iter)
    hold on
    %
    tspan = isim{:}.result.GH.time;
    Ti = isim{:}.result.GH.IC.Temp.Tair - 273.15;
    Te = isim{:}.result.GH.EC.Temp - 273.15;
    
    plot(tspan,Ti,'Color',colors(iter,:),'LineWidth',1.5)
    plot(tspan,Te,'Color','k','LineWidth',1.5)
    yline(isim{:}.parameters.Tref,'LineWidth',1.5)

    legend("T_{ref} = "+num2str(isim{:}.parameters.Tref,'%.1f')+" ºC")
    if iter == 1
        title('Temperatures')
    end
    xlim([0 10])
    ylim([-5 25])
    grid on
    ylabel('[ºC]')
end
xlabel('Days')

%%
Tref_list = arrayfun(@(i) i{:}.parameters.Tref,simulations);
MAR_list = arrayfun(@(i)  i{:}.parameters.MAR,simulations);
TOM_list  = arrayfun(@(i) i{:}.result.GH.TOTAL_TOMATO*i{:}.parameters.crop.A_v,simulations);

Tref_lin = linspace(min(Tref_list),max(Tref_list),500);
MAR_lin  = linspace(min(MAR_list),max(MAR_list),500);

[Tref_ms, MAR_ms] = meshgrid(Tref_lin,MAR_lin);

%F = scatteredInterpolant(Tref_list',MAR_list',TOM_list');
%%
F = griddedInterpolant(reshape(Tref_list,10,10)', ...
                        reshape(MAR_list,10,10)',reshape(TOM_list,10,10)');

F.Method = 'spline'
%%
fig = figure
fig.Color = 'w'
hold on
surf(Tref_ms,MAR_ms/1e6,F(Tref_ms, MAR_ms))
view(90,-90)
shading interp
[ip,h] = contour(Tref_ms,MAR_ms/1e6,F(Tref_ms, MAR_ms),'ShowText','on')

h.LineColor = 'w';
h.LineWidth = 2;
c = colorbar();
colormap(jet(30))
h.LevelList = [74 75  78 79  80 81.5];
c.Label.String = 'Tomato [kg]';

ylabel('Minumum Radiation Acumulated [MJ/m^2]')
xlabel('Set point Temperature [ºC]')
clabel(ip,h)
caxis([73 81])

clabel(ip,h,'FontSize',12,'Color','w')

%% 
fig = figure()
fig.Color = 'w'
is3 = scatter3(Tref_list,MAR_list/1e6,TOM_list,TOM_list*0+2e3,TOM_list,'.')
colormap(jet(20))
c = colorbar();
caxis([70 81])
c.Label.String = 'Tomato [kg]';

grid on
ylabel('Minumum Radiation Acumulated [MJ/m^2]')
xlabel('Set point Temperature [ºC]')
zlabel('Tomato [kg]')
view(-51,34)
title('Simulations')
%%
[~,ind_max ] = max(TOM_list);

best_simulation = simulations{ind_max};

save(fullfile(path_file,'..','best_simulation.mat'),'best_simulation')