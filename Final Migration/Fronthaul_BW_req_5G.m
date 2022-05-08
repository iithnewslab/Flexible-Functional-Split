format long
duration = 1e3; %1000ms or tti = 1s
t = linspace(0,1,duration);
data_Rate =  (725 + 2100*sinc(3*t + 1.7))*4; %4Gbps is max
plot(t,data_Rate)
hold on

PDCP_RLC = data_Rate + 16;
MAC_PHY = data_Rate + 133;

plot(t,PDCP_RLC)%,'--','LineWidth',2)
plot(t,MAC_PHY)%,'--','LineWidth',2)

xlabel('t')
ylabel('Fronthaul BW required (Mbps)')
yline(4000,'--r','Maximum BW')
yline(4133,':k')
%,'Max-BW')
%find(MAC_PHY>4000,1), when MAC_PHY Exceeds Max BW
x1=xline(0.207,'--b');
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
% set(gca,'YTick',[4133])
ylim([2000 4250])
legend('User Traffic','PDCP-RLC','MAC-PHY')

