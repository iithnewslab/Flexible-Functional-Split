clear all;
% load('IM_2_100Variable')
% load('IM_1_100Variable')
% load('new_100_variable')
load('corrected_IM_variale');
% load('new_IM_100Variable')
% load('Fixed_Power_100variable')
% load('new_100variable')
% load('25_variable');
% load('new_5variable')
% load('5_variable_indoor_optimization');
global total_Time remaining_Time_wifi;
remaining_Time_wifi = zeros(1,4);
total_Time = 10;
global no_UE asso_lte asso_wifi no_eNB actual_dataRate efficent_bit_persymbol;
actual_dataRate = 0;
efficent_bit_persymbol = 0;
% packet = zeros(1,3);
% persistent packet;
global packet usedRB usedTime LOAD_lte LOAD_wifi user_no GBR_not_ensured packet_generated packet_served;
user_no = zeros(1,no_UE); % rank of users after we run TOPSIS algorithm
usedRB = zeros(1,4); % we have 4 eNB
usedTime = zeros(1,4);
% packet = zeros(1,no_UE);
% packet = 0;
packet= zeros(8,no_UE);
packet_generated = zeros(4,no_UE);
packet_served = zeros(4,no_UE);
GBR_not_ensured = zeros(8,no_UE);
global inter_packettime  packet_size data_Rate interface_association throughput_calc total_throughput packet_interval dynamic_flow;
% No of Flows 1 to 8 in their priority order first four flows are GBR and

% last four flows are NGBR
packet_size = [320 80 760 1024 1024 760 1024 1024]; % packet size for each flow in Bytes
% data_Rate = [12 1.5 180 120 128 128 128 128]; % data rate for each flow in Kbps
data_Rate = [87.2 1.5 1200 1200 128 128 128 128]; % data rate for each flow in Kbps according to skype
throughput_calc = zeros(8,no_UE);
total_throughput = zeros(8,no_UE);
dynamic_flow = zeros(8,no_UE);
for d = 1 : no_UE
    for g = 1: 8
        if(max(asso_lte(:,d)) == 1)
            interface_association(g,d) = 1; % 1 = LTE Interface 2 = wifi Interface
        elseif(max(asso_lte(:,d)) == 0 && max(asso_wifi(:,d)) == 1)
            interface_association(g,d) = 2;
        end
    end
end
for u = 1: 8
    for r = 1: no_UE
        if((rand(1,1) * 800) < (poissrnd(100,1,1)))
            dynamic_flow(u,r) = 1;
        else
            dynamic_flow(u,r) = 0;
        end
    end
end

% Split packet equally between interfaces
% packet_Split_equally();

sum_GBR_Flows = sum(dynamic_flow(1,:)) + sum(dynamic_flow(2,:)) + sum(dynamic_flow(3,:)) + sum(dynamic_flow(4,:));
for j = 1 : 8
    inter_packettime(j) = floor((packet_size(j) * 8 * 1000) / (data_Rate(j) * 1000));
end
for xu = 1 : no_UE
    packet_interval(:,xu) = inter_packettime;
end
TOPSIS();
ii = 1;
x1 =0;
x2 = 0;
as =1 ;
while(ii <=10000)
    %Pkt_Generation
    %Pkt_Scheduling
    if(mod(ii,200) == 0)
%         TOPSIS();
%         packet_generatedl
%         packet_served
%         throughput_calc
        GBR_ensured();
%         GBR_not_ensured
        sum(sum(GBR_not_ensured))
        satify_GBR(as) =  sum(sum(GBR_not_ensured));
        no_GBR(as) = sum(dynamic_flow(1,:)) + sum(dynamic_flow(2,:)) + sum(dynamic_flow(3,:)) + sum(dynamic_flow(4,:));
        instant_throughput(as) = sum(sum(throughput_calc)) * 8 / 200;
%         LOAD_lte
%         LOAD_wifi
        QADTS_algorithm();
        if( sum(sum(GBR_not_ensured)) > (sum_GBR_Flows * 15 /100))
%             trigger_RI(as) = 1;
             x1 = x1 + 1;
             manual_lte_power();
             disp('Hello');
        elseif( sum(sum(GBR_not_ensured)) < (sum_GBR_Flows * 15 /100))
            call_optimization();
            x2 = x2 + 1;
%              trigger_RI(as) = 0;
        end
%         
        throughput_calc = zeros(8,no_UE);
        usedRB = zeros(1,no_eNB);
        GBR_not_ensured = zeros(8,no_UE);
        usedTime = zeros(1,no_eNB);
        packet_generated = zeros(4,no_UE);
        packet_served = zeros(4,no_UE);
        LOAD_lte = 0;
        LOAD_wifi = 0;
        as = as + 1;
    end
    if(mod(ii,3000) == 0)
        packet= zeros(8,no_UE);
%         dynamic_flow = zeros(8,no_UE);
        for u = 1: 8
            for r = 1: no_UE
                if((rand(1,1) * 800) < (poissrnd(100,1,1)))
                    dynamic_flow(u,r) = 1;
                else
                    dynamic_flow(u,r) = 0;
                end
            end
        end
%         packet_Split_equally();
%         histogram(dynamic_flow)
    sum_GBR_Flows = sum(dynamic_flow(1,:)) + sum(dynamic_flow(2,:)) + sum(dynamic_flow(3,:)) + sum(dynamic_flow(4,:));
%     call_optimization();
    end
    
%     if(mod(ii,1000) == 0)
%         call_optimization();
%     end
    Pkt_Generation(ii);
    %     packet
    Pkt_Scheduling();
    %     packet
    ii = ii + 1;
end
sum(sum(total_throughput)) * 8 / 10000
for i = 1: no_UE
    throughput_perUE(i) = sum(total_throughput(:,i)) * 8 /10000;
end
mean(satify_GBR)
x1
x2