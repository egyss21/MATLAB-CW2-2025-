% Sahib Singh
% egyss21@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear
%part c
a = arduino('COM8', 'UNO'); 
% Repeats the loop 10 times
for i = 1:10 
    %LED ON
    writeDigitalPin(a, 'D7', 1); 
    % Pause for 0.5 seconds
    pause(0.5); 
    %LED OFF
    writeDigitalPin(a, 'D7', 0); 
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
%% light test (ignore)
clear
a = arduino('COM8', 'UNO');
writeDigitalPin(a, 'D7', 1); 
pause(1);
writeDigitalPin(a, 'D5', 1); 
pause(1);
writeDigitalPin(a, 'D3', 1); 
pause(1);
writeDigitalPin(a, 'D7', 0); 
pause(1);
writeDigitalPin(a, 'D5', 0); 
pause(1);
writeDigitalPin(a, 'D3', 0);
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear
a = arduino('COM8', 'Uno');
%calls the function
temp_monitor(a);
%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
clear
a = arduino('COM8' , 'Uno');
function temp_prediction(a)
% Hardware Configuration
% Temperature coefficient (V/°C)
TC = 0.010;  
% Voltage offset (V)
V0 = 0.5;    
tempPin = 'A1';
greenLED = 'D3';
yellowLED = 'D5';
redLED = 'D7';

% Initialize Hardware
configurePin(a, tempPin, 'AnalogInput');
configurePin(a, greenLED, 'DigitalOutput');
configurePin(a, yellowLED, 'DigitalOutput');
configurePin(a, redLED, 'DigitalOutput');

% System Variables
prevTemp = NaN;
prevTime = tic;
% Smoothing factor
alpha = 0.3;               
rateThreshold = 4/60;       
blinkState = false;
lastBlinkUpdate = tic;
lastPrintUpdate = tic;

try
    while true
        currentTime = toc(lastBlinkUpdate);
        
        % Temperature Measurement
        rawTemp = (readVoltage(a,tempPin)-V0)/TC;
        
        
        if isnan(prevTemp)
            currentTemp = rawTemp;
        else
            currentTemp = alpha*rawTemp + (1-alpha)*prevTemp;
        end
        
        % Calculation
        elapsed = toc(prevTime);
        if isnan(prevTemp)
            rate = 0;
        else
            rate = (currentTemp-prevTemp)/elapsed;
        end
        prevTemp = currentTemp;
        prevTime = tic;
        
        % Heating too fast
        if rate > rateThreshold          
            blinkInterval = 0.25;
            if currentTime >= blinkInterval
                blinkState = ~blinkState;
                writeDigitalPin(a, redLED, blinkState);
                writeDigitalPin(a, yellowLED, 0);
                writeDigitalPin(a, greenLED, 0);
                lastBlinkUpdate = tic;
            end
            
        % Cooling too fast
        elseif rate < -rateThreshold     
            blinkInterval = 0.5;
            if currentTime >= blinkInterval
                blinkState = ~blinkState;
                writeDigitalPin(a, yellowLED, blinkState);
                writeDigitalPin(a, redLED, 0);
                writeDigitalPin(a, greenLED, 0);
                lastBlinkUpdate = tic;
            end
        
        % Good condition
        else                            
            writeDigitalPin(a, redLED, 0);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, greenLED, (currentTemp >= 18 && currentTemp <= 24));
        end
        
       % Update every 1s
        if toc(lastPrintUpdate) >= 1     
            % 300 sec / 5 min projection
            predictedTemp = currentTemp + rate*300; 
            fprintf('Current: %.1f°C | Rate: %.3f°C/s | 5min: %.1f°C\n',...
                    currentTemp, rate, predictedTemp);
            lastPrintUpdate = tic;
        end
        
        pause(1); % Small delay for responsiveness
    end

end
end
%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)
% The main challenge I faced during this project was understanding the need
% to create separate files for functions. Initially, it seemed much more 
% efficient to condense the logic into a few lines within the main script. 
% However, as I progressed, I realized that modularity plays a crucial role
% in ensuring the stability, clarity of the code. This approach becomes 
% especially important in collaborative projects, as it 
% allows individual functions to be tested, debugged, and updated without 
% affecting the entire program.
% One of the code’s greatest strengths was its organized structure, which 
% made it straightforward to follow and debug. Additionally, the program 
% provided helpful feedback when the output was not as expected, such as 
% warning the user about incorrect connections or potential issues with 
% voltage. These features improved the overall user experience and made 
% troubleshooting easier. However, there were limitations as well, 
% particularly when it came to error handling. While the code addressed
% invalid voltage readings, it could benefit from more robust handling of 
% scenarios like sensor failures or unexpected values.
% To improve the code, I would focus on implementing dynamic configurations
% . This would allow users to customize parameters such as pin assignments,
% temperature thresholds, and monitoring intervals, making the program more
% adaptable to different hardware setups and use cases. Consolidating 
% repetitive code, like the blinking logic for LEDs, would also enhance 
% efficiency. Additionally, introducing features 
% like sensor calibration could improve the accuracy of temperature 
% readings, especially in environments where conditions may vary.
%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.