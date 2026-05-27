N=70;
L=512;
Matrice_immagini=zeros(L,L,N);
for nImm=1:N
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    Matrice_immagini(:,:,nImm)=IMM;
end

trigger_time=zeros(39,1);
for nImm = 1:N
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    b= INF.TriggerTime;
    trigger_time(nImm)=b;
end
t0=trigger_time(1);
time=trigger_time-t0;
time=time./1000;
%%
%figure; imagesc(Matrice_immagini(:,:,16)); colormap gray;
%contour=drawfreehand('color','r');
%ROI_AORTA=double(contour.createMask());
ROI_AORTA=zeros(L);
ROI_AORTA(132,272)=1;
C_a=zeros(length(time),1);
for i=1:N
     maschera_vaso=Matrice_immagini(:,:,i).*ROI_AORTA;
     C_a(i)=mean((nonzeros(maschera_vaso)));
end
%figure; plot(time,C_a,'b');
%%
%figure; imagesc(Matrice_immagini(:,:,16)); colormap gray;
%contour=drawfreehand('color','r');
%ROI_RENE=double(contour.createMask());
ROI_RENE=zeros(L);
ROI_RENE(259,370)=1;
C_t=zeros(length(time),1);
for i=1:N
     maschera_tessuto=Matrice_immagini(:,:,i).*ROI_RENE;
     C_t(i)=mean((nonzeros(maschera_tessuto)));
end
%figure; plot(time,C_t,'r');
%%
figure; plot(time,C_a,'b'); hold on; plot(time,C_t,'r');
A=[C_t(10),C_t(16)];
B=[time(10),time(16)];
coeff=polyfit(B,A,1);
m=coeff(1);
q=coeff(2);
t_star=13:0.1:24;
fit=t_star.*m+q;
hold on; plot(t_star,fit); grid on; legend('Ca','Ct','fit');
xlabel('time[s]');

