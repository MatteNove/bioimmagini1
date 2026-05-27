function [R]=patalck_fun(Tac,time,LC,Cp,LV,lat,sept)

figure; plot(time,LV,'r'); legend('ventricolo sx');
hold on; plot(time,lat,'g'); legend('laterale');
hold on; plot(time,sept,'b'); legend('ventricolo sx','laterale','setto');

int_Cp=cumtrapz(time,LV);
Y1=lat./LV;
Y2=sept./LV;
X=int_Cp./LV;
figure; scatter(X,Y1,'b'); hold on; scatter(X,Y2,'r'); legend('parete laterale','setto');

A1=[Y1(16),Y2(21)];
A2=[Y1(19),Y1(22)];
B1=[X(16),X(21)];
B2=[X(19),X(22)];
coeff_1=polyfit(B1,A1,1);
coeff_2=polyfit(B2,A2,1);
x=0:1000:6000;
y1=coeff_1(1)*x+coeff_1(2);
y2=coeff_2(1)*x+coeff_2(2);
figure; scatter(X,Y1,'b'); hold on; scatter(X,Y2,'r');
hold on; plot(x,y1,'r'); hold on; plot(x,y2,'b');

m_setto=coeff_1(1);
m_lat=coeff_2(1);



R=m_lat*(Cp/(LC*60));
%%R_setto=m_setto*(Cp/(LC*60)); 
