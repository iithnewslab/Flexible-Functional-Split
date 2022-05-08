function S = Packet_serving_LTE()
no_RB = 50;
consume_RB = 0;
available_RB = [50 50 50 50];
global packet packet_size  usedRB packet_served;
global no_UE no_eNB sinr_eachUE asso_lte asso_wifi interface_association throughput_calc efficent_bit_persymbol total_throughput;
actual_coding_rate = 0;

usedRB = zeros(1, no_eNB);
throughput_calc = zeros(8,no_UE);
total_throughput = zeros(8,no_UE);
packet_served = zeros(8,no_UE);

efficent_bit_persymbol = zeros(1,no_UE);
sinr_eachUE = ones(1,no_UE)*25;

for u = 1:no_UE
    if(sinr_eachUE(u) < 5.2)
        actual_coding_rate = 602 /1024;
        efficent_bit_persymbol(u) = 2*actual_coding_rate;
    elseif(sinr_eachUE(u) < 6.1)
        actual_coding_rate = 378 /1024;
        efficent_bit_persymbol(u) = 4*actual_coding_rate;
    elseif(sinr_eachUE(u) < 7.55)
        actual_coding_rate = 490 /1024;
        efficent_bit_persymbol(u) = 4*actual_coding_rate;
    elseif(sinr_eachUE(u) < 10.85)
        actual_coding_rate = 616 /1024;
        efficent_bit_persymbol(u) = 4*actual_coding_rate;
    elseif(sinr_eachUE(u) < 11.55)
        actual_coding_rate = 466 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 12.75)
        actual_coding_rate = 567 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 14.55)
        actual_coding_rate = 666 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 18.15)
        actual_coding_rate = 772 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 19.25)
        actual_coding_rate = 873 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) > 19.25)
        actual_coding_rate = 948 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    end
end

% for u = 1:no_UE
%     for f = 1: 8
%         if(max(asso_lte(:,u)) == 1)
%             interface_association(f,u) = 1; % 1 = LTE Interface 2 = wifi Interface
%         elseif(max(asso_lte(:,u)) == 0 && max(asso_wifi(:,u)) == 1)
%             interface_association(f,u) = 2; % 2 = wifi Interface
%         end
%     end
% end

interface_association = ones(8,no_UE);
asso_lte = zeros(no_eNB, no_UE);

for i = 1:no_UE
    temp = randi(no_eNB);
    asso_lte(temp,i) = 1;
end


for f = 1:8
    for u = 1:no_UE
        if(interface_association(f,u) == 1 && packet(f,u) > 0)
            [M,I] = max(asso_lte(:,u));
            no_packet = floor(available_RB(I) * 168 * efficent_bit_persymbol(u) / ( packet_size(f) * 8));
            consume_RB = ceil((min(packet(f,u), no_packet) * packet_size(f) * 8) / (168 * efficent_bit_persymbol(u)));
            if(available_RB(I) > consume_RB && consume_RB > 0)
                available_RB(I) = available_RB(I) - consume_RB;
                usedRB(I) = usedRB(I) + consume_RB;
                throughput_calc(f,u) = throughput_calc(f,u) + (min(packet(f,u), no_packet) * (packet_size(f)));
                total_throughput(f,u) = total_throughput(f,u) + (min(no_packet,packet(f,u)) * (packet_size(f)));
                if(f <= 4)
                    packet_served(f,u) = packet_served(f,u) + min(packet(f,u), no_packet);
                end
                packet(f,u) = packet(f,u) - (min(packet(f,u), no_packet));
                
                
                
            elseif(available_RB(I) < consume_RB && consume_RB > 0)
                % do nothing
            end
        end
    end
end
S = packet;
end