%% BW requirements

%
z = 1e2;
t = linspace(0,1,z);
%
% % IP_DL_TTI = 1 + rand(1,z) + 3.5*(2+ sin(10*t) + sin(5*t));
IP_DL_TTI = 7 + 1.5*sinc(3*t + 1.7);% + 0.05*rand(1,z);
% % IP_DL_TTI = smooth(IP_DL_TTI);
% IP_DL_TTI = unifrnd(1,7,[1 1000]);
% plot(t,IP_DL_TTI)
%
N_TBS_DL = 2;
set(gca, 'YScale', 'log');
user_traffic  = IP_DL_TTI*N_TBS_DL*(1500-32)*8*1000/1e6;


% RRC_PDCP = (IP_DL_TTI*IP_pkt*N_TBS_DL*8*1000)/1e6;
% PDCP_RLC = (IP_DL_TTI*(IP_pkt+Hdr_PDCP)*N_TBS_DL*8*1000)/1e6;
% RLC_MAC = (IP_DL_TTI*(IP_pkt+Hdr_PDCP+Hdr_RLC)*N_TBS_DL*8*1000)/1e6;
% Split_MAC = ((IP_DL_TTI*(IP_pkt+Hdr_PDCP+Hdr_RLC+Hdr_MAC)*N_TBS_DL*8*1000)/1e6) + Sched;
% MAC_PHY = ((IP_DL_TTI*(IP_pkt+Hdr_PDCP+Hdr_RLC+Hdr_MAC)*N_TBS_DL*8*1000)/1e6) + FAPI_DL;

RRC_PDCP = BW_required_fn(IP_DL_TTI,1,1);
PDCP_RLC = BW_required_fn(IP_DL_TTI,2,1);
RLC_MAC = BW_required_fn(IP_DL_TTI,4,1);
Split_MAC = BW_required_fn(IP_DL_TTI,5,1);
MAC_PHY = BW_required_fn(IP_DL_TTI,6,1);
Split_PHY_1 = BW_required_fn(IP_DL_TTI,7,1);
Split_PHY_2 = BW_required_fn(IP_DL_TTI,7,2);
Split_PHY_3 = BW_required_fn(IP_DL_TTI,7,3);
Split_PHY_3b = BW_required_fn(IP_DL_TTI,7,32);
Split_PHY_4 = BW_required_fn(IP_DL_TTI,7,4);

Split_1 = Split_PHY_1*ones(1,z);
Split_2 = Split_PHY_2*ones(1,z);
Split_3 = Split_PHY_3*ones(1,z);
Split_4 = Split_PHY_4*ones(1,z);

%% Plots

plot(t,user_traffic,'LineWidth',2)
hold on
plot(t,PDCP_RLC,'LineWidth',2)
plot(t,RLC_MAC,'LineWidth',2)
plot(t,Split_MAC,'LineWidth',2)
plot(t,MAC_PHY,'LineWidth',2)
plot(t,Split_1,'LineWidth',2)

% plot(t,Split_4)
xlabel('t')
ylabel('Fronthaul BW required')
legend('User Traffic','PDCP-RLC','RLC-MAC','Intra-MAC','MAC-PHY', 'Intra-PHY')

hold off