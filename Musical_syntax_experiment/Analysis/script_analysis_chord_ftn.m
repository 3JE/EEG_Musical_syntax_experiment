% last modifed 20181201 by eunjin
% script for musical syntax experiment analysis
% read EEG data(.bdf file), do preprocessing, and epoch data

%setting
clear all
close all
clc

n_subject = 1; % number of subjects
abs = pwd; % save abosolute path of current folder
infilepath = sprintf('%s/Data/Experiment_data',abs); % should be absolute path 
outfilepath = sprintf('%s/Data/Preprocessed_data',abs); % absolute path for saving data
erpfilepath = sprintf('%s/Analysis/Data/Epoched_data',abs); % absolute path for erp data
ch = 64; % number of channels
sample_rate = 256; % resample rate
    
for subjectID = 1:n_subject
    clearvars -except n_subject infilepath outfilepath ch sample_rate subjectID

    % read .bdf file
    filename = sprintf('eunjin_sub%d.bdf',subjectID);
    EEG = pop_biosig(fullfile(infilepath,filename), 'channels', [1:67], 'importevent','on'); %data reading
    EEG = load_bio_chanloc(EEG,ch);
    
    % Re-reference the data to average of 2 mastoids
    % EXG1(65) = EOG / EXG2(66) = left mastoid / EXG3(67) = right mastoid
    reref = input('rereferencing(1 = 64 channel avg, 2 = mastoid avg) : ');
    if reref == 1
        EEG = pop_reref( EEG, [],'exclude',[65 66 67]);
    else 
        EEG = pop_reref( EEG, [66 67]);
    end
    
    % Downsampling to 256Hz
    EEG = pop_resample(EEG, sample_rate);
  
    % saving file
    if reref == 1
        outfilename = sprintf('%s/sub%d_64_%d',outfilepath,subjectID,sample_rate);
    else
        outfilename = sprintf('%s/sub%d_mastoid_%d',outfilepath,subjectID,sample_rate);
    end
    
    save(sprintf('%s.mat',outfilename));
    
    % Bandpass filtering
    filt_low = 0.5;
    filt_high = 40;
    EEG = pop_eegfiltnew(EEG, filt_low, filt_high, [], [0]);
    
    %bad channel interpolation
    pop_eegplot(EEG);
    badCh=input('type rejection channel number :');
    EEG=eeg_interp(EEG,badCh);
    
    % Eyeblink rejection
    EEG_eyerm=pop_runica(EEG,'icatype','runica','chanind',[1:65]);
    pop_topoplot(EEG_eyerm, 0,[1:ch],'ICA');
    cnumb=input('type component number to reject :');
    EEG_eyerm=pop_subcomp(EEG_eyerm, cnumb, 1);
    remainingchnum=ch-length(cnumb);
    pop_topoplot(EEG_eyerm, 0, [1:remainingchnum], 'component weight');

    %saving preprocessed file
    outfilename = sprintf('%s_L%d_H%d_ICA',outfilename,filt_low,filt_high);
    save(sprintf('%s.mat',outfilename));
    
    % calculate latency of each chord's trigger point and paste it to EEG.event
    load('StimuliInfo.mat');
    script_latency_calculate;
    script_sudoevent_calculate;

    % range for epoch : unit(sec)
    range1 = [-0.2 0.6]; 
    range2 = [-0.2 1.2];
    v_thresh = 20; % threshold of artifact rejection(uV)
    
    % make directory
    fullPath = sprintf('%s/sub%d',erpfilepath,subjectID);
    if ~exist(fullPath , 'dir')
        % Folder does not exist so create it.
        mkdir(fullPath );
    end
   
   % load EEG data ad get ERP
   [ERP_all_trials{2}, ERPs{2}, Time{2}] = get_ERP(EEG_eyerm, 2, range1, 0, v_thresh);
   [ERP_all_trials{3}, ERPs{3}, Time{3}] = get_ERP(EEG_eyerm, 3, range1, 1, v_thresh);
   [ERP_all_trials{4}, ERPs{4}, Time{4}] = get_ERP(EEG_eyerm, 4, range1, 1, v_thresh);
   [ERP_all_trials{5}, ERPs{5}, Time{5}] = get_ERP(EEG_eyerm, 5, range1, 1, v_thresh);
   [ERP_all_trials{6}, ERPs{6}, Time{6}] = get_ERP(EEG_eyerm, 6, range2, 1, v_thresh);
   
   % save ERP data
   save(sprintf('Data/Epoched_data/sub%d/sub%d_ERPs.mat',subjectID,subjectID), 'ERP_all_trials','ERPs','Time', 'subjectID');

end