%%
% visualizzazione immagini Modulo (Amplitude) e Fase (PhaseContrast) MRI
%%
clear
close all
clc

% 80 time-steps
NomeFileModulo = 'Amplitude';
NomeFilePC = 'PhaseContrast';

figure;
for nImm = 1:80
    ImmModulo = dicomread([NomeFileModulo, num2str(nImm),'.dcm']);
    ImmPC = dicomread([NomeFilePC, num2str(nImm),'.dcm']);
    Inf = dicominfo([NomeFilePC, num2str(nImm),'.dcm']);
    time = Inf.TriggerTime;
    subplot(1,2,1),imagesc(ImmModulo),colormap gray, axis off,...
        title(['Amplitude     (Time: ' num2str(Inf.TriggerTime) 'ms)']);
    drawnow
    subplot(1,2,2),imagesc(ImmPC),colormap gray, axis off,...
        title('Phase Contrast');
    drawnow
    Vm(:,:,nImm)=ImmModulo;
    Vp(:,:,nImm)=ImmPC;
    t(nImm) = time;
end
Vscale = 0.81;% s/m