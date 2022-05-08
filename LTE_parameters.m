% function [] = LTE_parameters()

global no_UE no_eNB packet_size data_Rate;
global packet usedRB packet_served;
global sinr_eachUE asso_lte asso_wifi interface_association throughput_calc efficent_bit_persymbol total_throughput;
global inter_packet_time packet_interval dynamic_flow;

no_UE = 100;
no_eNB = 4;
packet_size = [320 80 760 1024 1024 760 1024 1024]; % packet size for each flow in Bytes
data_Rate = [87.2 1.5 1200 1200 128 128 128 128]; % data rate for each flow in Kbps according to skype

% end