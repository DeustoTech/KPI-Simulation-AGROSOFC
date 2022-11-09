
function [Hours,tt,Si,vv,HR,ChangeDay] = LoadExternalClimate
time0=600*(0:52559)';
time = time0/(3600*24);

data=xlsread('año2019completo.xlsx');
%
%% Temperature Exterior

%[Te,ind_Te] = rmoutliers(data((1:52560),1));

tt.time = time;
tt.signals.values = data(:,1);
 
%% Radiation

%[Re,ind_Re] = rmoutliers(data((1:52560),3));

Si.time = time;
%Si.signals.values = data(:,3);
Si.signals.values = smoothdata(data(:,3),'SmoothingFactor',0.025);
%
clf
plot(data(:,3))
hold on;plot(Si.signals.values)

%% Wind

%[Wind,ind_Wind] = rmoutliers(data((1:52560),5));

vv.time = time;
vv.signals.values = data(:,5);
%%
load('data/CS3_2_ExteriorClima.mat')
%
idx_1 = ds.DateTime >= datetime('01-Jan-2019');
idx_2 = ds.DateTime <= datetime('31-Dec-2019');

ds = ds(logical(idx_1.*idx_2),:);

time_HR =  days(ds.DateTime - datetime('01-Jan-2019'));
HR.time = time_HR;
HR.signals.values = smoothdata(ds.humidity,'SmoothingFactor',0.02);

%% Compute change days
DateTime = datetime('2019-01-01 00:00:00') + seconds(time0);

DateTime_duration = days(DateTime - DateTime(1));

CD = (DateTime_duration - floor(DateTime_duration)) > 1e-4;
% Signal
ChangeDay.time = (time);
ChangeDay.signals.values = CD;


%% Compute Sunsets
% Meñaka

Latitud  = 43.349024834327; 
Longitud = -2.797651290893;
DGMT = 2;
%
iter  = 0;
sset = zeros(1,length(DateTime));
for iLT = DateTime'
    iter = iter + 1;
    sset(iter) = Date2Sunset(iLT,Latitud,Longitud,DGMT);
end
%
TurnOnHour = abs((hour(DateTime ) + minute(DateTime)/60) - sset') < 0.3 ; % 

% Signal Sunset hours
Hours.time = (time);
Hours.signals.values = TurnOnHour;

end
