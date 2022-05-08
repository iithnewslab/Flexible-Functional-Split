%% BW requirements

%
z = 1e3;
t = linspace(0,1,z);
%
% % IP_DL_TTI = 1 + rand(1,z) + 3.5*(2+ sin(10*t) + sin(5*t));
IP_DL_TTI = 4 + 0.6*sinc(3*t + 1.7);% + 0.05*rand(1,z);
% % IP_DL_TTI = smooth(IP_DL_TTI);
% IP_DL_TTI = unifrnd(1,7,[1 1000]);
% plot(t,IP_DL_TTI)
%
N_TBS_DL = 2;
set(gca, 'YScale', 'log');
user_traffic  = IP_DL_TTI*N_TBS_DL*(1500)*8*1000/1e6;


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


Max_BW = 98*ones(1,z);

%% Dynamic Split
Dynamic_load = zeros(1,z);
for i = 1:100
%     if (PDCP_RLC < Max_BW,RLC_MAC,Split_MAC,MAC_PHY )
    temp_1 = PDCP_RLC(i);
    temp_2 = RLC_MAC(i);
    temp_3 = Split_MAC(i);
    temp_4 = MAC_PHY(i);
    Dynamic_load(i) = max([temp_1,temp_2,temp_3,temp_4]);
    if(Dynamic_load(i)>Max_BW)
        Dynamic_load(i) = max([temp_1,temp_2,temp_3]);
        if(Dynamic_load(i)>Max_BW)
            Dynamic_load(i) = max(temp_1,temp_2);
            if(Dynamic_load(i)>Max_BW)
                Dynamic_load(i) = temp_1;
            end
        end 
    end
end
%% Plots

plot(t,user_traffic,'LineWidth',2)
hold on
plot(t,PDCP_RLC,'--','LineWidth',2)
plot(t,RLC_MAC,'--','LineWidth',2)
plot(t,Split_MAC,'--','LineWidth',2)
plot(t,MAC_PHY,'--','LineWidth',2)
% plot(t,Split_1,'LineWidth',2)
plot(t,Max_BW,'--','LineWidth',2);

plot(t,Dynamic_load,'LineWidth',2)

% plot(t,Split_4)
legend('User Traffic','PDCP-RLC','RLC-MAC','Intra-MAC','MAC-PHY','Max-BW','Adaptive-split')%, 'Intra-PHY')
xlabel('t')
ylabel('Fronthaul BW required (Mbps)')
hold off

