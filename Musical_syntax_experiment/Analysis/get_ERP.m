% last modifed 20181201 by eunjin
% function for get ERPs for chord experiment
% do epoching, baseline removal, artifact rejection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input : 
% EEG_eyerm : EEG data after ICA)
% position : position in a sequence / value can be 1 to 6
% range : range to epoch(unit : sec) / example : [-0.2 0.6]
% beseline_removal : remove baseline when baseline_removal is 1 / else, 0
% v_thresh : threshold of artifact rejection(unit : uV)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output :
% ERPs_all_trials : EPOCHED data for all trials
% ERP : averaged(trials) EPOCHED data
% Time : time interval of EPOCHED data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ERPs_all_trials, ERPs, Time]= get_ERP(EEG_eyerm, position, range, baseline_removal, v_thresh) 

    % error handling
    if position < 1 || position > 6
        error('wrong position value error. position value should be between 1~6');
    end

    I{1} = pop_epoch( EEG_eyerm, {sprintf('1%d',position)}, range, 'epochinfo', 'yes');
    I{2} = pop_epoch( EEG_eyerm, {sprintf('2%d',position)}, range, 'epochinfo', 'yes');
    I{3} = pop_epoch( EEG_eyerm, {sprintf('3%d',position)}, range, 'epochinfo', 'yes');
    vi{1} = pop_epoch( EEG_eyerm, {sprintf('4%d',position)}, range, 'epochinfo', 'yes');
    vi{2} = pop_epoch( EEG_eyerm, {sprintf('5%d',position)}, range, 'epochinfo', 'yes');
    vi{3} = pop_epoch( EEG_eyerm, {sprintf('6%d',position)}, range, 'epochinfo', 'yes');

    if baseline_removal == 1
        % 5.Remove baseline
        I{1} = pop_rmbase(I{1}, [-200 0]); % unit: ms 
        I{2} = pop_rmbase(I{2}, [-200 0]); % unit: ms 
        I{3} = pop_rmbase(I{3}, [-200 0]); % unit: ms 
        vi{1} = pop_rmbase(vi{1}, [-200 0]); % unit: ms 
        vi{2} = pop_rmbase(vi{2}, [-200 0]); % unit: ms 
        vi{3} = pop_rmbase(vi{3}, [-200 0]); % unit: ms 
    end

    %artifact rejection
    [cI{1}, b]=pop_autorej(I{1}, 'threshold', v_thresh, 'nogui', 'on');
    [cI{2}, b]=pop_autorej(I{2}, 'threshold', v_thresh, 'nogui', 'on');
    [cI{3}, b]=pop_autorej(I{3}, 'threshold', v_thresh, 'nogui', 'on');
    [cvi{1}, b]=pop_autorej(vi{1}, 'threshold', v_thresh, 'nogui', 'on');
    [cvi{2}, b]=pop_autorej(vi{2}, 'threshold', v_thresh, 'nogui', 'on');
    [cvi{3}, b]=pop_autorej(vi{3}, 'threshold', v_thresh, 'nogui', 'on');

    % averaging
    I_ERP{1}=mean(cI{1}.data,3)';
    I_ERP{2}=mean(cI{2}.data,3)';
    I_ERP{3}=mean(cI{3}.data,3)';
    vi_ERP{1}=mean(cvi{1}.data,3)';
    vi_ERP{2}=mean(cvi{2}.data,3)';
    vi_ERP{3}=mean(cvi{3}.data,3)';

    % return values
    ERPs_all_trials = { cI{1}, cI{2}, cI{3}, cvi{1}, cvi{2}, cvi{3} };
    ERPs = { I_ERP{1}, I_ERP{2}, I_ERP{3}, vi_ERP{1}, vi_ERP{2}, vi_ERP{3} };
    Time = cI{1}.times;
    
    close all;
end