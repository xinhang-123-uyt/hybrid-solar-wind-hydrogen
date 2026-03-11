clc;
clear all;
close all;

% 24-hour solar radiation data (W/m^2)
DNI = [0 0 0 0 50 150 300 500 700 850 900 950 1000 950 850 700 500 300 150 50 0 0 0 0];

% Call the function
solar_power = solar_power_csp(DNI);

% Display result
disp('Solar Power Generation (kW)')
disp(solar_power)

% Time vector
time = (1:24)';

% Plot
figure
plot(time, solar_power, 'LineWidth',2)
xlabel('Time (Hour)','FontWeight','bold')
ylabel('Solar Power (kW)','FontWeight','bold')
title('Solar Dish CSP Power Generation','FontWeight','bold')
grid on

%% Save Results to Excel

results = table(time, DNI', solar_power', ...
    'VariableNames',{'Hour','Solar_Radiation_Wm2','Solar_Power_kW'});

writetable(results,'Solar_Power_Output.xlsx');

disp('Results successfully saved to Solar_Power_Output.xlsx')


%% Function (must be at end of script)
function solar_power = solar_power_csp(DNI)

% Solar Dish CSP parameters
A_dish = 80;        % Dish area (m^2)
eta_solar = 0.75;   % Solar efficiency

% Solar thermal power calculation
solar_power = DNI .* A_dish .* eta_solar / 1000;  % Power in kW

end