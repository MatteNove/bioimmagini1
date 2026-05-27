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






%%
%matrici modulo e fase
L=256;
N=80;
Matrice_Modulo=zeros(L,L,N);
Matrice_Fase=zeros(L,L,N);
time=zeros(N,1);
for i=1:80
    Matrice_Modulo(:,:,i)=dicomread([NomeFileModulo, num2str(i),'.dcm']);
    Matrice_Fase(:,:,i)=dicomread([NomeFilePC, num2str(i),'.dcm']);
    Inf = dicominfo([NomeFilePC, num2str(i),'.dcm']);
    time(i)=Inf.TriggerTime;
end
t=time-time(1);
Pixel_x=Inf.PixelSpacing(1);
Pixel_y=Inf.PixelSpacing(2);
Pixel_z=Inf.SliceThickness;
%%
figure; imagesc(Matrice_Modulo(:,:,16)); colormap gray;
contour=drawfreehand('color','r');
ROI=double(contour.createMask());
K=0;
for i=1:L
    for j=1:L
      if ROI(i,j)~=0
            K=K+1;
        end
    end
end
Area=(0.1*Pixel_x*0.1*Pixel_y)*K;
Volume=Area*Pixel_z*0.1;
%%
V_max=zeros(N,1);
V_media=zeros(N,1);
V_min=zeros(N,1);
F_min=zeros(N,1);
F_media=zeros(N,1);
F_max=zeros(N,1);
for i=1:N
     Maschera=Matrice_Fase(:,:,i).*ROI;
     V_max(i)=max(max(nonzeros(Maschera)))/(Vscale);
     F_max(i)=V_max(i)*Area/60;
     V_media(i)=mean((nonzeros(Maschera)))/(Vscale);
     F_media(i)=V_media(i)*Area/60;
     V_min(i)=min(min(nonzeros(Maschera)))/(Vscale);
     F_min(i)=V_min(i)*Area/60;
end
figure; plot(t,V_media,'r'); hold on; plot(t, V_min,'b'); hold on; plot(t, V_max, 'y'); grid on;
legend('media','min','max');ylabel('velocity [cm/s]'); xlabel('time [ms]');
figure; plot(t,F_media,'r'); hold on; plot(t, F_min,'b'); hold on; plot(t, F_max, 'y'); grid on;
legend('media','min','max');ylabel('flow [L/min]'); xlabel('time [ms]');



         


    