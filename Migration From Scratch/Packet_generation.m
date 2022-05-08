function [P] = Packet_generation(qw)

qw  = 1;
global data_rate_actual inter_packet_time no_UE packet_interval dynamic_flow packet;
%%%------------------------------%%%
no_UE = 100;
data_rate_actual = zeros(1,8);
packet_interval = zeros(8,no_UE);
packet_size = [320 80 760 1024 1024 760 1024 1024]; % packet size for each flow in Bytes
data_Rate = [87.2 1.5 1200 1200 128 128 128 128]; % data rate for each flow in Kbps according to skype
% no_UE = 100;

for f = 1:8
    inter_packet_time(f) = floor((packet_size(f)*8*1000) / (data_Rate(f)*1000));
end

for u = 1:no_UE
    packet_interval(:,u) = inter_packet_time;
end

dynamic_flow = zeros(8,no_UE);
for f = 1:8
    for u = 1:no_UE
        if((rand(1,1) * 800) < (poissrnd(100,1,1)))
            %         if((rand(1,1) * 800) < (poissrnd(100,1,1)))
            dynamic_flow(f,u) = 1;
        else
            dynamic_flow(f,u) = 0;
        end
    end
end

packet = zeros(8,no_UE);

for u = 1:no_UE
    for f = 1:8
        if(dynamic_flow(f,u) == 1)
            if((mod(qw,3000)==0 || qw ==1) && f <= 4)
                packet(f,u) = packet(f,u) + 1;
            elseif((mod(qw,3000)==0 || qw ==1) && f >4)
                packet_interval(f,u) =  poissrnd(inter_packet_time(f),1,1);
            end
            if(mod(qw,3000)~=0 && qw ~=1)
                if(f <=4 && packet_interval(f,u) == 1)
                    packet(f,u) = packet(f,u) + 1;
                    packet_interval(f,u) = inter_packet_time(f);
                elseif(f <=4 && packet_interval(f,u) > 1)
                    packet_interval(f,u) = packet_interval(f,u) - 1;
                elseif(f > 4 && packet_interval(f,u) == 1)
                    packet(f,u) = packet(f,u) + 1;
                    packet_interval(f,u) =  poissrnd(inter_packet_time(f),1,1);
                elseif(f > 4 && packet_interval(f,u) > 1)
                    packet_interval(f,u) = packet_interval(f,u) - 1;
                end
            end
        end
    end
end

P = packet;
for df = 1:8
    data_rate_actual(df) = packet_size(df)*sum(P(1,:))*8/1e3;  
end
P = sum(P);
end
