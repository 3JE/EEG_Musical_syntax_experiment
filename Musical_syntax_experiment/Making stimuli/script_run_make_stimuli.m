
%% generate randomize order
n_key = 12; % number of key
n_chord = 6; % number of chord conditions

stimuli_type = input('type stimuli type(1 = experiment / 2 = behaviour) : ');
if stimuli_type == 1
    script_chord_seq_generate;
    n_condition = 15; % number of trials for each condition
    n_trial = 100; % number of total trials
    n_dev = 10;
else
    script_chord_seq_generate_behaviour;
    n_condition = 12;
    n_trial = 72;
    n_dev = 0;
end

%% validation
VAL_k(1:n_key,2) = -1; % stores the number of each key in total trial 
VAL_c(1:n_chord,2) = -1; % stores the number of each chord condition in total trial
    
for i=1:n_key  
    VAL_k(i,:) = size(find(key==i));
end
    
for j=1:n_chord
    VAL_c(j,:) = size(find(chord==j));
    if VAL_c(j,2) ~= n_condition
        error('chord randomization failed!');
    else
        fprintf('chords are in good state\n');
    end
        
end
    
if sum(VAL_k(:,2)) ~= n_trial - n_dev  % if total sum of each key was not as same as trial
    error('randomization failed!');
else
    fprintf('all keys are in good state\n');
end
    
a = input('do you want to save this stimuli order?(1 = yes / 0 = no) :');
if a == 1
    %filename = input('type file name :');
    %save(sprintf('%s.mat',filename),chord);
    if stimuli_type == 1
        save('StimuliInfo.mat','chord');
    else
        save('Behaviour_chord_info.mat','chord');
    end
end


%% make stimuli from randomized seq and original wav file
% read .wav files and parsing them every 4.2sec
wavfile = dir('Originalwav/*.wav'); % get names of all .wav files
y = cell(12,6); % variable for saving all chord seq
d = cell(1,10);
Fs = 44100; % sampling rate
T = 4.2*Fs; % duration for chord seq (4.2sec * sampling rate)

% standard
for i=1:12
    for j=1:6
        sample_T = [(j-1)*T + 1, j*T];
        [y{i, j} Fs] = audioread(sprintf('Originalwav/%s',wavfile(i).name), sample_T);
    end
end

% deviant
for j=1:10
    sample_T = [(j-1)*T + 1, j*T];
    [d{1, j} Fs] = audioread(sprintf('Originalwav/%s',wavfile(13).name), sample_T);
end

Y = [];
SEQ = cell(n_block,n_trial);
for i=1:n_block
    for j=1:n_trial
       if key(i,j) > n_trial
           SEQ{i,j} = d{1,key(i,j)-n_trial};
       else
           SEQ{i,j} = y{key(i,j),chord(i,j)};
       end 
    end
end

%% export .wav file    
for i=1:n_block
    folder_name = input('type the new folder name with quotes : ');
    mkdir(folder_name);
    for j=1:n_trial
        audiowrite(sprintf('%s/%d.wav',folder_name,j),SEQ{i,j},Fs);
    end
end



