clc;
clear all;
close all;

% 24-hour solar radiation data (W/m^2)
DNI = [0 0 0 0 50 150 300 500 700 850 900 950 1000 950 850 700 500 300 150 50 0 0 0 0];

% Call solar thermal function
solar_thermal = solar_csp_thermal(DNI);

disp('Solar Thermal Energy Generated (kWth)')
disp(solar_thermal)

% Time vector
time = (1:24)';

%% Thermal Energy Storage Model

[thermal_storage, storage_capacity] = thermal_storage_model(solar_thermal);

disp('Thermal Storage Capacity (kWh)')
disp(storage_capacity)

disp('Thermal Energy Stored (kWh)')
disp(thermal_storage)

%% Plot Solar Thermal Energy
figure
plot(time, solar_thermal,'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Solar Thermal Energy (kWth)','FontWeight','bold')
title('Solar Dish CSP Thermal Energy Generation','FontWeight','bold')
grid on

%% Plot Thermal Storage
figure
plot(time, thermal_storage,'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Thermal Energy Stored (kWh)','FontWeight','bold')
title('Thermal Energy Storage','FontWeight','bold')
grid on

%% Save Results to Excel

results = table(time, DNI', solar_thermal', thermal_storage', ...
'VariableNames',{'Hour','Solar_Radiation_Wm2','Solar_Thermal_kW','Thermal_Storage_kWh'});

writetable(results,'Solar_Thermal_Storage_Output.xlsx');

disp('Results successfully saved to Solar_Thermal_Storage_Output.xlsx')

%% Solar Dish CSP Thermal Function
function solar_thermal = solar_csp_thermal(DNI)

A_dish = 80;        % Dish area (m^2)
eta_solar = 0.75;   % Solar efficiency

% Solar thermal energy (kW thermal)
solar_thermal = DNI .* A_dish .* eta_solar / 1000;

end


%% Thermal Storage Function
function [thermal_storage, storage_capacity] = thermal_storage_model(solar_thermal)

% Thermal storage parameters
m = 2000;     % molten salt mass (kg)
Cp = 1.5;     % kJ/kgK
Th = 800;     % hot temp (°C)
Tc = 300;     % cold temp (°C)

% Storage capacity
storage_capacity = m * Cp * (Th - Tc) / 3600; % kWh

thermal_storage = zeros(1,length(solar_thermal));

for t = 2:length(solar_thermal)

    thermal_storage(t) = thermal_storage(t-1) + solar_thermal(t);

    % Storage limit
    if thermal_storage(t) > storage_capacity
        thermal_storage(t) = storage_capacity;
    end

end

end