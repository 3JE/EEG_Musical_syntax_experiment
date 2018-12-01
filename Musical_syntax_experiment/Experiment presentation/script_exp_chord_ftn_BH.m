% last modifed 20181029 by eunjin
% script for musical syntax behaviour session presentation with psychtoolbox

Screen('Preference', 'SkipSyncTests', 1);

%% setting
clear all; close all; clc;
%Screen('Preference', 'SkipSyncTests', 0);

n_subject = 1; %subject number

n_BHblock = 1; % behaviour session
n_BHtrial = 5; % behaviour session trial

BH_key_response_starting_chord(1:n_BHblock, 1:n_BHtrial) = 0;%initialize memory space for saving key response(key value)
BH_key_response_ending_chord(1:n_BHblock, 1:n_BHtrial) = 0;

Fs = 44100;

% color
white = [255 255 255];  
black = [0 0 0];  

% Screen
%ScreenNumber = 0; % one monitor
screens = Screen('Screens');
ScreenNumber = max(screens);
[width, height] = Screen('WindowSize', ScreenNumber); %your present screen size

%% Initialize daq(data acquisition) toolbox - working ONLY on the presentation computer
%Initialize
session = daq.createSession('ni');
ch = addDigitalChannel(session,'Dev1','Port2/Line0:7','OutputOnly');

%trigger setting
tThres = 0.008;
t = inf;
while t > tThres
    t1 = GetSecs;
    outputSingleScan(session, dec2binvec(0,8)); 
    t2 = GetSecs;
    t = t2-t1;
end

%% Debugmode

%Debugmode?
check_debugmode = lower(input('Is it debugmode (y/n)? ' ,'s'));

%ID
subID = lower(input('type the subject ID : ', 's'));  % when ID is string
    %subID = (input('type the ID : ')); % when ID is number

[subY, subM, subD] = datevec(date);
    
%Execution of debugmode or not
if strcmpi(check_debugmode, 'y')  % strcmpi= Compare strings
    debugmode = 1;
elseif strcmpi(check_debugmode, 'n')
    debugmode = 0;
else
    error('you should type y or n');
end
   
if debugmode ~=0   % if debugmode is not 0 (=when it is debugmode)
    debugRect = [10 10 width/2 height/2]; %size of debugmode window
    [windowPtr, winRect] = Screen('OpenWindow', ScreenNumber, black, debugRect); 
    Screen('flip', windowPtr);
    ShowCursor;   
else
    [windowPtr, winRect] = Screen('OpenWindow', ScreenNumber, black);
    Screen('flip', windowPtr);
    HideCursor;
end

%% Experiment loading

%pause on
outputSingleScan(session, dec2binvec(255,8));
outputSingleScan(session, dec2binvec(0,8)); 

%instruction
StartText = 'The experiment is about to begin.\n\n Press any key to start.';
DrawFormattedText(windowPtr,StartText,'center','center',white); 
Screen('Flip', windowPtr);  
KbStrokeWait(-1); %wait until keyboard input
DrawFormattedText(windowPtr, ['Loading....'], 'center', 'center', white);
Screen('Flip',windowPtr);
pause(0.8);


%% Behaviour session demo

BHText = '2. Behaviour session';
DrawFormattedText(windowPtr,BHText,'center','center',white); 
Screen('Flip', windowPtr);
pause(2);

BHText = 'You are now going to listen to chord sequences \n\n and determine the function of first chord and ending chord \n\n press any key to start demo';
DrawFormattedText(windowPtr,BHText,'center','center',white); 
Screen('Flip', windowPtr);
KbStrokeWait(-1);

Tonic = 'Tonic(I)';
Submediant = 'Submediant(vi)';
Supertonic = 'Supertonic(ii)';
conditions = { Tonic, Tonic; Tonic, Submediant; Tonic, Supertonic; Submediant, Tonic;Submediant,Submediant; Submediant, Supertonic};

