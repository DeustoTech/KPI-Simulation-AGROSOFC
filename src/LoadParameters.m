%%
function parameters = LoadParameters()

warning off

parameters.Tref=16.5;

%% Cargamos los parametros por defecto del modelo de crop
parameters.crop = struct(crop_p);

parameters.crop.A_v = 40;       % Area de cultivo [m^2]
parameters.crop.n_seasons = 2;  % Numero de sesisiones [-]

%% Cargamos los parametros por defecto del modelo de crop de clima
parameters.climate = struct(climate_p);
%
parameters.climate.A_c          = 60;        % Area de cubierta del invernadero
parameters.climate.A_f          = 60;        % Area de suelo
parameters.climate.alpha_i      = 0.1;       % Coeficiente de absorcion de radiacion del aire en el invernadero [-]
parameters.climate.alpha_f      = 0.001;     % Coeficiente de absorcion de radiacion del suelo en el invernadero [-]
parameters.climate.tau_c        = 0.7;       % Coeficiente de transmisividad de radiacion de la cubierta del invernadero [-]
parameters.climate.H            = 4;         % Altura del invernadero
parameters.climate.minWindows   = 0.01;      % Coeficiente de hermeticidad del invernadero [-],   aunque las ventanas esten cerradas el invernadero tiene conveccion con el exterior por los defectos que puede tener su cubierta (agujeros, puertas, etc)
%%

%% SOFC 
% Cargamos los parametros por defecto del modelo SOFC
parameters.Heating.SOFC.params = struct(SOFC_p);
% Cargamos las condiciones iniciales del modelo SOFC
parameters.Heating.SOFC.x0     = struct(SOFC_init);
parameters.Heating.SOFC.T     = 700; % Temperatura de SOFC 
%
% Este es un parametros para recuperar masa molar de los elementos dentro
% de la pila
parameters.Heating.SOFC.MM_vec = struct2array(Molar_kg_mol)';
%
% Recuperamos el modelo de datos, de la pila de combustible.
%
load('nearst_nn_params.mat')
parameters.Heating.SOFC.nearst_p = nearst_p;

parameters.Heating.Reformer.T = 600;    % Temperatura del reformador
% Cargamos los parametros de deactivacion
%
%
% da/dt = -a^nd*exp(-Kw*X_{H2O}) * ( X_{CO} k_{CO}         + 
%                                    X_{H2} k_{CO}         +
%                                    X_{CO2} k_{CO}        +
%                                    X_{CH4} k_{CO}        +
%                                    X_{N2} k_{N2}         +   
%                                    X_{Diesel} k_{Diesel} + 
%                                    X_{O2} k_{O2}             )
%                   
%
% Kw = Kw_ast*exp(-Ew/R*(1/(T - 1/573));
% R = 8.314472;% J/(mol K) 

parameters.Heating.Reformer.deactivation.k0 = 0.024; 
parameters.Heating.Reformer.deactivation.Kw_ast = 5000;                 % k_H2O 
parameters.Heating.Reformer.deactivation.Ew = 0;                    
parameters.Heating.Reformer.deactivation.k = [0 0 0 0 0 0 0 ]';         % [k_CO k_H2 k_CO2 k_CH4 k_N2 k_Diesel k_O2]  Dado que no hemos medido desactivacion no consideramos estas depedencias todavia 
parameters.Heating.Reformer.deactivation.nd = 1;
parameters.Heating.Reformer.deactivation.activity_threshold = 0.5;

%
% Cargamos potencia electrica de la luz artificial
parameters.PowerArtificial = 1000;

warning on
end