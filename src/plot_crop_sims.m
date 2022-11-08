sty = {'LineWidth',2};

figure(1)
clf
subplot(6,1,1)
plot(result.POWER.Time,1e-3*result.POWER.Data,sty{:})
ylabel('Power [kW]')

subplot(6,1,2)

plot(result.TOMATO.Time,result.TOMATO.Data,sty{:})
ylabel('Tomato Yield [kg/m^2]')
subplot(6,1,3)
hold on
plot(result.GH.time,result.GH.CROP.Carbon.Cbuff,sty{:})
plot(result.GH.time,result.GH.CROP.Carbon.Cfruit,sty{:})
plot(result.GH.time,result.GH.CROP.Carbon.Cleaf,sty{:})
plot(result.GH.time,result.GH.CROP.Carbon.Cstem,sty{:})
legend('C_{buff}','C_{fruit}','C_{leaf}','C_{stem}')
ylabel('Dry Matter [Kg/m^2]')
%
subplot(6,1,4)
hold on
Tk = 273.15;
plot(result.GH.time,result.GH.IC.Temp.Tair -Tk,sty{:})
plot(result.GH.time,result.GH.EC.Temp -Tk,sty{:})
yline(parameters.Tref)
ylabel('T[ºC]')

yyaxis right
plot(result.GH.time,result.Tw.Data-Tk,sty{:})
legend('T_i','T_e','T_{set-point}','T_w')
ylabel('T[ºC]')

subplot(6,1,5)
hold on
plot(result.POWER_SOFC.Time,result.POWER_SOFC.Data,sty{:})
plot(result.POWER_SOFC.Time,result.POWER_SOFC_e.Data,sty{:})

plot(result.POWER_SOFC.Time,result.POWER_SOFC_e.Data + result.POWER_SOFC.Data,sty{:})

yyaxis right
plot(result.OP.Time,result.OP.Data,sty{:},'LineStyle','--')
yticks([2 3 4])
title('Operation Points')
yticklabels({'OP2','OP3','OP4'})
%
subplot(6,1,6)
hold on
plot(result.Activity.Time,result.Activity.Data,sty{:},'LineStyle','--')
legend('Deactivation')