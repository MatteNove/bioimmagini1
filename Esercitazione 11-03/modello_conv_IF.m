function Ct = modello_conv_IF(k, time, Cp)

vB = k(5);


dt = 0.1;
t  = 0:dt:time(end);
IF = max(0,interp1(time,Cp,t,'linear',0) );

sol = conv(modello_exp(k, t), IF)*dt;
tsol = (0:dt:2*max(t));

% % Taking into account natural radioactive decay
% -----  N.B. Our data are compensated yet!!!
%dk = log(2)/109.8;  % radioactive decay constant for F-18 
%sol = sol .* exp(-dk * tsol);

% Taking into account blood fraction in tissue
sol = max(0,interp1(tsol,sol,time,'linear',0) );
Ct = (1-vB)*sol + vB* Cp;
Ct(Ct<=0) = eps;
end





