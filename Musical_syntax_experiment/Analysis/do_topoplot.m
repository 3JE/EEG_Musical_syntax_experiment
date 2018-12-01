% last modifed 20181201 by eunjin
% function for topoplotting to compare starting / ending chord
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input : 
% subjectID : which subject?
% ERP_all_trials : epoched data for all trials
% ERPs : epoched & averaged data 
% Time : time interval of epoched data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function do_topoplot(subjectID, ERP_all_trials, ERPs, Time)

    % choose time window
    a = input('type number(1 = ERAN / 2 =  N5) :');
    if a == 1
        window = [150 210];
    else
        window = [500 600];
    end

    % get time interval of epoched data
    t = Time{6};

    time = find(t> window(1) & t < window(2)); % time interval for topoplot

    % averaging ERP of that time interval for 6 conditions
    I = mean(ERPs{6}{1}(time,:))';
    vi = mean(ERPs{6}{2}(time,:))';
    ii = mean(ERPs{6}{3}(time,:))';

    viI = mean(ERPs{6}{4}(time,:))';
    vivi = mean(ERPs{6}{5}(time,:))';
    viii = mean(ERPs{6}{6}(time,:))';
    
    ch_location = ERP_all_trials{6}{1}.chanlocs(1:64);
    
    % do topoplot
    compare = input('type which chord to compare?(1 = starting chord / 2 = ending chord)');
    if compare == 1
        figure; sgtitle(sprintf('subject%d, %d~%dms',subjectID,window(1),window(2))); subplot(4,3,1); topoplot(I(1:64), ch_location)
        colorbar()
        title('I - I chord, 6th position');    
        subplot(4,3,2); topoplot(vi(1:64), ch_location)
        title('I - vi chord, 6th position');
        colorbar()
        subplot(4,3,3); topoplot(vi(1:64) - I(1:64), ch_location); colorbar()
        title('difference');

        subplot(4,3,4); topoplot(I(1:64), ch_location)
        colorbar()
        title('I - I chord, 6th position');    
        subplot(4,3,5); topoplot(ii(1:64), ch_location)
        title('I - ii chord, 6th position');
        colorbar()
        subplot(4,3,6); topoplot(ii(1:64) - I(1:64), ch_location); colorbar()
        title('difference');

        subplot(4,3,7); topoplot(viI(1:64), ch_location)
        colorbar()
        title('vi - I chord, 6th position');    
        subplot(4,3,8); topoplot(vivi(1:64), ch_location)
        title('vi - vi chord, 6th position');
        colorbar()
        subplot(4,3,9); topoplot(vivi(1:64) - viI(1:64), ch_location); colorbar()
        title('difference');

        subplot(4,3,10); topoplot(viI(1:64), ch_location)
        colorbar()
        title('vi - I chord, 6th position');    
        subplot(4,3,11); topoplot(viii(1:64), ch_location)
        title('vi - ii chord, 6th position');
        colorbar()
        subplot(4,3,12); topoplot(viii(1:64) - viI(1:64), ch_location); colorbar()
        title('difference');

        %saving data
        saveas(gcf,sprintf('sub%d/sub%d topoplot ending chord difference %d-%dms.fig',subjectID, subjectID, window(1), window(2)));
        saveas(gcf,sprintf('sub%d/sub%d topoplot ending chord difference %d-%dms.png',subjectID, subjectID, window(1), window(2)));

    else
        figure; sgtitle(sprintf('subject%d, %d~%dms',subjectID,window(1),window(2))); subplot(3,3,1); topoplot(I(1:64), ch_location)
        colorbar()
        title('I - I chord, 6th position');    
        subplot(3,3,2); topoplot(viI(1:64), ch_location)
        title('vi - I chord, 6th position');
        colorbar()
        subplot(3,3,3); topoplot(viI(1:64) - I(1:64), ch_location); colorbar()
        title('difference');

        subplot(3,3,4); topoplot(vi(1:64), ch_location)
        colorbar()
        title('I - vi chord, 6th position');    
        subplot(3,3,5); topoplot(vivi(1:64), ch_location)
        title('vi - vi chord, 6th position');
        colorbar()
        subplot(3,3,6); topoplot(vivi(1:64) - vi(1:64), ch_location); colorbar()
        title('difference');

        subplot(3,3,7); topoplot(ii(1:64), ch_location)
        colorbar()
        title('I - ii chord, 6th position');    
        subplot(3,3,8); topoplot(viii(1:64), ch_location)
        title('vi - ii chord, 6th position');
        colorbar()
        subplot(3,3,9); topoplot(viii(1:64) - ii(1:64), ch_location); colorbar()
        title('difference');

        saveas(gcf,sprintf('sub%d/sub%d topoplot starting chord difference %d-%dms.fig',subjectID, subjectID, window(1), window(2)));
        saveas(gcf,sprintf('sub%d/sub%d topoplot starting chord difference %d-%dms.png',subjectID, subjectID, window(1), window(2)));
    end
end