clear 

name_file = 'simulation_data.txt';
path_file = which(name_file);
path_file = replace(path_file,name_file,'');

path_base = fullfile(path_file,'..','base_simulation.mat');
load(path_base)
path_best = fullfile(path_file,'..','best_simulation.mat');
load(path_best)

%
%%
fig = figure;
fig.Units = 'norm';
fig.Name  = 'base';
fig.Position = [0 0 0.5 0.9]
fig.Color = 'w';
plot_crop_sims_PID(base_simulation,'title','Baseline');

%%

fig = figure;
fig.Units = 'norm';
fig.Name  = 'best';
fig.Position = [0 0 0.5 0.9];
fig.Color = 'w';
plot_crop_sims_PID(best_simulation,'title','Best');

%
%%
time0=600*(0:52559)';
time = time0/(3600*24);

DT_span = datetime('01-Jan-2022')+ days(time);
%
%%
best_csv = csv_create(best_simulation,DT_span,time);
writetable(best_csv,'data/best_case.csv')
base_csv = csv_create(base_simulation,DT_span,time);
writetable(base_csv,'data/base_case.csv')

%%

function out_csv = csv_create(simulations,DT_span,time)

    out_csv = [];
    out_csv.DateTime = DT_span;
    %
    out_csv.HeatDemand_Watts = interp1(simulations.result.POWER.Time, ...
                                       simulations.result.POWER.Data, ...
                                       time);

    out_csv.AR_Watts = interp1(simulations.result.AR.Time, ...
                               simulations.result.AR.Data, ...
                               time);
    %
    out_csv.Tair_Celsius = interp1(simulations.result.GH.time, ...
                                   simulations.result.GH.IC.Temp.Tair - 273.15, ...
                                   time);

    out_csv.Cumulative_Tomato_kg_m2 = interp1(simulations.result.GH.time, ...
                                   simulations.result.GH.TOMATO_EVOLUTION, ...
                                   time);


    out_csv = struct2table(out_csv);

end