while(1)
%while key is not space key
BHText = 'Press key 1-6 to listen to 6 conditions in demo,\n\n if you want to start the behaviour session, press 0 key';
DrawFormattedText(windowPtr,BHText,'center','center',white); 
Screen('Flip', windowPtr);
keyIsDown = 0;
while ~keyIsDown
    [keyIsDown, pressedSecs, keyCode] = KbCheck(-1);
end
pressedKey = KbName(find(keyCode)) - '0';


if pressedKey == 0
    break
else
    BHText = sprintf('Condition %d :\nstarting chord = %s\n\n ending chord = %s',pressedKey,conditions{pressedKey,1}, conditions{pressedKey,2});
    DrawFormattedText(windowPtr,BHText,'center','center',white); 
    Screen('Flip', windowPtr);
    
    PsychDefaultSetup(0);
    InitializePsychSound(0);
    [Y, Fs] = audioread(sprintf('Stimuli/Behaviour_example/%d.wav',pressedKey));
    pahandle = PsychPortAudio('Open', [], [], 1, Fs, 2);
    PsychPortAudio('FillBuffer', pahandle, Y');
    PsychPortAudio('Start',pahandle,1,0);
    pause(4.2);        
    %reset audio
    if ~isempty(pahandle)
       count = PsychPortAudio('GetOpenDeviceCount');
       if count > 0 
          PsychPortAudio('Close', pahandle);
       end
    end
    
end


end



%% Behaviour session real

for i=1:n_BHblock

    % every session(block) starts when any button is pressed
    BlockText = 'Press any key to start the Behaviour session';
    DrawFormattedText(windowPtr,BlockText,'center','center',white); 
    Screen('Flip', windowPtr); 
    % waits until all keys on the keyboard are released : -1 means device number(all keyboard devices will be checked)        
    KbStrokeWait(-1); 

    for j=1:n_BHtrial
        PsychDefaultSetup(0);
        InitializePsychSound(0);
        [Y, Fs] = audioread(sprintf('Stimuli/Behaviour_Stimuli_%d/%d.wav',i,j));
        pahandle = PsychPortAudio('Open', [], [], 1, Fs, 2);
        PsychPortAudio('FillBuffer', pahandle, Y');
        PsychPortAudio('Start',pahandle,1,0);
        
        DrawFormattedText(windowPtr,'+' ,'center','center',white); 
        Screen('Flip', windowPtr)
        pause(4.2);
        
        %reset audio
        if ~isempty(pahandle)
           count = PsychPortAudio('GetOpenDeviceCount');
           if count > 0 
               PsychPortAudio('Close', pahandle);
           end
        end
        
        % get response of starting chord
        BHText = 'What was the starting chord?\n\n 1 = Tonic(I)\n 2 = Submediant(vi)';
        DrawFormattedText(windowPtr,BHText,'center','center',white); 
        Screen('Flip', windowPtr);

        keyIsDown = 0;
        while ~keyIsDown
             [keyIsDown, pressedSecs, keyCode] = KbCheck(-1);
        end
        pressedKey = KbName(find(keyCode));

        BH_key_response_starting_chord(i,j) = pressedKey - '0';
        pause(0.5);
        
        % get response of ending chord
        BHText = 'What was the ending chord?\n\n 1 = Tonic(I)\n 2 = Submediant(vi)\n 3 = Supertonic(ii)';
        DrawFormattedText(windowPtr,BHText,'center','center',white); 
        Screen('Flip', windowPtr);

        clear keyIsDown pressedSecs keyCode
        keyIsDown = 0;
        while ~keyIsDown
             [keyIsDown, pressedSecs, keyCode] = KbCheck(-1);
        end
        
        pressedKey = KbName(find(keyCode));
        BH_key_response_ending_chord(i, j) = pressedKey - '0';
        
  
    end
    
    
end



%% closing section

DrawFormattedText(windowPtr,['Thank you.','\n\n', 'Please wait for the next experiment.'], 'center', 'center', white);
Screen('Flip',windowPtr);
pause(1);

% closing
Screen('CloseAll');
sca; ShowCursor;

% save data
save(sprintf('chord_ftn_behaviour_experiment_%s.mat',subID));