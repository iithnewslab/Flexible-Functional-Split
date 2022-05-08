function IP_UE = IP_pkt_generation(data)
counter = 0;
global n_UE
IP_UE = zeros(n_UE,100) %UExtti
data_per_UE = poissrnd(500,[n_UE,1]); %500Kbps
packet_interval = floor(data_per_UE*1000/(1500*8));
for tti = 1:100
    
end
end

