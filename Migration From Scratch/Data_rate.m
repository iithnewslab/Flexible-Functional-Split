% data_rate = ones(100,1)*100; %(in MBps)
% data_rate_tti = data_rate*1e6/1000;
% IP_pkt_tti = ceil(data_rate_tti/(1500-32));
% %__Define fraction GBR flows?
% RLC_Tx = 0;
% % RLC_RTx = 0;
% pck_drop = 0;
% 
% for tti = 1:length(IP_pkt_tti)
%     if(RLC_Tx<150)
%         if(RLC_Tx+IP_pkt_tti(tti)<=150)
%             RLC_Tx = RLC_Tx + IP_pkt_tti(tti);
%         else
%             pck_drop = pck_drop + (RLC_Tx+IP_pkt_tti(tti)-150);
%             RLC_Tx = 150;
%         end
%     end
% end

%% Packet Generation
global n_UE available_RBs RLC_Tx pck_drop
RLC_Tx = 0;
% RLC_RTx = 0;
pck_drop = 0;
% available_RBs = 50;
n_UE = 100; %poissrnd(50);
% data_rate_UE = poissrnd(5,[n_UE,1]); %MBps, per user data rate
% IP_pkt_UE_tti = ones(n_UE,1);
data_rate_UE_tti = ones(n_UE,1);
for tti = 1:1
    %     data_rate_UE = poissrnd(5,[n_UE,1]); %MBps, per user data rate
    %     for u = 1:n_UE
    %         data_rate_UE_tti(u) = data_rate_UE(u)*1e6/1000; %Bytes per tti
    %         IP_pkt_UE_tti(u) = ceil(data_rate_UE_tti(u)/(1500-32));
    %     end
    IP_pkt_UE_tti = Packet_generation(1);
    serve_pkt(IP_pkt_UE_tti) 
    
end

function serve_pkt(IP_pkt_UE_tti)
global n_UE available_RBs RLC_Tx pck_drop
GBR_UE = poissrnd(ceil(n_UE*0.3)) %no of UEs with GBR
IP_GBR = IP_pkt_UE_tti(1:GBR_UE); %around 30% of user are GBR
IP_non_GBR = IP_pkt_UE_tti(GBR_UE:end);
n_sector = 3;
available_RBs = 50*n_sector; %(10MHz, 2x2 MIMO, 3 sectors)
RB = 168000*2*2; %symbols per second

[Code_rate_UE,Qm] = UE2CodeRate(n_UE);
for u = 1:GBR_UE
    %     actual_rate_UE = IP_pkt_UE_tti(u)*1500;
    if(available_RBs>0)
        RB_req_UE = ceil(IP_pkt_UE_tti(u)*1500*8/(RB*Code_rate_UE(u)*Qm(u)));
        available_RBs = available_RBs - RB_req_UE;
    end
    if(RLC_Tx<150)
        if(RLC_Tx+IP_pkt_UE_tti(u)<=150)
            RLC_Tx = RLC_Tx + IP_pkt_UE_tti(u);
        else
            pck_drop = pck_drop + (RLC_Tx+IP_pkt_UE_tti(tti)-150);
            RLC_Tx = 150;
        end
    end
end
for u = GBR_UE+1:n_UE
    if(available_RBs>0)
        RB_req_UE = ceil(IP_pkt_UE_tti(u)*1500*8/(RB*Code_rate_UE(u)*Qm(u)));
        available_RBs = available_RBs - RB_req_UE;
    end
    %     if(RLC_Tx<150)
    %         if(RLC_Tx+IP_pkt_tti(u)<=150)
    %             RLC_Tx = RLC_Tx + IP_pkt_tti(u);
    %         else
    %             pck_drop = pck_drop + (RLC_Tx+IP_pkt_tti(tti)-150);
    %             RLC_Tx = 150;
    %         end
    %     end
end
end

