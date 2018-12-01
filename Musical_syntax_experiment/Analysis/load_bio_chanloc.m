function EEG = load_bio_chanloc(EEG,numchan)

if sum(find([16,32,64,128,160,256] == numchan))
    sheet_name = [num2str(numchan),'-chan'];
else
    error('you should enter right # of channels');
end

cell_number_label = ['A35:A', num2str(35+numchan-1)];
cell_number_coord = ['F35:H' num2str(35+numchan-1)];

[~,label] = xlsread('Cap_coords_all.xlsx',sheet_name,cell_number_label);
coord = xlsread('Cap_coords_all.xlsx',sheet_name,cell_number_coord);
coord = coord/100;

for i = 1:numchan
    EEG.chanlocs(i).labels = label{i};
    EEG.chanlocs(i).X = -coord(i,1);
    EEG.chanlocs(i).Y = -coord(i,2);
    EEG.chanlocs(i).Z = coord(i,3);
%     EEG.chanlocs(i).radius = 
%     EEG = pop_chanedit(EEG,'changefield', {i, 'labels', label{i}});
%     EEG = pop_chanedit(EEG,'changefield', {i, 'X', coord(i,1)});
%     EEG = pop_chanedit(EEG,'changefield', {i, 'Y', coord(i,2)});
%     EEG = pop_chanedit(EEG,'changefield', {i, 'Z', coord(i,3)});
end

EEG = pop_chanedit(EEG,'convert','cart2topo');