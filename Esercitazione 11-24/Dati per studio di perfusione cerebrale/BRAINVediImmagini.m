

%%
% visualizzazione immaignir di perf. cerebrale
%%
clear 
close all
clc

% Fetta n. 9 per 39 time-steps
NomeFile = 'bp_Slice9_Time';
figure;
for nImm = 1:39
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    time = INF.TriggerTime;
    imagesc(IMM),colormap gray, title(['imm N. ', num2str(nImm),' time: ', num2str(time),' ms' ]), axis off
    pause(.5);
   
end