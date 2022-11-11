# Simulación de la producción de tomate para el proyecto AGROSOFC

<center>10 de Noviembre de 2022

Deyviss Jesus Oroya Villalta 

University of Deusto
</center>
<hr>

For the calculations of the KPIs, a simulation model based on the HortiMED Modeling Platform library has been built. This is built on MATLAB Simulink. The greenhouse model takes into account a climate model, a tomato growth model and a tomato maturity model. In addition, a controller for a natural ventilation system, a shading screen control, and a heater that simulates the behavior of the sink and the water tank have been implemented. These controls were developed by Izaro Garro. In this implementation, the control laws and the control instructions considered in this work are considered.

![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig1.png)
<center>
Figura 1. Modelo de Simulink del invernadero
</center>

## Re-implementation of control laws

The controls have been modified, although with the same philosophy that Izaro proposed at the time. This change is primarily due to the change in Simulink solver integration. The new model is built in continuous time and with an adaptive time step, while the model implemented by Izaro was discrete time with a fixed time step. Although in principle this should not affect the control laws, in the Izaro implementation hysteresis control is done using methods such as “persistent” within MATLAB functions. This method is inherently discrete. This implementation does not have continuous time translation so it was necessary to re-implement the controls.


## Temperature setpoint variation effect

The following Figure 2 shows how the variation of the temperature setpoint affects the simulation. The outside temperature is shown in black, while the different simulations with different setpoints are shown in color.

![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig2.png)

<center>
Figure 2. Greenhouse temperature for different setpoint temperatures
</center>

## Effect of daily minimum accumulated radiation variation

The daily accumulated radiation can be expressed as:

  
where the unit of time is measured in days.

This is the accumulated radiation that restarts every time the day changes. The artificial light control law tries to compensate the daily accumulated radiation  if it is very low. Since  is a function that increase as time goes by, we will check at 10pm each day what its value is, then if it is very low, the artificial light will be activated. The daily accumulated radiation is considered very low if it is below a controller parameter . In the base simulation, this value has , so on days when this value has not been reached at 10:00 p.m., artificial light will be activated. It should be said that the artificial light activation duration time is proportional to .

In order to find the best simulation we will do simulations each time with a larger value of  . In the following figure we can see the effect produced by a variation of .

![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig3.png)
<center>
Figure 3. Greenhouse temperature for different values of 
</center>

As we increase the minimum radiation, the artificial light system turns on more.

Batch of Simulations
The parameters of the accumulated radiation threshold per square meter   have been varied, as well as the reference temperature of the heater . A grid of values has been created for these two parameters following the following values:

<center>
 Tabla 1 . Resultados en producción de las simulaciones
</center>

Se ha simulado el sistema para cada combinación de valor (, ) dando lugar a  simulaciones. 
The system has been simulated for each combination of value (, ) giving rise to  simulations.

In the following figure we show the results of the simulations in terms of tomato production. Figure 3 shows Tomatoes against minimum radiation and setpoint temperature. In Figure 4, we show an interpolation of the simulations carried out, in order to find the optimal setpoints for the maximization of annual tomato production. In Table 2, we can see tomato production in the base simulation and the best simulation performed.

<center>
Table 2. Production results of the simulations
</center>



![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig4.png)

<center>
Figure 4. 3D view of the simulations carried out.
Tomato produced for different set points
</center>

![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig5.png)
<center>
Figure 5. Interpolation by splines of the simulations carried out.
We can see a contour map that tells us where the optimal set-points are located.
</center>
![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig6.png)

<center>
Figure 6. Algunas señales de salida de la simulación para el estado base.
</center>

- Axes 1. Heat demand
- Axes 2. Cumulative tomato production. (There are two campaigns)
- Axes 3. Production of dry matter in the buffer, fruit, leaves and branches (Vanthdoor Crop Model)
- Axes 4. Behavior of the interior temperature against the temperature setpoint and the exterior temperature
- Axes 5. Electric demand for artificial light

![](https://raw.githubusercontent.com/DeustoTech/KPI-Simulation-AGROSOFC/main/img/Fig7.png)
<center>Figure 7. Algunas señales de salida de la simulación para el estado optimo.</center>

- Axes 1. Heat demand
- Axes 2. Cumulative tomato production. (There are two campaigns)
- Axes 3. Production of dry matter in the buffer, fruit, leaves and stems (Vanthdoor Crop Model)
- Axes 4. Behavior of the interior temperature against the temperature set-point and the exterior temperature
- Axes 5. Electric demand for artificial light


# Comandos Software

Para descargar en cualquier 
 

….


