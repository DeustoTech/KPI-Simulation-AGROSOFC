
function plot_crop_sims(simulation,varargin)

p = inputParser;

addRequired(p,'simulation')
addOptional(p,'title','')

parse(p,simulation,varargin{:});

title_string = p.Results.title;


parameters = simulation.parameters;
result = simulation.result;
sty = {'LineWidth',2};

%figure(1)
clf
subplot(5,1,1)
plot(result.POWER.Time,1e-3*result.POWER.Data,sty{:})
ylabel('Power [kW]')

if ~isempty(title_string)
   title(title_string) 
end
subplot(5,1,2)

plot(result.TOMATO.Time,result.TOMATO.Data,sty{:})
ylabel('Tomato Yield [kg/m^2]')
subplot(5,1,3)
hold on
plot(result.GH.time,result.GH.CROP.Carbon.Cbuff,sty{:})
plot(result.GH.time,result.GH.CROP.Carbon.Cfruit,sty{:})
plot(result.GH.time,result.GH.CROP.Carbon.Cleaf,sty{:})
plot(result.GH.time,result.GH.CROP.Carbon.Cstem,sty{:})
legend('C_{buff}','C_{fruit}','C_{leaf}','C_{stem}')
ylabel('Dry Matter [Kg/m^2]')
%
subplot(5,1,4)
hold on
Tk = 273.15;
plot(result.GH.time,result.GH.IC.Temp.Tair -Tk,sty{:})
plot(result.GH.time,result.GH.EC.Temp -Tk,sty{:})
yline(parameters.Tref)
ylabel('T[ºC]')

legend('T_i','T_e','T_{set-point}')


subplot(5,1,5)
hold on
plot(result.AR.Time,cumtrapz(result.AR.Time,result.AR.Data)*24/1e6,sty{:})
ylabel('MWh')
yyaxis right 
plot(result.AR.Time,result.AR.Data)
ylabel('Artifitial Lighting [W]')
end