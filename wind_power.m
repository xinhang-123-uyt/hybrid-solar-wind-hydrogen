clc;
clear all;
close all;

%% Solar Radiation Data (W/m^2)
DNI = [0 0 0 0 50 150 300 500 700 850 900 950 1000 950 850 700 500 300 150 50 0 0 0 0];

%% Wind Speed Data (m/s)
wind_speed = [4 4 5 5 6 7 8 9 10 10 9 8 7 7 6 6 7 8 9 10 8 7 6 5];

time = (1:24)';

%% Solar Thermal Generation
solar_thermal = solar_csp_thermal(DNI);

disp('Solar Thermal Energy (kW)')
disp(solar_thermal)

%% Thermal Energy Storage
[thermal_storage, storage_capacity] = thermal_storage_model(solar_thermal);

disp('Thermal Storage Capacity (kWh)')
disp(storage_capacity)

disp('Thermal Energy Stored (kWh)')
disp(thermal_storage)

%% Wind Turbine Power
windPower = wind_turbine_model(wind_speed);  % Renamed variable

disp('Wind Power Generation (kW)')
disp(windPower)

%% Total Power (Solar Thermal + Wind)
total_power = solar_thermal + windPower;

disp('Total Combined Power (kW, Solar Thermal + Wind Electrical)')
disp(total_power)

%% Plot Solar Thermal
figure
plot(time, solar_thermal,'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Solar Thermal Energy (kW)','FontWeight','bold')
title('Solar Dish CSP Thermal Energy','FontWeight','bold')
grid on

%% Plot Thermal Storage
figure
plot(time, thermal_storage,'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Thermal Energy Stored (kWh)','FontWeight','bold')
title('Thermal Energy Storage','FontWeight','bold')
grid on

%% Plot Wind Power
figure
plot(time, windPower,'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Wind Power (kW)','FontWeight','bold')
title('Wind Turbine Power Generation','FontWeight','bold')
grid on

%% Plot Total Power
figure
plot(time, total_power,'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Total Power (kW)','FontWeight','bold')
title('Total Combined Power (Solar Thermal + Wind)','FontWeight','bold')
grid on

%% Save Results to Excel
results = table(time, DNI', solar_thermal', thermal_storage', wind_speed', windPower', total_power', ...
    'VariableNames',{'Hour','Solar_Radiation_Wm2','Solar_Thermal_kW','Thermal_Storage_kWh','Wind_Speed_ms','Wind_Power_kW','Total_Power_kW'});

writetable(results,'Hybrid_Solar_Wind_System_Output.xlsx');

disp('Results saved to Hybrid_Solar_Wind_System_Output.xlsx')

%% Solar CSP Function
function solar_thermal = solar_csp_thermal(DNI)
    A_dish = 80;        % Dish area (m^2)
    eta_solar = 0.75;   % Solar efficiency
    solar_thermal = DNI .* A_dish .* eta_solar / 1000;  % Convert W to kW
end

%% Thermal Storage Function
function [thermal_storage, storage_capacity] = thermal_storage_model(solar_thermal)
    m = 2000;      % Mass (kg)
    Cp = 1.5;      % Specific heat (kJ/kg.K)
    Th = 800;      % Max temp (K)
    Tc = 300;      % Min temp (K)
    storage_capacity = m * Cp * (Th - Tc) / 3600;  % Convert kJ to kWh
    thermal_storage = zeros(1,length(solar_thermal));
    for t = 2:length(solar_thermal)
        thermal_storage(t) = thermal_storage(t-1) + solar_thermal(t);
        if thermal_storage(t) > storage_capacity
            thermal_storage(t) = storage_capacity;
        end
    end
end

%% Wind Turbine Function
function wind_power = wind_turbine_model(wind_speed)
    rho = 1.225;    % Air density (kg/m^3)
    R = 20;         % Rotor radius (m)
    A = pi * R^2;   % Swept area (m^2)
    Cp = 0.4;       % Power coefficient
    wind_power = 0.5 * rho * A .* (wind_speed.^3) * Cp / 1000;  % kW
end