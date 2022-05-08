n_DU = 10;
BW_max = 4200*n_DU; %Gbps
duration = 1e2;
t = linspace(0,1,duration);
data_Rate_1 = (600 + 3000*sinc(3*t + 1.6))*4;
data_Rate_2 = 2100 + 1900*sin(5*(t));
data_Rate_3 = 2100 - 1900*sin(5*(t));
data_Rate_4 = (600 + 3000*sinc(3*(1-t) + 1.6))*4;
data_Rate_5 = -(1000*sin(5*(-t)) + 1000*cos(10*(-t))) + 1500;
data_Rate_6 = 800 + data_Rate_1-0.4*data_Rate_2;
data_Rate_7 = 800 + (600 + 3000*sinc(3*(1-t) + 1.6))*4-0.4*(2100 + 1900*sin(5*((1-t))));
data_Rate_8 = 2100 - 500*sin(10*(t)) + 8000*sinc(5*t+1.6);
data_Rate_9 = 2500 - 500*cos(10*(t)) + 8000*sinc(5*t+1.6);
data_Rate_10 = 1500*cos(5*((1-t))) + 8000*sinc(5*(1-t)+1.6)+ 1800;

% plot(t,data_Rate_1)
% hold on
% plot(t,data_Rate_2)
% plot(t,data_Rate_3)
% plot(t,data_Rate_4)
% plot(t,data_Rate_5)
% plot(t,data_Rate_6)
% plot(t,data_Rate_7)
% plot(t,data_Rate_8)
% plot(t,data_Rate_9)
% plot(t,data_Rate_10)