%%
% visualizzazione immaignir di perf. renale
%%
clear 


close all
clc

% Fetta n. 5 per 70 time-steps
NomeFile = 'Slice5_Time';
figure;
for nImm = 1:70
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    time = INF.TriggerTime;
    imagesc(IMM),colormap gray, title(['imm N. ' num2str(nImm),' time: ', num2str(time),' ms' ]), axis off
    pause(0.5);
   
end