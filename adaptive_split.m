t = linspace(0,1,100);
BW_th = 5;

t_IoT = 1+sin(10*t);
t_URLLC = 2*rand(1,100); %2;
t_eMBB = 1;

fronthaul_t = t_IoT+t_URLLC+t_eMBB;

% plot(t,t1);
plot(t,t_IoT+t_URLLC+t_eMBB);


adp_t = [];
for i=1:length(t)
    adp_t(i) = fronthaul_traffic(t_IoT(i),t_URLLC(i),t_eMBB,BW_th);
end

hold on;
plot(t,adp_t)