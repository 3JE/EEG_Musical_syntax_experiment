% last modified by Eunjin, 20181202
% If you have any question during using these code, please send email to Eunjin(contact : jin980302@gmail.com).
% These matlab codes are written by Eunjin, during MARG intern(2018.07.02-2018.11.30).
% Cap_coords_all.xls, Cap_coords_all.xlsx, load_bio_chanloc.m files were provided by MARG
% All sound stimuli were generated from MuseScore 2. 
% EEG(64 + 3 channels) was recorded by using BioSemi EEG System.


There is one EEG data file and experiment and behaviour result(subject 1) which is publically available, for testing analysis code.
Due to the limitation of file size that I can upload in Github, I uploaded it on google drive. You can download it via links below.
https://drive.google.com/open?id=1OalhfcKVsz0zGrh6i_isxDzvBqDF7CYl
After downloading Data folder, move it in Analysis folder so that the relative path is like this : .../Musical_syntax_experiment/Analysis/Data/....

Before running code, please check you already installed psychtoolbox(ver. 3.0.8 or greater), and EEGlab(ver. 14_1_2b or greater)
You can download these toolbox via links below.
http://psychtoolbox.org/download.html
https://sccn.ucsd.edu/eeglab/index.php


% How to use
1. Making stimuli
- run "script_run_make_stimuli.m" file. 
: since the algorithm of generation of randomize order is not really delicate(sometimes it goes to infinity loop due to randomization rule), 
if the message "generate random sequence successfully!" is not shown immediately(it should be in 1 sec), 
please stop the script and re-run "script_run_make_stimuli.m" file.

2. Experiment presentation
- run "script_exp_chord_ftn.m" file. for behaviour session, run "script_exp_chord_ftn_BH.m" file.
: debug mode is for debugging, making it easier to debug by displaying the experiment screen on the default monitor.

3. Analysis
- run "script_analysis_chord_ftn.m" file.
: by default, the script read the subject 1 EEG data file and do preprocessing and epoching.
before running this script, make sure that you've already added eeglab folder to path.
  
- run "script_plot_ERP.m" file.
: you can get topoplot image in ERAN and N5 window and ERP graph depending on chord position, and starting chord.

4. Behaviour analysis 
- run "script_behaviour_accuracy_calculate.m" file.
: you can get a plot of behaviour accuracy.


% About experiment

% Stimuli
Stimuli is a chord sequence consisting of 6 chords.
Duration of each chord is 600ms(ending chord : 1200ms), therefore it tooks total 4.2 sec for one trial.
There are total 6 conditions.
- Starting I -> ending I, vi, ii
- Starting vi -> ending I, vi, ii

% Experiment
1) Experiment session
Experimnet session consists of 8 blocks.
Each block consists of 15 trials * 6conditions + 10 timbre deviant(different instrument sound), making total 800 trials, total duration about 1h 10min.
Participants watched a silent movie ¡°You¡¯ve got Mail¡± with Korean subtitle.
And their task was irrelevant task with the experiment; detecting deviant sound, deviant trials were not used during analysis.
* Instruction : When you hear deviant sound(different instrument sound rather than piano), press key #1 ASAP.

2) Behaviour session
Behaviour session consists of 3 blocks
Each block consists of 72 trials(12 trials * 6 conditions), making total duration about 20 min.
Same stimuli as experiment session were used for behaviour session.
Participants were instructed to determine the starting and ending chord function and respond using a keyboard
#1 for tonic(I), #2 for submediant(vi), #3 for supertonic(ii)

*Total experiment took approximately 2.5 hours including preparation, EEG recording, behavioral testing, clean up.
