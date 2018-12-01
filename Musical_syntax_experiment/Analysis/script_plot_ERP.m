% last modifed 20181201 by eunjin
% script for plotting epoched data

n_subject = 6; %number of subjects
channel = 38; % number of channel to plot

for a=1:n_subject
    clearvars -except n_subject channel a
    
    %load ERP data
    load(sprintf('Data/Epoched_data/sub%d_ERPs.mat',a));
   
   % make directory
   abs = pwd;
   fullPath = sprintf('%s/sub%d',abs,a);
    if ~exist(fullPath , 'dir')
        % Folder does not exist so create it.
        mkdir(fullPath );
    end
    % do topoplot
    do_topoplot(a, ERP_all_trials, ERPs, Time);
    
    % plot_ERP
    for position = 2:6
         plot_ERPs(a, position, channel, ERPs, Time);
    end
end
