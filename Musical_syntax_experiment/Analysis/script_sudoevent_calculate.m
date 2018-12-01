% last modifed 20181201 by eunjin
% script for calculate sudoevent and update it as EEG_eyerm.event
% after running this script, the event is updated as ab;
% a = condition number(1~6), b= location of chord in a seq(1~6) 

n_blocks = 8; % number of blocks
n_trials = 100; % number of trials in a block
n_chords = 6; % number of chords in seq

%event setting
for i=1:n_blocks
    for j=1:n_trials
        t = n_trials*(i-1) + j;
        indx = n_trials*n_blocks*(i-1) + n_chords*(j-1);
        for k=1:n_chords            
            indx = indx + 1;
            if chord(i,j) > 100 % deviant event
                sudoevent(indx).type = 120+k; 
            else % standard event
                sudoevent(indx).type = chord(i,j)*10+k;
            end
            sudoevent(indx).latency = Standard(t,k);
            sudoevent(indx).urevent = indx;
        end
    end
end

%urevent setting
for i=1:n_blocks*n_trials*n_chords
    sudourevent(i).type = sudoevent(i).type;
    sudourevent(i).latency = sudoevent(i).latency;
end

%update
event_after_resample = EEG_eyerm.event;
urevent_after_resample = EEG_eyerm.urevent;
EEG_eyerm.event = sudoevent;
EEG_eyerm.urevent = sudourevent;
