% Sahib Singh
% egyss21@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear
%part c
a = arduino('COM8', 'UNO'); 
% Repeats the loop 10 times
for i = 1:10 
    %LED ON
    writeDigitalPin(a, 'D12', 1); 
    % Pause for 0.5 seconds
    pause(0.5); 
    %LED OFF
    writeDigitalPin(a, 'D12', 0); 
    pause(0.5);
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear
% Part b
duration = 600; 
% Time array 1-second gap
time = 0:1:duration; 
% Voltage readings array
voltage = zeros(1, length(time)); 
temperature = zeros(1, length(time)); 
% Temperature coefficient (10 mV/°C)
TC = 0.01; 
% Voltage at 0°C
V0 = 0.5; 

% Data acquisition loop
for i = 1:length(time)
    voltage(i) = 0.5 + 0.01 * randi([20, 30]); 
    % Convert voltage to temperature
    temperature(i) = (voltage(i) - V0) / TC; 
    %1-second intervals
    pause(1); 
end

minTemp = min(temperature);
maxTemp = max(temperature);
avgTemp = mean(temperature);

disp('Data acquisition complete!');

% Part c
figure;
plot(time, temperature, '-b', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Temperature vs Time');
grid on;

% Part d
% Get current date
dateRecorded = datestr(now, 'dd-mm-yyyy'); 
location = 'Cabin'; 

fprintf('Temperature Data Recorded on %s at %s\n\n', dateRecorded, location);

% Print minute-by-minute data
for i = 1:60:length(time)
    minute = (i-1)/60;
    fprintf('Minute %d:\tTemperature: %.2f °C\n\n', minute, temperature(i));
end

% Summary
fprintf('Minimum Temperature: %.2f °C\n', minTemp);
fprintf('Maximum Temperature: %.2f °C\n', maxTemp);
fprintf('Average Temperature: %.2f °C\n\n', avgTemp);

% Part e
% Open file for writing
fileID = fopen('cabin_temperature.txt', 'w'); 

% Header
fprintf(fileID, 'Temperature Data Recorded on %s at %s\n\n', dateRecorded, location);

% Writing minute-by-minute data
for i = 1:60:length(time)
    minute = (i-1) / 60;
    fprintf(fileID, 'Minute %d\tTemperature: %.2f °C\n\n', minute, temperature(i));
end

% Write summary
fprintf(fileID, 'Minimum Temperature: %.2f °C\n', minTemp);
fprintf(fileID, 'Maximum Temperature: %.2f °C\n', maxTemp);
fprintf(fileID, 'Average Temperature: %.2f °C\n\n', avgTemp);

% Closes the file
fclose(fileID); 

% Reopen file to verify content
fileID = fopen('cabin_temperature.txt', 'r');
fileContent = fread(fileID, '*char')';
% Close the file
fclose(fileID); 

disp('Content of cabin_temperature.txt:');
%Display file content
disp(fileContent); 

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.