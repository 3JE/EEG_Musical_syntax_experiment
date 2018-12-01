% last modifed 20181201 by eunjin
% script for calculate latency of new event
% output : 
% Standard ; 800(total trial number) * 6(chord seq number) matrix which 
% stores latency value
% due to some problems with trigger event 100, from subject 2, trigger event is modified as 10 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

STD(1:length(EEG.event),1:6) = -1; % temporary variables for saving latency of standard trial

% variables to check the number of trigger in EEG data
count_std = 0;
count_dev = 0;
count_254 = 0;
count_255 = 0;

% due to some problems with trigger event 100, from subject 2, trigger event is modified as 10 
if subjectID == 1
    standard_event = 100;
else
    standard_event = 10;
end

for i=1:length(EEG.event)

if EEG.event(1,i).type == standard_event % standard
    count_std = count_std + 1;
    STD(count_std,1) = EEG.event(1,i).latency;
    STD(count_std,2) = STD(count_std,1) + 153.6; % 600ms latency ==> 153.6(256hz * 0.6) since 
    STD(count_std,3) = STD(count_std,2) + 153.6; 
    STD(count_std,4) = STD(count_std,3) + 153.6;
    STD(count_std,5) = STD(count_std,4) + 153.6;
    STD(count_std,6) = STD(count_std,5) + 153.6;
else if EEG.event(1,i).type == 120 % deviant
    count_dev = count_dev + 1;       
    else if EEG.event(1,i).type == 254 % pause off trigger
            count_254 =count_254+1;
        else if EEG.event(1,i).type == 255 % pause on trigger
                count_255 = count_255 +1;
            end    
        end
        
    end
end


end

if subjectID == 1    
    Standard = STD(6:805,:); % first 5 events were not real trigger(problem with trigger event number 100)
else
    Standard = STD(1:800,:); %saving
end