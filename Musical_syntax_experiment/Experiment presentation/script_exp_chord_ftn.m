% last modifed 20181029 by eunjin
% script for musical syntax experiment session presentation with psychtoolbox

Screen('Preference', 'SkipSyncTests', 1);

%% setting
clear all; close all; clc;

n_subject = 1; %subject number

n_block = 1;  %total 8 blocks
n_trial = 10; % number of chords 100 per one block

key_response_T(1:n_block,1:n_trial) = 0;  %initialize memory space for saving key response(key value)
key_down(1:n_block, 1:n_trial) = 0;

Fs = 44100; % sampling frequency

% color
white = [255 255 255];  
black = [0 0 0];  

% Screen
%ScreenNumber = 0; % one monitor
screens = Screen('Screens');
ScreenNumber = max(screens);
[width, height] = Screen('WindowSize', ScreenNumber); % present screen size1

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


%% Experiment session

ExpText = '1. experiment session';
DrawFormattedText(windowPtr,ExpText,'center','center',white); 
Screen('Flip', windowPtr); 
pause(2);
%Video_list = dir('Video/*.mp4');
load('StimuliInfo.mat'); % load stimuli 

% every session(block) starts when any button is pressed
BlockText = 'Press any key to start the experiment session : \n\n during the session, if you find any timbre deviant,\n\n which has different instrument sound rather than piano, press key 1 ASAP';
DrawFormattedText(windowPtr,BlockText,'center','center',white); 
Screen('Flip', windowPtr); 
% waits until all keys on the keyboard are released : -1 means device number(all keyboard devices will be checked)        
KbStrokeWait(-1);    
   
for i=1:n_block % for every block
    
    % start checking time when button is pressed(starting time of session)  
    
    % pause on 
    outputSingleScan(session, dec2binvec(255,8));
    outputSingleScan(session, dec2binvec(0,8));
    
%    fname_movie = [fname_videolist(i).folder,'\',fname_videolist(i).name];

%    [movie, movieDuration] = Screen('OpenMovie', windowPtr, fname_movie,[],[],2);
        
%    Screen('PlayMovie',movie,1,0,0);
    
    DrawFormattedText(windowPtr,'+' ,'center','center',white); 
    Screen('Flip', windowPtr);
    
    for j=1:n_trial % for every trial
        
        % prepare sound presentation
        PsychDefaultSetup(0);
        InitializePsychSound(0);
        [Y, Fs] = audioread(sprintf('Stimuli/Stimuli_%d/%d.wav',i,j)); 
        pahandle = PsychPortAudio('Open', [], [], 1, Fs, 2);
        PsychPortAudio('FillBuffer', pahandle, Y');
        
        % pause off : recording start
        outputSingleScan(session, dec2binvec(254,8));
        outputSingleScan(session, dec2binvec(0,8));
        pause(0.5);
        
        PsychPortAudio('Start',pahandle,1,0); % play sound 
        
        % Trigger marked at the beginning of the audio file
        outputSingleScan(session, dec2binvec(10,8));
        outputSingleScan(session, dec2binvec(0,8));
        
        % additional timbre deviant trigger 
        if chord(i,j) >= 100
            outputSingleScan(session, dec2binvec(120,8));
            outputSingleScan(session, dec2binvec(0,8));
        end
        
        onsetTime = GetSecs; % measure current time
        
        while GetSecs < onsetTime + 4.2  %key can be pressed for response during presentation time(4.2sec)
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1); % keyboard checking
            if keyIsDown %if any key is pressed, first GetSecs value is stored in keyTime for this trial
                %disp( secs - onsetTime );
                disp( KbName(keyCode) ); 
                key_response_T(i,j) = KbName(find(keyCode)) - '0';
            end
        end
        
        % pause on : end recording
        outputSingleScan(session, dec2binvec(255,8));
        outputSingleScan(session, dec2binvec(0,8));
        
        %reset audio
        if ~isempty(pahandle)
           count = PsychPortAudio('GetOpenDeviceCount');
           if count > 0 
               PsychPortAudio('Close', pahandle);
           end
        end
        
    end 
            % Screen
            %while 1
            % Wait for next movie frame, retrieve texture handle to it
            %tex = Screen('GetMovieImage', windowPtr, movie);

            % Valid texture returned? A negative value means end of movie reached:
            %if tex<=0
                % We're done, break out of loop:
            %    break;
            %end

            % Draw the new texture immediately to screen:
            %Screen('DrawTexture', windowPtr, tex);

            % Update display:
            %Screen('Flip', windowPtr);

            % Release texture:
            %Screen('Close', tex);
            %end
    
            %Screen('PlayMovie', movie, 0);
            %Screen('CloseMovie', movie);
  %  [keyIsDown, secs, keyCode] = KbCheck; %keyIsDown is a boolean var that is set to 1 when any key is pressed   
end




%% closing section

DrawFormattedText(windowPtr,['Thank you.','\n\n', 'Please wait for the next experiment.'], 'center', 'center', white);
Screen('Flip',windowPtr);
pause(1);

% closing
Screen('CloseAll');
sca; ShowCursor;

% save data
save(sprintf('chord_ftn_experiment_%s.mat',subID));
