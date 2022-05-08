%% Data Rate
% clear all

n_UE = 100;
duration = 1e3; %1000ms or tti = 1s
t = linspace(0,1,duration);
data_Rate =  700 + 2100*sinc(3*t + 1.7);
plot(t,data_Rate)
IP_pckt_per_tti = ceil(data_Rate*1024/(1500*8));
data_Rate_UE = zeros(n_UE,duration);
for t = 1:duration
    chocolate = IP_pckt_per_tti(t);
    for i = 1:chocolate
        r = randi(100);
        data_Rate_UE(r,t) = data_Rate_UE(r,t)+1;
    end
end

%% ReTx RLC
RTT = 8; %Round-Trip Time for LTE
RLC_RTx_CU = zeros(2,150); %Row1: PDUs, Row2: ACK_Timer (or NACK)
RLC_RTx_DU = zeros(2,150);
PER = 1e-06; %Packet Error Rate
n_GBR_UEs = 50;
IP_pckt_per_tti_GBR = sum(data_Rate_UE(1:n_GBR_UEs,:),1);
IP_pckt_per_tti_NonGBR = sum(data_Rate_UE(n_GBR_UEs+1:end,:),1);

split = 6;

for tti = 1:duration
    
    %Let's say migration occur at tti=200
    %% TO-DO
%     if(tti==200)
%         split = 2;
%         RLC_RTx_DU(1,1:IP_pckt_per_tti_GBR(tti)) = 1; %Fist store new GBR flows
%         
%         RLC_RTx_DU(:,IP_pckt_per_tti_GBR(tti)) 
%         
%     end
%%    
    %1. Copy packets to RLC RTx
    first = find(~RLC_RTx_CU(1,:),1); %index of first 0
    if(~isempty(first)) %if buffer is not full
       RLC_RTx_CU(1,first:min(150,IP_pckt_per_tti_GBR(tti)+first-1))=1;
    end
    
    %2. Receive ACK/NACK
    if first~=1
        for i = 1:first-1
            if mod(RLC_RTx_CU(2,i),8)==0
                if binornd(1,PER)~=1 %ACK or NACK
                    RLC_RTx_CU(:,i)=0;
                end
                
            end
        end
    end
    
    %Rearrage Buffer Elements
    temp_i = find(RLC_RTx_CU(1,:));
    RLC_RTx_CU(:,1:length(temp_i)) = RLC_RTx_CU(:,temp_i);
    RLC_RTx_CU(:,length(temp_i)+1:end) = 0;
    
    
    %3. Increment the count of RLC_RTx
    first = find(~RLC_RTx_CU(1,:),1); %index of first 0
    RLC_RTx_CU(2,1:first-1) = RLC_RTx_CU(2,1:first-1) + 1;
end

% function BW_req()
