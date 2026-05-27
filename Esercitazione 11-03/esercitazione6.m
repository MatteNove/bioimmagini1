clear all
close all


%% 1.a Determinazione della curva tempo attività relativa all 
load("dataset.mat"); %47 fette per ciascun volume con un totale di 24 volumi
t=PETInfo.time;
N=24; %numero di fette
figure; imagesc(Volume(:,:,7,4)); title('ROI VASO');
contour=drawfreehand('color','r');
ROI_VASO=double(contour.createMask());
C_vaso=zeros(length(t),1);
for i=1:N
     maschera_vaso=Volume(:,:,7,i).*ROI_VASO; 
     C_vaso(i)=mean((nonzeros(maschera_vaso)));
end
figure; plot(t,C_vaso); xlabel('time'); ylabel('C vaso');
%% 1.b Determinazione della curva tempo attività relativa ad una ROI
figure; imagesc(Volume(:,:,20,23)); title('ROI TESSUTO');
contour=drawfreehand('color','r');
ROI_TESSUTO=double(contour.createMask());
C_tessuto=zeros(length(t),1);
for i=1:N
     maschera_tessuto=Volume(:,:,20,i).*ROI_TESSUTO;
     C_tessuto(i)=mean((nonzeros(maschera_tessuto)));
end
figure; plot(t,C_vaso,'r'); hold on; plot(t,C_tessuto,'b'); legend('C vaso','C tessuto');
xlabel('time [s]'); ylabel('Concentrazione');

%% Calcolo del  fractional uptake’ nella ROI selezionata
int_Cp=cumtrapz(t,C_vaso);
Y=C_tessuto./C_vaso;
X=int_Cp./C_vaso;
Y(1)=0;% troppo grande devo mettere a zero
figure; scatter(X,Y,'r');
A=[Y(18),Y(24)];
B=[X(18),X(24)];
coeff=polyfit(B,A,1);
t_=0:200:3550;
y=coeff(1)*t_+coeff(2);
figure; scatter(X,Y,'r'); hold on; plot(t_,y,'b');
m=coeff(1);
LC=0.81;
Cp=55.2805;
R=m*(Cp/(LC));

%% 1.B : Metodo analitico
lb=[0, 0, 0, 0,0]; %lower bound
ub=[10, 1, 1, 1, 1]; %upper bound
K0=[0.1, 0.1, 0.01, 0.01, 0.1]; %valori iniziali 
%Ct=modello_exp(K0,t)
Ct1=@(k,t)modello_conv_IF(k,t,C_vaso)
[p_est,resnorm,~,exitflag,output]=lsqcurvefit(Ct1,K0,t,C_tessuto,lb,ub);
y_fit=modello_conv_IF(p_est,t,C_vaso);
figure; plot(t,C_tessuto,'r'); hold on; plot(t,y_fit,'b'); hold on; plot(t,C_vaso);
%% GENERAZIONE MAPPE PARAMETRICHE
figure; imagesc(Volume(:,:,20,23));
contour=drawfreehand('color','r');
ROI_CERVELLO=double(contour.createMask());
N=128;
RR=zeros(N);
tic
for i=1:N
    for j=1:N
        C_tessuto=zeros(length(t),1);
        for k=1:24
            C_tessuto(k)=Volume(i,j,20,k);
        end
         if ROI_CERVELLO(i,j)~=0    
            Y=C_tessuto./C_vaso;
            Y(1)=0;% troppo grande devo mettere a zero
            A=[Y(18),Y(24)];
            B=[X(18),X(24)];
            coeff=polyfit(B,A,1);
            m=coeff(1);
            LC=0.81;
            Cp=55.2805;
            RR(i,j)=m*(Cp/(LC));
         end
     end
end
figure; subplot(1,2,1); imagesc(RR); colorbar; title('Fractional uptake');
pippo=toc;
subplot(1,2,2); imagesc(Volume(:,:,20,23)); colorbar; title ('imm');
%%
Volume=Volume.*1000;
K1=zeros(N);
K2=zeros(N);
K3=zeros(N);
K4=zeros(N);
VB=zeros(N);
Ri=zeros(N);
figure; imagesc(Volume(:,:,20,23));
contour=drawfreehand('color','r');
ROI_CERVELLO=double(contour.createMask());
for i=1:N
    for j=1:N
        C_tessuto=zeros(length(t),1);
        for k=1:24
            C_tessuto(k)=Volume(i,j,20,k);
        end
        if ROI_CERVELLO(i,j)~=0  
           [p_est,resnorm,~,exitflag,output]=lsqcurvefit(Ct1,K0,t,C_tessuto,lb,ub);
           K1(i,j)=p_est(1);
           K2(i,j)=p_est(2);
           K3(i,j)=p_est(3);
           K4(i,j)=p_est(4);
           VB(i,j)=p_est(5);
           Ri(i,j)=((p_est(1)*p_est(3))/(p_est(1)+p_est(2)))*(Cp/LC);
         end
     end
 end
figure; subplot(2,3,1); imagesc(K1); title('k1');
subplot(2,3,2); imagesc(K2); title('k2');
subplot(2,3,3); imagesc(K3); title('k3');
subplot(2,3,4); imagesc(K1); title('k4');
subplot(2,3,5); imagesc(VB); title('vB');
subplot(2,3,1); imagesc(Ri); title('R');



