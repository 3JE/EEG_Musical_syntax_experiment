% last modifed 20181201 by eunjin
% function for plotting ERPs with specified channel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input : 
% subjectID : which subject?
% position : position in a sequence / value can be 1 to 6
% channel : channel to plot
% ERPs : epoched & averaged data 
% Time : time interval of epoched data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_ERPs(subjectID, position, channel, ERPs, Time)

        range = [min(Time{position}) max(Time{position})];
        I_ERP_Fz(1,:) = ERPs{position}{1}(:,channel)';
        I_ERP_Fz(2,:) = ERPs{position}{2}(:,channel)';
        I_ERP_Fz(3,:) = ERPs{position}{3}(:,channel)';
        vi_ERP_Fz(1,:) = ERPs{position}{4}(:,channel)';
        vi_ERP_Fz(2,:) = ERPs{position}{5}(:,channel)';
        vi_ERP_Fz(3,:) = ERPs{position}{6}(:,channel)';

        avgI = mean(I_ERP_Fz,1);
        avgvi = mean(vi_ERP_Fz,1);
    
        figure(10);
        plot(Time{position},avgI);
        hold on;
        plot(Time{position},avgvi);
        hold on;
        legend('I','vi');
        hold on;
        title(sprintf('sub%d : %d chord Fz avg',subjectID,position));

        xlabel('Time(ms)','fontsize',25);
        ylabel('Amplitude(uV)','fontsize',25);
        xlim(range);
        ylim([-4 10]);

        set(gca,'fontsize',15);

        saveas(gcf, sprintf('sub%d/sub%d_%d chord Fz avg.fig',subjectID,subjectID,position));
        saveas(gcf, sprintf('sub%d/sub%d_%d chord Fz avg.png',subjectID,subjectID,position));

        % plotting
        figure(11);
        plot(Time{position},ERPs{position}{1}(:,channel));
        hold on;
        plot(Time{position},ERPs{position}{2}(:,channel));
        hold on;
        plot(Time{position},ERPs{position}{3}(:,channel));
        hold on;
        plot(Time{position},ERPs{position}{4}(:,channel));
        hold on;
        plot(Time{position},ERPs{position}{5}(:,channel));
        hold on;
        plot(Time{position},ERPs{position}{6}(:,channel));

        legend('I-I','I-vi','I-ii','vi-I','vi-vi','vi-ii');
        hold on;

        title(sprintf('sub%d : %d chord Fz',subjectID,position));
        xlabel('Time(ms)','fontsize',25);
        ylabel('Amplitude(uV)','fontsize',25);
        xlim(range);
        ylim([-4,10]);
        
        set(gca,'fontsize',15);

        saveas(gcf, sprintf('sub%d/sub%d_%d chord Fz.fig',subjectID, subjectID,position));
        saveas(gcf, sprintf('sub%d/sub%d_%d chord Fz.png',subjectID, subjectID,position));

        close all;
end