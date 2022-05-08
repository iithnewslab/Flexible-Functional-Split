format long
global duration IntraPHY_20MHz IntraPHY_40MHz IntraPHY_60MHz
duration = 1e3; %1000ms or tti = 1s
t = linspace(0,1,duration);
% data_Rate =  (725 + 2100*sinc(3*t + 1.7))*4; %4Gbps is max
data_Rate =  (600 + 3000*sinc(3*t + 1.6))*4;
plot(t,data_Rate)

%%
hold on

PDCP_RLC = data_Rate + 16;
MAC_PHY = data_Rate + 133;
%1: Fronthaul BW_req, 2:Max User traffic at that channel BW
IntraPHY_100MHz = [((1200*5)*14*8*7* 2*1000 + 713.9)/1e6,(150*(100/20)*(8/6)*(8/2))];
IntraPHY_80MHz = [((1200*4)*14*8*7* 2*1000 + 713.9)/1e6,(150*(80/20)*(8/6)*(8/2))];
IntraPHY_60MHz = [((1200*3)*14*8*7* 2*1000 + 713.9)/1e6,(150*(60/20)*(8/6)*(8/2))];
IntraPHY_40MHz = [((1200*2)*14*8*7* 2*1000 + 713.9)/1e6,(150*(40/20)*(8/6)*(8/2))];
IntraPHY_20MHz = [((1200*1)*14*8*7* 2*1000 + 713.9)/1e6, (150*(20/20)*(8/6)*(8/2))];
% PHY_RF_20MHz = [(30.72*32*32*1/1000), (150*(20/20)*(8/6)*(8/2))];

y = Dynamic_split(data_Rate);
plot(t,y,'LineWidth',2)
% i_not_centralized = (data_Rate>IntraPHY_60MHz(2));
% plot(t(i_not_centralized), y(i_not_centralized),'g')

yline(6000,'--r','Maximum BW')
yline(IntraPHY_20MHz(1),'--','7-20MHz')
yline(IntraPHY_40MHz(1),'--','7-40MHz')
yline(IntraPHY_60MHz(1),'--','7-60MHz')
yline(IntraPHY_80MHz(1),'--','7-80MHz')
yline(IntraPHY_100MHz(1),'--','7-100MHz')


% ylim([0 6500])

xlabel('time')
ylabel('Traffic on the midhaul (Mbps)')
legend('User Traffic','Adaptive Split','Location','southeast')
% xticks(0:80:1000)
% % xticklabels(0:24
set(gca,'xtick',[])
set(gca,'xticklabel',[])
hold off

% plot(t,PDCP_RLC)%,'--','LineWidth',2)
% plot(t,MAC_PHY)%,'--','LineWidth',2)
% 
% xlabel('t')
% ylabel('Fronthaul BW required (Mbps)')
% yline(4000,'--r','Maximum BW')
% yline(4133,':k')
% %,'Max-BW')
% %find(MAC_PHY>4000,1), when MAC_PHY Exceeds Max BW
% x1=xline(0.207,'--b');
% xl.LabelVerticalAlignment = 'middle';
% xl.LabelHorizontalAlignment = 'center';
% % set(gca,'YTick',[4133])
% ylim([2000 4250])
% legend('User Traffic','PDCP-RLC','MAC-PHY')

function BW = Dynamic_split(User_traffic)
global duration IntraPHY_20MHz IntraPHY_40MHz IntraPHY_60MHz
BW = zeros(duration,1);
for i=1:duration
    if(User_traffic(i)<IntraPHY_20MHz(2))
        BW(i) = IntraPHY_20MHz(1);
    elseif(User_traffic(i)<IntraPHY_40MHz(2))
        BW(i) = IntraPHY_40MHz(1);
    elseif(User_traffic(i)<IntraPHY_60MHz(2))
        BW(i) = IntraPHY_60MHz(1);
    else
        BW(i) = User_traffic(i) + 133;    
    end
end
end
