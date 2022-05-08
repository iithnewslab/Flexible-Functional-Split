function p = Pkt_Generation(qw)
% persistent packet_interval;
global inter_packettime no_UE packet_interval dynamic_flow packet packet_generated;
%%%------------------------------%%%
%dynamic_flow = zeros(8,no_UE); %check line 47-57 in Rate_main
% for u = 1: 8
%     for r = 1: no_UE
%         if((rand(1,1) * 800) < (poissrnd(100,1,1)))
%             dynamic_flow(u,r) = 1;
%         else
%             dynamic_flow(u,r) = 0;
%         end
%     end
% end

% for j = 1 : 8
%     inter_packettime(j) = floor((packet_size(j) * 8 * 1000) / (data_Rate(j) * 1000));
%     %multiplication of 1000 is to convert time in ms?
% end
% for xu = 1 : no_UE
%     packet_interval(:,xu) = inter_packettime;
% end %line 63-68

% packet_size = [320 80 760 1024 1024 760 1024 1024]; % packet size for each flow in Bytes
% line 34

% data_Rate = [87.2 1.5 1200 1200 128 128 128 128]; % data rate for each flow in Kbps according to skype
% line 36

% packet and packet_generated are same?
% 8 types?

%%%------------------------------%%%

% if isempty(packet_interval)
%     for xu = 1 : no_UE
%         packet_interval(:,xu) = inter_packettime;
%     end
% end
% lambda = 2;

for kl =1 : no_UE
    for jl = 1 : 8
        if(dynamic_flow(jl,kl) ==1)
            if((mod(qw,3000)==0 || qw ==1) && jl <= 4)
                packet(jl,kl) = packet(jl,kl) + 1;
                packet_generated(jl,kl) = packet_generated(jl,kl) + 1;
                %       break;
            elseif((mod(qw,3000)==0 || qw ==1) && jl >4)
                packet_interval(jl,kl) =  poissrnd(inter_packettime(jl),1,1);
                %         break;
            end
            if( mod(qw,3000)~=0 && qw ~=1)
                if(jl <=4 && packet_interval(jl,kl) == 1)
                    packet(jl,kl) = packet(jl,kl) + 1;
                    packet_generated(jl,kl) = packet_generated(jl,kl) + 1;
                    packet_interval(jl,kl) = inter_packettime(jl);
                elseif(jl <=4 && packet_interval(jl,kl) > 1)
                    packet_interval(jl,kl) = packet_interval(jl,kl) - 1;
                elseif(jl > 4 && packet_interval(jl,kl) == 1)
                    packet(jl,kl) = packet(jl,kl) + 1;
                    %                 packet_generated(jl,kl) = packet_generated(jl,kl) + 1;
                    packet_interval(jl,kl) =  poissrnd(inter_packettime(jl),1,1);
                elseif(jl > 4 && packet_interval(jl,kl) > 1)
                    packet_interval(jl,kl) = packet_interval(jl,kl) - 1;
                end
            end
        end
    end
end
% if(i==1)
%     packet = packet + 1;
%     lambda = 5;
% elseif(lambda == 0)
%     packet = packet + 1;
%     lambda = 5; pkt
% else
%     lambda = lambda - 1;
% end
% for i = 1: no_UE
%     packet(i) = packet(i) + poissrnd(lambda,1,1);
% end
% t = packet;
p = packet;
end