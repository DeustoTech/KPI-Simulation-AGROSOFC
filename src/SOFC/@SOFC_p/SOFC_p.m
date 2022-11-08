classdef SOFC_p
    %SOFC_P Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MM
        Temperature
        Gibbs
        Enthalpy
        Gibbs_simulink
        atm
        Vanode
        Vcatho
        N0
        pressure
        K_an
        K_cath
        r
        K_an_SI
        K_cath_SI
        ValveConstants_an
        ValveConstants_cath
        R
        F
        slpm2mol
    end
    
    methods
        function p = SOFC_p()
            %% [H2 O2 H2O N2 CO CH4 CO2]

            p.MM = Molar_kg_mol;
            
            T = 713.7016; % K
            p.Temperature = mean(T);
            %
            p.Gibbs.H2  = Gibbs(T,'H2');
            p.Gibbs.CO  = Gibbs(T,'CO');
            p.Gibbs.CH4 = Gibbs(T,'CH4');
            p.Gibbs.O2  = Gibbs(T,'O2');
            p.Gibbs.H2O = Gibbs(T,'H2O');
            p.Gibbs.CO2 = Gibbs(T,'CO2');
            %%
            p.Enthalpy.H2  = Enthalpy(T,'H2');
            p.Enthalpy.CO  = Enthalpy(T,'CO');
            p.Enthalpy.CH4 = Enthalpy(T,'CH4');
            p.Enthalpy.O2  = Enthalpy(T,'O2');
            p.Enthalpy.H2O = Enthalpy(T,'H2O');
            p.Enthalpy.CO2 = Enthalpy(T,'CO2');

            p.Gibbs_simulink = Simulink.Bus.createObject(p.Gibbs);

            %%
            %
            p.atm      = 101325; % atm to Pa
            p.Vanode   = 0.5; % m^3
            p.Vcatho   = 0.5; % m^3
            p.N0       = 30; % Cells number
            p.pressure = p.atm;

            %p.K_an   = 0.0377; % kmol/(atm . s)  % paper
            %p.K_cath = 0.0377; % kmol/(atm . s) % paper

            p.K_an   = 0.005; % kmol/(atm . s)
            p.K_cath = 0.005; % kmol/(atm . s)

            p.K_an_SI = 1e3*p.K_an/p.atm; % mol/(Pa . s)
            p.K_cath_SI = 1e3*p.K_cath/p.atm; % mol/(Pa . s)
            %
            MMs = [p.MM.H2 p.MM.O2 p.MM.H2O p.MM.N2 p.MM.CO  p.MM.CH4 p.MM.CO2 p.MM.Diesel p.MM.Ar p.MM.Csoot];
            %
            p.ValveConstants_an   = p.K_an_SI./sqrt(MMs);% Valve molar Constants [mol/(s.Pa)]
            p.ValveConstants_cath = p.K_cath_SI./sqrt(MMs);% Valve molar Constants [mol/(s.Pa)]
            %
            p.r =    0.15; % Ohm 

            %
            p.R = 8.31446261815324; % [J/(K.mol)] 
            p.F = 96485.3329;       % C/mol
            p.atm = 101325; % atm to Pa

            p.slpm2mol = p.atm/(6e4*p.R*(273.15));
        end
        
    end
end

