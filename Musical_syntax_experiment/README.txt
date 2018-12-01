% last modified by Eunjin, 20181202
% If you have any question during using these code, please send email to Eunjin(contact : jin980302@gmail.com).
% These matlab codes are written by Eunjin, during MARG intern(2018.07.02-2018.11.30).
% Cap_coords_all.xls, Cap_coords_all.xlsx, load_bio_chanloc.m files were provided by MARG
 
There is one EEG data file and experiment and behaviour result(subject 1) which is publically available, for testing analysis code.
Before running code, please check you already installed psychtoolbox(ver. 3.0.8 or greater), and EEGlab(ver. 14_1_2b or greater)
You can download these toolbox via links below.
http://psychtoolbox.org/download.html
https://sccn.ucsd.edu/eeglab/index.php

All sound stimuli are generated from MuseScore 2. 
EEG(64 + 3 channels) was recorded by using BioSemi EEG System.

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