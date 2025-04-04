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

% Insert answers here

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