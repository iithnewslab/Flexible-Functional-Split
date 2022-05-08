%% Data Rate
% clear all

n_UE = 100;
duration = 1e3; %1000ms or tti = 1s
t = linspace(0,1,duration);
data_Rate =  (725 + 2100*sinc(3*t + 1.7))*4; %4Gbps is max
% plot(t,data_Rate)
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
max_RTx = 4000;
RLC_RTx_CU = zeros(2,max_RTx); %Row1: PDUs, Row2: ACK_Timer (or NACK)
RLC_RTx_DU = zeros(2,max_RTx);
PER = 1e-06; %Packet Error Rate
n_GBR_UEs = 50;
IP_pckt_per_tti_GBR = sum(data_Rate_UE(1:n_GBR_UEs,:),1);
IP_pckt_per_tti_NonGBR = sum(data_Rate_UE(n_GBR_UEs+1:end,:),1);

split = 6;

for tti = 1:duration
    %% TO-DO
    %Migration occurs at tti=207 (BW_req for MAC-PHY exceeds
    %Max_BW)
    
%     if(tti==207)
%         split = 2;
%         %RLC_RTx_DU(1,1:IP_pckt_per_tti_GBR(tti)) = 1; %Fist store new GBR flows
%     end
    if(tti>200 && tti<222)
        RLC_RTx_CU_count(tti-200) = find(~RLC_RTx_CU(1,:),1);
        RLC_RTx_DU_count(tti-200) = find(~RLC_RTx_DU(1,:),1);
    end
    if(tti>=207 && tti<207+8) %For next 8ms while migrating send RTx CU to RTx DU of RLC using Logical Link
        split = 2;
        temp_i = find(RLC_RTx_CU(2,:)==8);
        first = find(~RLC_RTx_DU(1,:),1); %index of first 0
        RLC_RTx_DU(:,first:length(temp_i)+first-1) = RLC_RTx_CU(:,temp_i); %Copy Buffer for which ACK is about to come i.e. t=8
        RLC_RTx_CU(:,temp_i) = 0; %Delete elements from CU that are set to DU using logical link
        
        %Rearrage CU Buffer Elements
        temp_i = find(RLC_RTx_CU(1,:));
        RLC_RTx_CU(:,1:length(temp_i)) = RLC_RTx_CU(:,temp_i);
        RLC_RTx_CU(:,length(temp_i)+1:end) = 0;
        
        %Increment the count of CU RLC_RTx
        first = find(~RLC_RTx_CU(1,:),1); %index of first 0
        RLC_RTx_CU(2,1:first-1) = RLC_RTx_CU(2,1:first-1) + 1;
        
    end
    switch split
        case 6
            %1. Copy packets to RLC RTx
            first = find(~RLC_RTx_CU(1,:),1); %index of first 0
            if(~isempty(first)) %if buffer is not full
                RLC_RTx_CU(1,first:min(max_RTx,IP_pckt_per_tti_GBR(tti)+first-1))=1;
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
        case 2
            %1. Copy packets to RLC RTx
            first = find(~RLC_RTx_DU(1,:),1); %index of first 0
            if(~isempty(first)) %if buffer is not full
                RLC_RTx_DU(1,first:min(max_RTx,IP_pckt_per_tti_GBR(tti)+first-1))=1;
            end
            
            %2. Receive ACK/NACK
            if first~=1
                for i = 1:first-1
                    if mod(RLC_RTx_DU(2,i),8)==0
                        if binornd(1,PER)~=1 %ACK or NACK
                            RLC_RTx_DU(:,i)=0;
                        end
                        
                    end
                end
            end
            
            %Rearrage Buffer Elements
            temp_i = find(RLC_RTx_DU(1,:));
            RLC_RTx_DU(:,1:length(temp_i)) = RLC_RTx_DU(:,temp_i);
            RLC_RTx_DU(:,length(temp_i)+1:end) = 0;
            
            
            %3. Increment the count of RLC_RTx
            first = find(~RLC_RTx_DU(1,:),1); %index of first 0
            RLC_RTx_DU(2,1:first-1) = RLC_RTx_DU(2,1:first-1) + 1;
    end
    
end

% function BW_req()
%% Plot Buffer Content during migration
tti_temp = 201:221;
stairs(tti_temp,RLC_RTx_CU_count,'LineWidth',2)
grid on
hold on
stairs(tti_temp,RLC_RTx_DU_count,'LineWidth',2)
% set(gca,'XTickLabel',[201 202])
set(gca,'XTick',[201:2:221])
xlabel("tti")
legend("RLC RTx CU", "RLC RTx DU")
ylabel("Buffer content during migration")
