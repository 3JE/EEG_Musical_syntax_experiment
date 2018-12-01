% last modifed 20181201 by eunjin
% script for calculating behaviour accuracy

clear all

load('Behaviour_chord_info.mat');
load('StimuliInfo.mat');
last_subject = 1; % total 6 subject

% calculate ending chord answer
BH_e_ans = [chord_b1;chord_b2;chord_b3];
for i=1:3
    for j=1:72
        if BH_e_ans(i,j) > 3
            BH_e_ans(i,j) = BH_e_ans(i,j) - 3;
        end
    end
end

% calculate starting chord answer
BH_s_ans = [chord_b1;chord_b2;chord_b3];
for i=1:3
    for j=1:72
        if BH_s_ans(i,j) > 3
            BH_s_ans(i,j) = 2;
        else
            BH_s_ans(i,j) = 1;
        end
    end
end

dev_accuracy(1) = 0;
e_accuracy(1) = 0;
s_accuracy(1) = 0;

for i=1:last_subject
    
load(sprintf('Behaviour_result/chord_ftn_behaviour_experiment_sub%d.mat',i),'BH_key_response_ending_chord', 'BH_key_response_starting_chord');
load(sprintf('Experiment_result/chord_ftn_experiment_sub%d.mat',i),'key_response_T');

dev_accuracy(i) = sum(sum((chord > 100)==key_response_T)) / 800 * 100
e_accuracy(i) = sum(sum(BH_e_ans == BH_key_response_ending_chord))/(72*3) * 100
s_accuracy(i) = sum(sum(BH_s_ans == BH_key_response_starting_chord))/(72*3) * 100

end
save('Behaviour_accuracy_all_sub.mat','e_accuracy','s_accuracy','dev_accuracy');

figure(1);
subplot(1,3,1);
bar(s_accuracy);
title('detecting starting chord accuracy');
xlabel('subject number');
ylabel('accuracy(%)');

subplot(1,3,2);
bar(e_accuracy);
title('detecting ending chord accuracy');
xlabel('subject number');
ylabel('accuracy(%)');


subplot(1,3,3);
bar(dev_accuracy);
title('detecting timbre deviant accuracy');
xlabel('subject number');
ylabel('accuracy(%)');


saveas(gcf,'accuracy_all_trials.png');
saveas(gcf,'accuracy_all_trials.fig');
